# Releasing commons

Audience: the release operator cutting a commons repository release or release
candidate. This document assumes access to the repository, GitHub, Python, and
the dependencies in `requirements.txt`.

## Release Identity

commons is a documentation and schema authority. Its release identity is the
repository tag plus the source-controlled release surface at that commit:

- `CHANGELOG.md` contains a release heading `## [X.Y.Z] — YYYY-MM-DD` or
  `## [X.Y.Z-rc.N] — YYYY-MM-DD`.
- `adr/` contains sequential, uniquely numbered ADR files whose titles match
  their filename numbers.
- `schemas/` contains JSON Schema documents that parse as JSON and validate
  against their declared JSON Schema draft meta-schema.

Release tag grammar follows ADR-0012 exactly: stable tags are
`vMAJOR.MINOR.PATCH`, release-candidate tags are `vMAJOR.MINOR.PATCH-rc.N`,
numeric identifiers have no leading zeroes, and `rc.0` is not a release
candidate.

## Pre-Release Gate

A releasable commit is on `main`, up to date with `origin/main`, and has a clean
working tree. Before tagging:

```sh
git checkout main
git pull --ff-only
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install -r requirements.txt
./scripts/release-check metadata
```

For a final tag-time check against a version already rolled into the changelog:

```sh
./scripts/release-check release "vX.Y.Z"
```

## Atomic Release Operation

Cut stable releases and release candidates through the repo-owned helper:

```sh
./scripts/release-cut vX.Y.Z
```

or:

```sh
./scripts/release-cut vX.Y.Z-rc.N
```

The helper rolls `CHANGELOG.md`'s `[Unreleased]` section into the requested
release heading, commits that roll, creates an annotated tag, verifies the
release surface, and publishes the branch plus tag with one atomic Git push.

## Post-Release Gate

The tag push runs `.github/workflows/release.yml`. That workflow requires an
annotated tag whose target is on `main`, installs the pinned Python
dependencies, verifies the release surface, extracts notes from `CHANGELOG.md`,
and publishes the GitHub Release. Only ADR-0012 `vX.Y.Z-rc.N` tags are marked
as GitHub prereleases.

Manual GitHub Release recovery uses the same notes source:

```sh
./scripts/release-check notes "vX.Y.Z" > /tmp/commons-release-notes.md
gh release create "vX.Y.Z" \
  --title "commons vX.Y.Z" \
  --notes-file /tmp/commons-release-notes.md \
  --verify-tag
```

For release candidates, add `--prerelease` to the manual `gh release create`
command.

## Failure Modes

If `scripts/release-cut` fails before the atomic push, no remote release has
been published. Resolve the reported local problem and retry from a clean main
branch.

If the atomic push fails, remote refs were not partially published. The local
release commit and annotated tag may exist; inspect them, remove them locally if
they should not be reused, and retry only after the remote conflict is
understood.

If a published tag points at source that fails `scripts/release-check release`,
the tag is invalid. If it has no external consumers, delete it locally and
remotely and cut the release again. If it has external consumers, leave the bad
tag in the public record and cut the next patch version or next RC number.

If the GitHub Release workflow fails after a valid tag is published, repair the
workflow or environment and create the GitHub Release from
`scripts/release-check notes`. Do not hand-edit release notes unless the
changelog section is corrected in source.
