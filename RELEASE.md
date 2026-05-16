# Release Process

This document describes how to cut releases and deployment release candidates
for Tesserine repos. Stable cargo-workspace releases follow the convention
established by [ADR-0006](adr/0006-release-discipline.md). Deployment release
candidates follow [ADR-0010](adr/0010-deployment-release-candidates.md).
Release tag version strings follow [ADR-0012](adr/0012-ecosystem-release-version-grammar.md):
stable tags are `vMAJOR.MINOR.PATCH`, release-candidate tags are
`vMAJOR.MINOR.PATCH-rc.N`, numeric identifiers do not use leading zeroes, and
other SemVer prerelease forms are outside the Tesserine release surface.

The stable-release audience is an operator (human or agent) at a cargo-workspace
repo where [`cargo-release`](https://github.com/crate-ci/cargo-release) is
already installed and configured. Non-cargo repos in the ecosystem (commons,
base, groundwork) have different stable-release surfaces and remain out of
scope for ADR-0006; they are covered here only for deployment release-candidate
tags. Per-repo cargo-release adoption — installing the tool, authoring
`release.toml` — is one-time work tracked in each cargo-workspace repo's
adoption issue and is not covered here.

## Preconditions

Before invoking the release command, the following must hold:

- The working tree is clean and on the repo's integration branch (typically `main`).
- The branch is up to date with the remote: `git pull --ff-only`.
- `cargo-release` is installed and a `release.toml` exists at the workspace root.
- `CHANGELOG.md`'s `[Unreleased]` section reflects everything shipping in this release. Do not manually convert `[Unreleased]` to a versioned heading; `cargo-release` rolls it into `[X.Y.Z] — YYYY-MM-DD` as part of the release operation.
- The component version level is decided from this repo's own changes:
  `patch` for fixes, `minor` for additive changes, `major` for breaking
  changes, or `rc` for a deployment release candidate.

If any precondition fails, resolve the discrepancy before releasing. `--allow-dirty` is not part of the release path.

## The release

One command:

```
cargo release <level> --execute
```

Where `<level>` is `patch`, `minor`, or `major`. The command performs, in order, as a single indivisible step from the operator's perspective:

1. Bumps the workspace `Cargo.toml` version by the requested level.
2. Rolls `CHANGELOG.md`'s `[Unreleased]` heading into `[X.Y.Z] — YYYY-MM-DD`.
3. Commits the bump and CHANGELOG roll.
4. Creates an annotated tag `vX.Y.Z` pointing at the commit.
5. Pushes the commit and the tag to the remote.

The operator does not perform any of these steps independently. Splitting the operation reintroduces the gap this convention closes.

## Deployment release candidates

Deployment release candidates provide immutable refs for integration testing
before a stable release is cut. They use the ADR-0012 release-candidate tag
form `vX.Y.Z-rc.N`, where `X.Y.Z` is the next intended stable version and `N`
starts at `1`.

Cargo-workspace repos that have adopted ADR-0006 cut release candidates through
the same configured release tool:

```
cargo release --config release.toml --isolated rc --execute
```

The command bumps the workspace version to `X.Y.Z-rc.N`, commits the bump,
creates annotated tag `vX.Y.Z-rc.N`, and pushes the commit and tag. The same
workspace-version invariant applies: binaries built from the tag must
self-report the version named by the tag.

Non-cargo repos use annotated tags at clean, up-to-date commits:

```
git tag -a vX.Y.Z-rc.N -m "Release vX.Y.Z-rc.N"
git push origin vX.Y.Z-rc.N
```

A deployment ref must be an immutable tag or a full commit SHA. Branch names
such as `main` are not deployment refs, because container build caches key on
the ref argument value while branch tips move.

## Ecosystem release manifests

Stable ecosystem release identity is declared by a manifest in `commons`, as
defined by [ADR-0011](adr/0011-ecosystem-release-identity-and-ceremony.md) and
[ADR-0014](adr/0014-component-independent-versioning.md). The manifest format,
canonical location, and verifier command are documented in
[ECOSYSTEM-RELEASE.md](ECOSYSTEM-RELEASE.md).

The ecosystem manifest records the current lockstep set component tags and
commits. Those component tags follow each component's own SemVer and may differ
from the ecosystem version.

## Verification

After the push, on a fresh clone of the tag, build the workspace and check that every shipped binary — the `[[bin]]` targets declared across the workspace's member crates — self-reports the version the tag names:

```
checkdir=$(mktemp -d)
git clone --branch vX.Y.Z --depth 1 <repo-url> "$checkdir"
cd "$checkdir"
cargo build --release
for binary in <bin1> <bin2>; do
    ./target/release/"$binary" --version
done
cd -
rm -rf "$checkdir"
```

For each binary the workspace ships, the output must include `X.Y.Z`. If any binary reports otherwise, the workspace-version invariant has been violated and the release is invalid; see *Failure modes* below.

## Failure modes

**Dirty working tree.** `cargo-release` refuses to run. Resolve the dirty state — commit, stash, or discard — and retry. Do not pass `--allow-dirty`.

**Tag already exists upstream.** The release was attempted twice or the tag was created out of band. If the existing tag has no external consumers, delete it locally and remotely (`git tag -d vX.Y.Z && git push origin :refs/tags/vX.Y.Z`) and re-release. If the tag has external consumers, treat it as immutable: cut the next version instead. Public-tag rewriting is a larger problem with consequences beyond this document. For release candidates, the next version means the next RC number.

**Workspace-version invariant violated.** The binary at the tag self-reports the wrong version. Do not amend the tagged commit. Diagnose the source before remediating; the violation has two possible sources:

- **Cargo.toml source.** The workspace `Cargo.toml` at the tagged commit names the wrong version. Remediation: correct `Cargo.toml` and re-release.
- **Binary source.** The workspace `Cargo.toml` is correct, but a binary derives `--version` from something other than `CARGO_PKG_VERSION` (or an equivalent mechanism resolving to the workspace `Cargo.toml` version at build time). The workspace-source compliance property was unmet. Remediation: correct the binary's version derivation and re-release; re-releasing without this correction reproduces the symptom.

Both cases inherit the external-consumer constraint: if no external consumers exist, delete the tag (locally and remotely) before re-releasing; if external consumers exist, the invalid tag enters the public record and the remediation is to cut the next version, because public-tag rewriting is a larger problem with consequences beyond this document.

**`cargo release` aborts mid-operation.** A network failure between commit and push can leave the local repo bumped and tagged without the push having landed. Confirm the commit and tag are present locally and not yet upstream, then `git push --follow-tags` to complete the in-flight operation. If the remote already received the commit but not the tag, `git push origin vX.Y.Z` finishes the push. Do not re-run `cargo release`; this is not a new release, it is the same one finishing.

## Out of band

The following are not part of this document and are intentionally excluded:

- **GitHub release notes.** Whether and how to author a release on GitHub is a separate concern; the tag is the canonical release artifact, the GitHub release is presentation.
- **Registry publishing.** The release operation does not push to crates.io or any other registry. If the ecosystem decides to publish to a registry, that becomes a separate convention. The tag is the canonical release artifact.
- **Artifact signing.** Not currently practiced; if and when introduced, signing becomes its own convention.
- **CHANGELOG authoring** — what entries qualify, voice, granularity. This document covers only the operational roll of `[Unreleased]` into a versioned section at release time.
