# ADR-0010: Deployment Release Candidates

**Status:** Accepted
**Traces to:** Principle 3 (Grounding) - primary; Principle 7 (Verifiable Completion) - secondary

## Decision

Tesserine deployment testing uses immutable release-candidate tags instead of
mutable branch refs. Release candidates are tagged as `vX.Y.Z-rc.N`, where
`X.Y.Z` is the next intended stable version and `N` starts at `1`. The tag
string follows the release-candidate grammar defined by
[ADR-0012](0012-ecosystem-release-version-grammar.md).

Cargo-workspace repos with ADR-0006 release adoption create release candidates
through their configured `cargo-release` path. Non-cargo repos create annotated
tags at clean, up-to-date commits. Deployment image builds must pin component
refs to a tag or full commit SHA, not to `main` or another mutable branch.

## Context

The May 5, 2026 Phase E integration session exposed a deployment cache trap:
`RUNA_REF=main` stayed constant while the remote `main` branch moved, so
Podman's cached clone layer could reuse an old runtime even after a rebuild.
The same session also showed that deployed versions need to be visible at the
image metadata layer instead of discovered by entering a container and running
`--version`.

Stable releases remain the public version boundary, but integration testing
needs earlier immutable refs. Release candidates provide that boundary without
rewriting the stable release process.

## Consequences

**Immutable deployment refs.** Deployment builds use tags or full SHAs. Branch
names are not deployment refs because their names remain stable while their
contents move.

**RC naming.** The first deployment candidate for the next stable release is
`vX.Y.Z-rc.1`; later candidates increment the final number. A bad or superseded
candidate is not rewritten after publication. Cut the next RC instead. Numeric
identifiers do not use leading zeroes under ADR-0012.

**Cargo workspace invariant.** For cargo-workspace repos, a release-candidate
tag carries the same source-version requirement as a stable release: the
workspace version at the tagged commit matches the tag, and shipped binaries
self-report that version.

**Non-cargo annotated tags.** Repos without a cargo workspace, such as base,
groundwork, and commons, use annotated release-candidate tags at reviewed
commits. Their version identity is the tag itself plus any component refs
exposed through image or package metadata.

**Image metadata completes the loop.** Container images built from RC refs
expose the material source refs as labels, using OCI labels where applicable
and `org.tesserine.*` labels for Tesserine-specific component refs.

**What this means for the builder agent.** When preparing a deployment or
integration retest, do not use `main` as a component ref. If an immutable ref
does not exist yet, cut a release candidate or use a full commit SHA and make
the chosen ref inspectable in the built artifact.
