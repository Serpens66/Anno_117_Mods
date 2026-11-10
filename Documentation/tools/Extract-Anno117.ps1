param(
    [Parameter(Mandatory)][string]$RdaExplorerPath,
    [Parameter(Mandatory)][string]$MainDataPath,
    [Parameter(Mandatory)][string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$archives = @(Get-ChildItem -LiteralPath $MainDataPath -Filter '*.rda' -File)
if (-not $archives.Count) { throw "No RDA files in $MainDataPath" }
if (Test-Path -LiteralPath $OutputPath) { throw 'Choose a new output directory for a clean snapshot.' }
[void][Reflection.Assembly]::LoadFrom((Join-Path $RdaExplorerPath 'AnnoRDA.dll'))
$ordered = [AnnoRDA.Loader.ContainerDirectoryLoader]::SortContainerPaths([string[]]$archives.FullName)
$reader = [AnnoRDA.Loader.ContainerFileLoader]::new()
$selected = [Collections.Generic.Dictionary[string,object]]::new([StringComparer]::OrdinalIgnoreCase)
$archiveInfo = [Collections.Generic.List[object]]::new()

function Select-Entries($node, [string]$prefix, [string]$archiveName) {
    foreach ($file in $node.Files) {
        $relative = $prefix + $file.Name
        if ($relative -ne 'data/infotips/export.bin' -and $relative -notmatch '\.(xml|lua|luau|srt)$') { continue }
        # Graphics material descriptors and generated soundbank catalogs live alongside media.
        if ($relative -match '(^|/)(graphics|generatedsoundbanks)(/|$)') { continue }
        if ($relative -match '[\\:]|(^|/)\.{1,2}(/|$)' -or $relative.StartsWith('/')) { throw "Unsafe archive path: $relative" }
        $selected[$relative] = [pscustomobject]@{ Relative = $relative; Archive = $archiveName; Source = $file.ContentsSource }
    }
    foreach ($folder in $node.Folders) { Select-Entries $folder ($prefix + $folder.Name + '/') $archiveName }
}

foreach ($archive in $ordered) {
    $info = Get-Item -LiteralPath $archive
    Write-Host "Indexing $($info.Name)"
    Select-Entries ($reader.Load($archive).Root) '' $info.Name
    $archiveInfo.Add([pscustomobject]@{ Name = $info.Name; Bytes = $info.Length; ModifiedUtc = $info.LastWriteTimeUtc.ToString('o') })
}

$root = [IO.Path]::GetFullPath($OutputPath)
$rootPrefix = $root.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$manifest = @(foreach ($entry in ($selected.Values | Sort-Object Relative)) {
    $destination = [IO.Path]::GetFullPath([IO.Path]::Combine($root, $entry.Relative))
    if (-not $destination.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw "Unsafe destination: $destination" }
    [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($destination))
    $sourceStream = $entry.Source.GetReadStream()
    try {
        $destinationStream = [IO.File]::Open($destination, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write)
        try { $sourceStream.CopyTo($destinationStream) } finally { $destinationStream.Dispose() }
    } finally { $sourceStream.Dispose() }
    $written = (Get-Item -LiteralPath $destination).Length
    if ($written -ne $entry.Source.UncompressedSize) { throw "Size mismatch: $($entry.Relative)" }
    [pscustomobject]@{ Path = $entry.Relative; Archive = $entry.Archive; Bytes = $written; Sha256 = (Get-FileHash -LiteralPath $destination).Hash.ToLowerInvariant() }
})
$receipt = [ordered]@{
    Schema = 1
    ExtractedUtc = [DateTime]::UtcNow.ToString('o')
    ExplorerLibrarySha256 = (Get-FileHash -LiteralPath (Join-Path $RdaExplorerPath 'AnnoRDA.dll')).Hash.ToLowerInvariant()
    Archives = @($archiveInfo.ToArray())
    Files = $manifest
}
$json = ($receipt | ConvertTo-Json -Depth 6).TrimEnd() -replace '\r?\n', "`r`n"
[IO.File]::WriteAllText((Join-Path $root 'anno117-rda-manifest.json'), $json + "`r`n", [Text.UTF8Encoding]::new($false))
$manifest | Group-Object Archive | Select-Object Name,Count
"Extracted $($manifest.Count) files, $(($manifest | Measure-Object -Property Bytes -Sum).Sum) bytes."
