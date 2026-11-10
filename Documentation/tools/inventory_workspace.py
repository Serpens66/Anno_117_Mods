"""Inventory Anno 117 mod sources without executing game or mod code."""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
import os
from pathlib import Path
import re
import xml.etree.ElementTree as ET


def decode(raw):
    if raw.startswith((b"\xff\xfe", b"\xfe\xff")):
        return raw.decode("utf-16"), "utf-16"
    try:
        return raw.decode("utf-8-sig"), "utf-8-bom" if raw.startswith(b"\xef\xbb\xbf") else "utf-8"
    except UnicodeDecodeError:
        return raw.decode("cp1252", errors="replace"), "cp1252 fallback"


def iter_workspace_files(repo):
    for directory, folders, names in os.walk(repo):
        folders[:] = sorted(name for name in folders if name not in {".git", "Documentation"})
        yield from (Path(directory) / name for name in sorted(names))


def jsonc_to_json(text):
    # Keep strings intact while discarding comments, then remove trailing commas.
    string = r'"(?:\\.|[^"\\])*"'
    tokens = re.compile(f'{string}|//[^\r\n]*|/\\*[\\s\\S]*?\\*/')
    text = tokens.sub(lambda match: match[0] if match[0].startswith('"') else " ", text)
    return re.sub(f'{string}|,(?=\\s*[}}\\]])',
                  lambda match: match[0] if match[0].startswith('"') else "", text)


def inspect(repo, revision):
    entries, mods = [], []
    by_hash, by_id = defaultdict(list), defaultdict(list)
    for path in sorted(iter_workspace_files(repo)):
        rel = path.relative_to(repo)
        if rel.parts[0] in {".git", "Documentation"} or not path.is_file():
            continue
        name = rel.as_posix()
        raw = path.read_bytes()
        sha = hashlib.sha256(raw).hexdigest()
        ext = path.suffix.lower()
        item = {"path": name, "bytes": len(raw), "sha256": sha}
        entries.append(item)
        by_hash[sha].append(name)
        if ext not in {".json", ".jsonc", ".lua", ".xml", ".md", ".txt"} and name != ".gitattributes":
            item["kind"] = "binary/opaque"
            continue
        text, enc = decode(raw)
        item.update(kind=ext.removeprefix(".") or "git attributes", encoding=enc, lines=len(text.splitlines()))
        item["urls"] = sorted(set(re.findall(r'https?://[^\s<>"\x27)]+', text)))
        if path.name.lower() in {"modinfo.json", "modinfo.jsonc"}:
            try:
                metadata = json.loads(jsonc_to_json(text) if ext == ".jsonc" else text)
            except json.JSONDecodeError as exc:
                item["jsonParseError"] = str(exc)
                continue
            keys = ("ModID", "Anno", "Version", "Difficulty", "GameSetup", "Dependencies",
                    "ModDependencies", "LoadAfterIds", "IncompatibleIds", "DLCDependencies",
                    "Options", "Scripts", "ModioResourceId", "changelog")
            mods.append({"path": name, **{k: metadata[k] for k in keys if k in metadata}})
            if metadata.get("ModID"):
                by_id[metadata["ModID"]].append(name)
        elif ext == ".xml":
            try:
                root = ET.fromstring(raw)
            except ET.ParseError as exc:
                item["xmlParseError"] = str(exc)
                continue
            operations = Counter()
            for node in root.iter("ModOp"):
                operation = node.get("Type")
                if operation:
                    operations["legacy:" + operation.lower()] += 1
                else:
                    kinds = set(node.attrib) & {"Add", "AddNextSibling", "AddPrevSibling", "Merge", "Remove", "Replace"}
                    operations["short:" + ",".join(sorted(kinds)) if kinds else "other"] += 1
            item.update(root=root.tag, operations=dict(sorted(operations.items())),
                        constructs={tag: count for tag in ("Group", "Include", "Asset", "ModItem", "ModValue", "ModOpContent")
                                    if (count := sum(1 for _ in root.iter(tag)))},
                        definedAssetIds=sorted({node.text for node in root.findall(".//Asset/Values/Standard/GUID") if node.text}),
                        lineIds=sorted({node.text for node in root.findall(".//LineId") if node.text}),
                        scriptFiles=sorted({node.text for node in root.findall(".//ScriptFileName") if node.text}))
        elif ext == ".lua":
            item["declaredFunctions"] = re.findall(r"^\s*(?:local\s+)?function\s+([\w.:]+)\s*\(", text, re.M)
        elif path.name.lower() == "changelog.txt":
            item["changelogLines"] = text.splitlines()
    return {
        "schema": 1,
        "revision": revision,
        "scope": "Pre-setup working tree; hashes are working-copy bytes, not normalized Git blobs.",
        "fileCount": len(entries),
        "fileKinds": dict(sorted(Counter(entry["kind"] for entry in entries).items())),
        "files": entries,
        "mods": mods,
        "duplicateModIds": {key: paths for key, paths in sorted(by_id.items()) if len(paths) > 1},
        "identicalFiles": [paths for paths in by_hash.values() if len(paths) > 1],
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("repo", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--revision", required=True)
    args = parser.parse_args()
    report = inspect(args.repo, args.revision)
    with args.output.open("x", encoding="utf-8", newline="\r\n") as stream:
        json.dump(report, stream, ensure_ascii=False, indent=2)
        stream.write("\n")
    print(f"{report['fileCount']} files, {len(report['mods'])} mod metadata files.")
