# ADR-0011: Ecosystem Release Identity and Ceremony

**Status:** Accepted
**Traces to:** Principle 7 (Verifiable Completion) - primary; Principle 1
(Sovereignty) - secondary; Principle 3 (Grounding) - secondary

## Decision

ADR-0006 remains the per-repo cargo-workspace release discipline: it governs
`cargo-release`, the workspace-version invariant, and cargo tag remediation.
ADR-0010 remains the deployment release-candidate and image-label discipline:
it governs immutable RC refs and container source-ref reporting. This ADR adds
the ecosystem layer those ADRs intentionally leave open: Tesserine release
identity across multiple repositories, non-cargo version-of-record surfaces,
and the moment at which a multi-repo release becomes public fact.

A Tesserine ecosystem release is declared by a machine-readable release
manifest committed to `tesserine/commons`. The manifest is the canonical
artifact that states:

```text
Tesserine vX.Y.Z =
  commons@vX.Y.Z at the manifest-containing commit
  plus {agentd, base, runa, groundwork, ops}@vX.Y.Z at declared commits
```

The lockstep repositories use the same tag string as the ecosystem release
version. Publication of the verified manifest is the atomic ecosystem release
boundary. An ecosystem release is not complete until every referenced tag
exists, every non-`commons` tag points at the manifest-declared commit, the
`commons` tag points at the commit containing the manifest, and every
referenced repository passes its own release check at that tag.

## Context

Tesserine ships as an ecosystem, not as a single repository. The v0.1.2
release train includes `agentd`, `base`, `runa`, `groundwork`, `commons`, and
`ops`. The deployment manifest at `ops/deployments/babbie.toml` currently
declares the operative deployment composition for babbie, but that host-level
desired state is not the same thing as public ecosystem release identity. A
future operator needs one artifact that answers which repository revisions
compose "Tesserine vX.Y.Z" without reverse-engineering it from a deployment
host, release notes, or individual tags.

ADR-0006 was written after the v0.1.1 incident in which cargo-workspace tags
pointed at commits whose binaries still self-reported the previous version.
It deliberately scoped itself to cargo-workspace repos and explicitly deferred
non-cargo repos. ADR-0010 later added immutable deployment release candidates
and image-label identity, but it does not define the multi-repo stable release
boundary. This ADR answers those deferrals.

Three alternatives were considered for ecosystem identity. A primary repo
could carry the ecosystem tag plus an inline manifest in tag metadata, but tag
metadata is a poor review surface and hides release composition from normal
file-based tooling. Each repo could mutually verify the others without a
single canonical artifact, but that only proves consistency at a moment in
time; it does not leave a source of truth for readers. A release manifest in
`ops` would be close to deployment mechanics, but `ops` manifests are
host-specific desired state. `commons` is already the ecosystem convention
authority, so the release identity artifact belongs there.

## Consequences

**Canonical ecosystem manifest.** `commons` owns the release manifest because
ecosystem release identity is a convention-level artifact. Phase 3 defines the
exact manifest path, schema, and verification command, but not the authority:
the canonical manifest is committed in `commons`. The manifest records each
non-`commons` lockstep repository, tag, and commit. For `commons`, the manifest
records the repository and tag; the commit is the manifest's containing commit.
A release without a published manifest is a set of component tags, not a
Tesserine ecosystem release.

**Uniform lockstep versions.** The lockstep set for v0.1.2 is `agentd`,
`base`, `runa`, `groundwork`, `commons`, and `ops`. An ecosystem release
`vX.Y.Z` references tag `vX.Y.Z` in every lockstep repo. Per-repo versions may
exist outside the lockstep set, but a repository inside the set does not
advance under an independent version number for an ecosystem release. Future
repositories join lockstep when a Tesserine release cannot truthfully be
declared, deployed, or verified without pinning that repository's revision.
Runtime dependency alone is too broad; deployment-manifest inclusion alone is
too narrow.

**Manifest publication is the atomic boundary.** Git cannot tag six
repositories atomically. The ecosystem analogue of ADR-0006's atomic operation
is the verified publication of a complete, self-consistent release manifest.
The manifest must be valid at the moment it is committed: it cannot depend on a
post-commit amendment, and it cannot embed a future hash of its own contents.
Before manifest publication, an invalid component tag is corrected under the
owning repo's release discipline: cargo repos inherit ADR-0006, and RC or
image-bearing deployment surfaces inherit ADR-0010. After manifest
publication, the ecosystem release identity is immutable.

