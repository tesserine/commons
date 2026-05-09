# ADR-0012: Ecosystem Release Version Grammar

**Status:** Accepted
**Traces to:** Principle 7 (Verifiable Completion) - primary; Principle 1
(Sovereignty) - secondary

## Decision

Tesserine release tags use Semantic Versioning 2.0.0 as their version-string
grammar, with a leading `v` prefix at the Git tag boundary.

Stable release tags are exactly `vMAJOR.MINOR.PATCH`, where `MAJOR`, `MINOR`,
and `PATCH` are SemVer numeric identifiers: either `0` or a non-zero digit
followed by zero or more digits. Leading zeroes are invalid.

Release-candidate tags are exactly `vMAJOR.MINOR.PATCH-rc.N`, where `N` is a
positive integer without leading zeroes. Release-candidate sequencing starts at
`rc.1` per ADR-0010, and this grammar excludes `rc.0` directly.

Other SemVer prerelease forms, including `alpha`, `beta`, mixed identifiers,
and build metadata, are outside the Tesserine release surface unless a later
ADR explicitly admits them.

The canonical tag regex for stable and release-candidate tags is:

```text
^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-rc\.[1-9][0-9]*)?$
```

Version-of-record artifacts and CHANGELOG release headings use the same
version grammar without the leading `v` prefix.

## Context

ADR-0006 established release discipline for cargo-workspace repos. ADR-0010
established deployment release candidates. ADR-0011 established ecosystem
release identity. Together they made `vX.Y.Z` and `vX.Y.Z-rc.N` operationally
central, but none of them named the exact numeric grammar those placeholders
stand for.

During release-ceremony implementation in `tesserine/base`, review surfaced
that per-repo verifier regexes using `[0-9]+` accepted non-SemVer forms such as
`v01.2.3` and `v1.2.3-rc.01`. The review premise was correct even though the
ecosystem had not yet codified it: Tesserine release versions are SemVer
versions, not arbitrary dot-separated numeric strings.

Leaving this implicit forces every repo's release checker to rediscover the
same grammar and creates drift between release documentation, CI tag filters,
metadata checks, and tag-time verification.

## Consequences

**Single grammar authority.** Per-repo release verifiers cite this ADR for
release tag grammar rather than redefining "numeric" release strings locally.
Repo-specific tooling may embed the regex, but the accepted language comes
from this ADR.

**Stable and RC numeric discipline.** Stable numeric identifiers may be `0`;
release-candidate sequence numbers start at `1`. Both reject leading zeroes, so
a verifier that rejects leading zeroes in stable tags also rejects them in
release-candidate tags and version-of-record artifacts.

**Surface restriction propagation.** Any release-surface value that must match
a release tag also uses this grammar. CHANGELOG release headings, workspace
versions, methodology manifest versions, deployment manifest versions, and
similar version-of-record fields accept `MAJOR.MINOR.PATCH` or
`MAJOR.MINOR.PATCH-rc.N`, and reject forms the tag grammar rejects.

**Literal identity comparison remains required.** Grammar validation does not
replace exact identity checks. Once a tag is parsed, the canonical version is
the tag minus the leading `v`, character-for-character. Verifiers compare that
value literally against version-of-record artifacts.

**Workflow filters do not define grammar.** GitHub Actions tag filters may use
broader glob patterns such as `v*` when the workflow performs an explicit early
release-check validation step. Runtime validation against this ADR is the
grammar authority; workflow glob syntax is only a trigger mechanism.

**Narrow prerelease surface.** ADR-0010 admits release candidates as the only
documented prerelease channel. This ADR makes that narrow surface precise:
`-rc.N` is accepted only when `N` is `1` or greater; other SemVer prerelease
forms remain invalid until an ADR adds an actual ecosystem need for them.

**What this means for the builder agent.** When implementing or reviewing
release tooling, reject regexes that accept leading-zero numeric identifiers or
`rc.0`. Do not introduce local "looks numeric" definitions for release
versions. Cite this ADR in `RELEASING.md`, release-check comments, and work-unit
acceptance criteria when tag grammar matters.
