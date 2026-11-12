"""Inventory Serp's 117 IDs without treating references or bundled copies as owners.

Run from any directory with Python + lxml. Default prints a summary; --write updates
the maintained registry, --check verifies it and rejects unexpected asset/text
ownership conflicts. No game, Vanilla, Git, Lua or profile operations are performed.
"""
from pathlib import Path
from collections import defaultdict
import argparse
import re
from lxml import etree as ET

ROOT = Path(__file__).resolve().parents[2]
TARGET = ROOT / 'Documentation/reference/guid-allocations.md'
LOW, HIGH = 1500000000, 1500010000
CHEAT = 'cheat-keybinds-serp'
CHEAT_BLOCK = range(1500001200, 1500001300)
KNOWN_ASSET_COLLISIONS = {
    n: {'change-multiplayer-gamespeed-serp', 'change-multiplayer-gamespeed-complicated-serp'}
    for n in (1500000050, 1500000051, 1500000054)
}


def in_range(value):
    return value.isdecimal() and LOW <= int(value) <= HIGH


def ranges(values):
    values = sorted(set(values))
    result = []
    for n in values:
        if result and n == result[-1][1] + 1:
            result[-1][1] = n
        else:
            result.append([n, n])
    return ', '.join(str(a) if a == b else f'{a}-{b}' for a, b in result) or 'none'


def scan():
    packages = {}
    for name in ('modinfo.json', 'modinfo.jsonc'):
        for path in ROOT.rglob(name):
            if 'Documentation' in path.relative_to(ROOT).parts:
                continue
            match = re.search(r'"ModID"\s*:\s*"([^"]+)"', path.read_text(encoding='utf-8-sig'))
            if not match:
                raise ValueError(f'Missing ModID: {path.relative_to(ROOT)}')
            packages[path.parent] = match.group(1)
    declarations = defaultdict(list)
    references = defaultdict(set)
    for path in sorted(ROOT.rglob('*')):
        if not path.is_file() or path.suffix.lower() not in ('.xml', '.lua', '.luau'):
            continue
        candidates = [p for p in packages if p in path.parents]
        if not candidates:
            continue
        package = max(candidates, key=lambda p: len(p.parts))
        owner = packages[package]
        rel = path.relative_to(ROOT).as_posix()
        if path.suffix.lower() == '.xml':
            tree = ET.parse(str(path))
            for node in tree.xpath('//Standard/GUID | //Text/LineId | //Text[Text]/GUID'):
                value = (node.text or '').strip()
                if in_range(value):
                    kind = 'text' if node.getparent().tag == 'Text' else 'asset'
                    declarations[(kind, int(value))].append((owner, package.relative_to(ROOT).as_posix(), rel))
            for node in tree.xpath('//Asset[@GUID]'):
                value = node.get('GUID', '')
                if in_range(value):
                    declarations[('asset', int(value))].append((owner, package.relative_to(ROOT).as_posix(), rel))
            # Excludes XML comments; includes XPath targets, commands and references.
            text = ' '.join(tree.xpath('//text() | //@*'))
        else:
            text = path.read_text(encoding='utf-8-sig')
            text = re.sub(r'--\[(=*)\[.*?\]\1\]', '', text, flags=re.S)
            text = re.sub(r'--[^\r\n]*', '', text)
        for value in re.findall(r'(?<!\d)15000\d{5}(?!\d)', text):
            if in_range(value):
                references[int(value)].add(owner)
    return packages, declarations, references