**Home-repository identity is implicit.** The `commons` manifest lives inside a
checkout of `commons`, so the home repository's commit is already identified by
the commit that contains the manifest. Recording that same commit inside the
manifest would be redundant and impossible, because the commit hash depends on
the manifest contents. This asymmetry is part of the identity model: external
lockstep repositories need explicit commit fields, while the home repository's
commit is derived from location.

**Invalid published releases move forward.** If a published stable ecosystem
manifest is later found invalid, the correction is the next patch release on
the same stable line. For example, an invalid `v0.1.2` is corrected by cutting
and publishing `v0.1.3`. The same stable version is not amended, re-tagged, or
republished with altered contents. For release candidates, the correction is
the next `rc.N` tag. Public release history records the bad release and its
successor rather than pretending the bad release never existed.

**All-or-nothing verification.** If the ecosystem manifest references a tag
that is missing, if a non-`commons` tag points at a commit other than the one
declared in the manifest, if the `commons` tag points at a commit other than
the manifest-containing commit, or if any referenced repo fails its
release-check, the ecosystem release fails as a whole. There is no partially
published ecosystem release, no partial rollback, and no deployment from a
failed manifest. The failure output must identify the repository, tag, and
check that failed so the owning repo can remediate at its boundary.

**Deployment manifests consume release identity.** An `ops/deployments/<host>.toml`
that represents a release deployment must match the corresponding subset of
one published ecosystem manifest. It may omit lockstep repos that are not
deployed onto that host, such as `commons` or `ops` itself, and it may include
host-local fields such as paths and image names. It must not mix component
refs from multiple ecosystem releases. A deployment manifest may still use
non-release refs allowed by ADR-0010 for integration or local testing, but
that state is not a release deployment until it matches a published ecosystem
manifest subset.

**Every release surface has a version of record.** ADR-0006's
workspace-version invariant generalizes to all release surfaces: at tag time,
there is a canonical source-controlled value whose identity matches the tag or
declared component ref. Cargo workspaces use the workspace `Cargo.toml` version
and binary `--version` reporting under ADR-0006. Container images use OCI and
`org.tesserine.*` source-ref labels under ADR-0010. Non-cargo repos name their
own version-of-record artifact and verify it in their release check. A docs or
schema release surface is legitimate: its version of record may be a changelog
release heading, schema metadata, a manifest version field, or another
source-controlled release metadata field, so long as the repo's release check
can mechanically compare it to the tag.

**Current non-cargo surfaces.** `groundwork`'s methodology version of record
is a top-level `version = "X.Y.Z"` field in `manifest.toml`. `ops` records
deployed component identity through deployment manifest `ref` fields; the
ecosystem release version itself lives in the `commons` release manifest.
`base` reports image identity through the labels already required by ADR-0010.
`commons` currently has no `Cargo.toml`, so its release check verifies its
docs, schemas, changelog, and release-manifest identity rather than cargo
metadata; for the release manifest itself, the commit under verification is the
manifest-containing commit. If `commons` later gains a cargo workspace, that
surface also falls under ADR-0006.

**Phase boundary.** This ADR defines the release identity rules. Phase 2
adopts per-repo release ceremony tooling that verifies each repository's
version-of-record surface. Phase 3 defines the concrete manifest schema,
canonical path in `commons`, and cross-repo verifier. That schema inherits this
ADR's home-repository rule: explicit commit identity is required for
non-`commons` entries and derived from the containing commit for `commons`.
Phase 4 uses those pieces to publish the first ceremony-blessed release.

**What this means for the builder agent.** When asked to cut or verify a
Tesserine ecosystem release, do not infer release identity from deployment
state, GitHub releases, or a set of convenient tags. Find the `commons`
release manifest and verify it against its containing commit. Do not hand-tag
around ADR-0006 or ADR-0010. Do not treat a failed cross-repo verification as
partial success. Do not deploy a release by mixing component refs from multiple
ecosystem manifests.

**What this does not mean.** This ADR does not define the manifest file format,
the verifier implementation, registry publishing, signing, or release-note
authoring policy. It also does not require every ecosystem-adjacent repository
to join lockstep. Lockstep is earned by release-boundary participation: if a
repo is needed to truthfully declare, deploy, or verify a Tesserine release, it
belongs; otherwise it can release independently.