def render(packages, declarations, references):
    owners = sorted(set(packages.values()))
    out = [
        '# Serp GUID and text-ID allocations', '',
        'Current workspace register, reviewed 2026-11-12. The user confirms the reserved **inclusive range 1500000000-1500010000**. The [117 public registry](https://github.com/anno-mods/GuidRanges/blob/main/117/guids.md) records the same Serp range. This register covers local packages, not every published or externally installed mod.', '',
        '## Allocation rules', '',
        '- Check this register and rerun the scanner before allocating an ID. Reserve and document the intended owner before implementing. Do not choose IDs merely because a single package does not contain them.',
        '- **1500001200-1500001299 is reserved exclusively for Cheat Keybinds (`cheat-keybinds-serp`).** Gaps inside that block remain reserved to this mod; they are not available to other mods.',
        '- Existing allocations outside this block remain with their recorded owners. References do not transfer ownership. Same-ModID copies are alternative/bundled packages, not independent allocation owners; reconcile their actual contents and never activate incompatible variants together.',
        '- Assets and text LineIDs are separate runtime namespaces. The historical cross-kind reuse below is recorded accurately, but use a distinct numeric ID for new unrelated owners rather than introducing more cross-kind reuse.',
        '- Preserve published IDs. Resolve old collisions by explicit compatibility/isolation or an authorized migration, not silent renumbering. No IDs were changed by this inventory.',
        '- Lua literals and XML targets/references can identify occupied legacy IDs even when their definition is absent here. Reference-only IDs below are held pending provenance research, not offered as free.', '',
        '## Declared allocations by ModID', '',
        'Translation copies are collapsed to one allocation. Numeric ranges below are exact consecutive sets, not a claim that the holes between them are free.', '',
        '| ModID | Asset definitions | Text definitions (LineID / legacy text GUID) |',
        '| --- | --- | --- |',
    ]
    for owner in owners:
        values = {kind: [n for (k, n), records in declarations.items() if k == kind and any(x[0] == owner for x in records)] for kind in ('asset', 'text')}
        if values['asset'] or values['text']:
            out.append(f'| `{owner}` | {ranges(values["asset"])} | {ranges(values["text"])} |')
    out += ['', '## Package boundaries', '', 'Each path is relative to the repository. A nested package belongs to its nearest modinfo file, not to the outer bundle.', '', '| ModID | Package roots |', '| --- | --- |']
    for owner in owners:
        paths = sorted(p.relative_to(ROOT).as_posix() for p, o in packages.items() if o == owner)
        out.append(f'| `{owner}` | ' + '; '.join(f'`{p}`' for p in paths) + ' |')
    out += ['', '## Collisions and repeated copies', '']
    conflicts = []
    for (kind, n), records in sorted(declarations.items()):
        occupied = sorted({record[0] for record in records})
        if len(occupied) > 1:
            conflicts.append((kind, n, occupied))
            out.append(f'- **{kind} {n}:** ' + ', '.join(f'`{x}`' for x in occupied) + '. Do not load the conflicting package set together.')
    cross_kind = sorted({n for kind, n in declarations if ('asset', n) in declarations and ('text', n) in declarations})
    for n in cross_kind:
        asset = sorted({x[0] for x in declarations[('asset', n)]})
        texts = sorted({x[0] for x in declarations[('text', n)]})
        explanation = ' This is not a same-namespace collision.'
        if n == 1500000000:
            explanation += ' In particular, the historical demo asset does not redeclare the Cheat Keybinds text as an asset.'
        out.append(f'- **Cross-kind numeric reuse {n}:** asset owner(s) ' + ', '.join(f'`{x}`' for x in asset) + '; text owner(s) ' + ', '.join(f'`{x}`' for x in texts) + '.' + explanation)
    out += [
        '- Cheat Keybinds Recommended, WIP and historical demo copies share the same ModID. The current Recommended asset IDs and newly added reason-text IDs have no different-ModID declaration owner. Keep those alternative copies mutually exclusive.',
        '- Shared construction-pool helpers are repeated inside bundles under the same ModID. Their different versions/contents must still be reconciled; duplicate ID ownership does not prove byte equivalence.', '',
        '## Reference-only IDs held for investigation', '',
        'These literal values occur in package XML/Lua but have no asset or text definition in the scanned workspace. They may be external dependencies, old 1800 material or arithmetic bases; they are not proven runtime allocations. Comments alone are excluded.', '',
        '| Referencing ModID | IDs without a local declaration |', '| --- | --- |',
    ]
    defined = {n for kind, n in declarations}
    for owner in owners:
        values = [n for n, refs in references.items() if n not in defined and owner in refs]
        if values:
            out.append(f'| `{owner}` | {ranges(values)} |')
    out += ['', '## Refresh and validation', '',
        'Run `python Documentation/tools/inventory_guid_allocations.py --write` to regenerate this maintained register, then `python Documentation/tools/inventory_guid_allocations.py --check` to verify it. Review changed allocations and collisions before accepting the output. Default invocation prints a compact audit summary without changing files.', '',
        'The scanner reads XML declarations (`Standard/GUID`, `Asset @GUID`, text `LineId` and legacy text GUID), XML references/targets, non-comment Lua numeric literals and the nearest package ModID. It does not execute Lua or the mod loader and cannot prove dynamically computed IDs or an unlisted external package set. All in-range numbers in documentation/tests are excluded because they are not game packages.', '',
        f'Scan totals: {len(packages)} package roots, {len({n for kind, n in declarations})} distinct declared numbers, {len(conflicts)} same-namespace different-ModID collisions and {len(cross_kind)} cross-kind numeric overlaps. Known existing speed-prototype collisions are documented above; any new same-namespace conflict or foreign use of the Cheat Keybinds reserved block fails `--check`.', '',
    ]
    return '\r\n'.join(out)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true', help='Regenerate the maintained Markdown registry.')
    parser.add_argument('--check', action='store_true', help='Check registry freshness and ownership conflicts.')
    args = parser.parse_args()
    packages, declarations, references = scan()
    expected = render(packages, declarations, references)
    if args.write:
        TARGET.write_bytes(expected.encode('utf-8'))
    errors = []
    for (kind, n), records in declarations.items():
        owners = {x[0] for x in records}
        if len(owners) > 1 and not (kind == 'asset' and owners == KNOWN_ASSET_COLLISIONS.get(n)):
            errors.append(f'Unexpected {kind} ownership conflict {n}: {sorted(owners)}')
        if n in CHEAT_BLOCK and owners != {CHEAT}:
            errors.append(f'Foreign use of Cheat Keybinds block {n}: {sorted(owners)}')
    if args.check:
        if not TARGET.exists() or TARGET.read_bytes() != expected.encode('utf-8'):
            errors.append('Registry is stale; inspect changes and regenerate with --write.')
        if errors:
            raise SystemExit('\n'.join(errors))
    print(f'GUID inventory: {len(packages)} packages, {len(declarations)} asset/text allocations; known speed collisions documented; Cheat Keybinds block exclusive.')
    if errors:
        print('\n'.join(errors))
    elif args.check:
        print('PASS: register is current; no unexpected same-namespace ownership conflicts.')


if __name__ == '__main__':
    main()
