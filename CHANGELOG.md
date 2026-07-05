# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Retained forge-capability v1 reached `1.2.0` (additive minor per ADR-0005):
  the ticket snapshot gains an optional ordered `comments` log — the body is
  the work-unit's spec, the log its running record — with entry shape `body`
  (required) plus `author`/`created_at` when the provider supplies them,
  inherited by `create-ticket`'s output and preserved under
  `schemas/forge-capability/v1/` for existing v1 consumers.
- `FORGE-CAPABILITY.md`, `schemas/forge-capability/v1/forge-capability.schema.json`,
  and ADR-0016 establish the connector-layer architecture and the first
  capability contract: provider-agnostic forge operations, connector-owned
  provider coordinates and identities, opaque `{ id, display }` handles, and
  runa tool-set union composition rules.
- `SOURCE-OF-TRUTH.md` — canonical ownership map naming, for every
  ecosystem-level concept, the one repository and document that owns it,
  the repos that link to it, the map-not-mirror rule, the vendoring
  provenance rule, and the release convention-vs-tooling split.
- `adr/README.md` — ADR register indexing all sixteen ADRs with status,
  principle traces, supersession lineage, and one-line purpose.
- `schemas/README.md` — schema index with versioning rule, vendoring
  rule, and groundwork's `x-tesserine-canonical` provenance block as the
  worked vendoring example.
- `concepts/README.md` — concepts index making the exploratory,
  non-committed status of `concepts/_drafts/cognitive-state-machine.md`
  explicit and README-visible (tracking: commons#16).
- ADR-0019 and the release-process documentation gate for capability-specific
  integration verification on minor and major ecosystem releases.

### Changed

- Forge-capability canonical advanced to `2.0.0` under
  `schemas/forge-capability/v2/`: `read-ticket`/`create-ticket` and
  `ticket-snapshot` are replaced by `read-work-unit`/`create-work-unit` and
  `work-unit-snapshot`; v1 remains frozen under `schemas/forge-capability/v1/`;
  provider nouns such as GitHub issue and SourceHut ticket are documented as
  connector-internal projections rather than capability operation names.
- Intent artifact canonical updated to `2.0.0` at
  `schemas/intent/v2/intent.schema.json`: `description` becomes
  `statement`, typed `references` are removed, optional opaque `target` is
  added, and `INTENT.md` now points conformance guidance at the v2 schema
  while retaining v1 schema and prose authority for existing consumers.
- `PRINCIPLES.md` and `DESIGN-PRINCIPLES.md` reduced to redirect tombstones:
  the restated principle and design-principle text — a second home of content
  already ascended in full to the canonical corpus
  ([`pentaxis93/principles`](https://github.com/pentaxis93/principles)) — is
  removed, leaving a status pointer to the corpus and its per-item coverage
  map. The files remain so existing links resolve; they now hold no principle
  content of their own ([Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md)).
  This makes the `SOURCE-OF-TRUTH.md` "redirect pointers" description accurate.
- README `## Foundation` now points at
  [`pentaxis93/commons`'s `ONTOLOGY.md`](https://github.com/pentaxis93/commons/blob/main/ONTOLOGY.md)
  as the authoritative cross-stratum ontology of the shared-knowledge body,
  framing the Tesserine overlay as that ontology's authority-axis instance.
- README hero rewritten: commons positioned as the ecosystem's enforced
  constitution, leading with the mechanically-checked contracts and the
  source-of-truth map; principles correctly attributed to their canonical
  home.
- `scripts/release-check` ADR integrity check now exempts the
  `adr/README.md` register index from the ADR filename/numbering rules
  (with a test-harness case); `RELEASING.md`'s release-identity surface
  names the exemption.
- `README.md` contents now document `scripts/` — the verifiers, release
  tooling, test harnesses, and their Python requirements.
- `EXIT-CODES.md` gains a Downstream Conformance section: the vendored-table
  + parity-test + back-reference pattern (per ADR-0005), runa and agentd as
  worked examples, and the change procedure for the application-defined
  table.
- `RELEASE.md` opens with a document map fixing the non-overlapping scopes
  of the three release documents (`RELEASE.md` convention, `RELEASING.md`
  commons runbook, `ECOSYSTEM-RELEASE.md` ecosystem ceremony) and pointing
  at the per-repo tooling-ownership statement in base.
- `SOURCE-OF-TRUTH.md` release-tooling entries corrected to the verified
  ownership model: release scripts are per-repo-owned implementations of
  the commons convention (commons#21), not vendored copies of a base
  upstream. `scripts/release-check` carries a matching provenance header.
- `README.md` ecosystem roster now lists all eight repositories with
  their classification (release components, out-of-band methodology,
  integration fixture, retired) and defers the release-set definition to
  `ECOSYSTEM-RELEASE.md`, reconciling the roster across README,
  ecosystem-release docs, and published manifests.
- `ECOSYSTEM-RELEASE.md` now requires a capability-specific integration
  exercise before stable publication for minor and major ecosystem releases,
  while retaining the canonical fixture gate as the complete patch-release
  integration gate.

### Fixed

- Recorded `releases/ecosystem/v0.2.0.json` as a historical manifest in
  `ECOSYSTEM-RELEASE.md`: its `ops v0.1.0` reference pins the pre-rewrite
  commit that shipped, orphaned when tesserine/ops#73 re-rooted the tag, and
  is superseded by the first `schema_version: 2` ecosystem release. Verifying
  it against live tags fails by design; the manifest records what shipped.

- `scripts/verify-release-adoption.sh` now seeds release-cut adoption checks
  with a controlled changelog fixture, so the Release Metadata workflow stays
  green on release commits while still turning red on genuine `release-cut`
  defects.

- Superseded six principle-shaped ADRs (0001–0004, 0007, 0013): replaced
  each with a pointer document to the canonical principles corpus at
  `pentaxis93/principles`, where each principle has been ascended to its
  universal level. ADR-0001 → Sovereignty; ADR-0002 → Grounding +
  Parsimony; ADR-0003 → Obligation to Dissent; ADR-0004 → Recursive
  Improvement; ADR-0007 → Evolvability (primary), Grounding, Transmission;
  ADR-0013 → Source Repair. Ten genuine decisions (0005–0006, 0008–0012,
  0014–0016) remain active in `adr/`.
- Added forward-pointer banners to `PRINCIPLES.md` and
  `DESIGN-PRINCIPLES.md` directing readers to `pentaxis93/principles` as
  the canonical home. Both files are retained for link stability.
- Updated `README.md` contents section to distinguish the historical
  principle docs (now canonical at `pentaxis93/principles`) from the
  retained genuine decisions.
- Updated internal ADR references in ADR-0008, ADR-0015, and
  `ECOSYSTEM-RELEASE.md` to point to the canonical principle documents
  rather than the now-superseded ADR files.
- Evolved the ecosystem release manifest schema to `schema_version: 2` for the
  current host-agnostic five-component release set while keeping already
  published `schema_version: 1` manifests valid.
- Removed the ecosystem verifier's host-deployment manifest read path; release
  verification now checks manifest identity, component tags and commits,
  release workflows, and cross-component source coherence without consulting
  any operator host artifacts.
- `SOURCE-OF-TRUTH.md` repository roster and the `README.md` ecosystem list
  now include `agent-protocols` (draft standard for the protocol document
  form; not in the release set), per the map's change policy.

## [0.3.0-rc.1] — 2026-06-08

### Added

- Added ADR-0015 and Design Principle 21, promoting "mode is a property of the
  session, not the operation" as the source invariant for dual-mode session
  contracts, with conformance authority, request-seed intent authority, and
  interactive mode as the methodology development harness.
- Added "Self-describing interfaces" section to `DESIGN-PRINCIPLES.md`
  (principles #17–20), capturing engineering judgment for interfaces that
  expose their own schema, derive documentation from contract, share
  uniform patterns across surfaces, and support verify-before-act. Lands
  as engineering judgment; surface-level operationalizing ADRs will follow
  once individual surfaces commit to schema exposure in implementation.

## [0.2.0] — 2026-05-17

### Added

- Added ADR-0014 Component-Independent SemVer and Curatorial Ecosystem Release
  Versioning, replacing uniform component tags with component-independent
  SemVer and curatorial ecosystem versioning.
- Added ecosystem release manifest schema and cross-repo verifier substrate for
  Phase 3 release coordination, including fixture coverage and operator docs.
- Added ecosystem integration verification procedure docs for the RC-to-stable
  release gate, including operator-host convergence, the canonical fixture,
  pass criteria, and ADR-0013 substrate-gap handling.
- Added ADR-0013 Procedure Substrate Discipline, codifying how agents handle
  documentation gaps encountered while executing procedure substrate.
- Added commons release ceremony tooling: release metadata checks, release-cut
  helper, GitHub release workflows, schema meta-schema validation, and
  commons-specific release operator documentation.
- Added ADR-0012 Ecosystem Release Version Grammar, codifying SemVer 2.0.0 as
  the release tag grammar for stable `vMAJOR.MINOR.PATCH` tags and
  `vMAJOR.MINOR.PATCH-rc.N` release-candidate tags across the ecosystem.
- Added ADR-0011 Ecosystem Release Identity and Ceremony, defining
  `commons` release manifests as the canonical multi-repo release identity,
  lockstep-set membership across release-boundary repos, deployment-manifest
  alignment with published manifests, non-cargo version-of-record surfaces,
  and recovery rules for invalid published ecosystem releases.
- Added ADR-0010 Deployment Release Candidates and expanded `RELEASE.md` with
  the `vX.Y.Z-rc.N` convention for immutable deployment refs across cargo and
  non-cargo ecosystem repos.
- Added ADR-0009 Operator Metrics Convention, establishing separate
  loopback-default operator listeners, network placement as the metrics access
  boundary, Prometheus text exposition, ecosystem metric naming, and bounded
  label cardinality policy.
- Added ADR-0007 Day-One Stance, formalizing the default orientation
  toward foundational movability: artifacts are scaffolding for what
  comes next, proxies serve the foundation rather than replacing it,
  reversible decisions move at high velocity, and declarations of
  maturity are resisted.
- Added ADR-0008 Component Orthogonality in Session Composition,
  establishing clean boundaries for agentd-managed sessions: agentd
  composes the container runtime, runa owns `.runa/` content via
  `runa init`, and the agent declaration expresses operator intent
  declaratively. The `runa run --agent-command` override carries
  agentd's chosen command into runa without shell-script slots in
  declarative config.
- Added ADR-0006 Release Discipline and `RELEASE.md`, establishing
  `cargo-release` as the canonical release tool for Tesserine
  cargo-workspace repos and codifying the workspace-version
  invariant — the code at the tag self-reports the version the tag
  names. commons owns the convention; per-repo adoption (agentd,
  runa) is tracked separately.

### Changed

- Reconciled ADR-0011, ecosystem release docs, and manifest verification with
  component-independent tags under one curatorial ecosystem version.
- Tightened ecosystem manifest verification so release workflow evidence is
  scoped to the named tag, and deployment/base cross-repo checks compare
  repository identity as well as refs.
- Changed `commons` ecosystem manifest verification to compare local manifest
  content with the manifest published at the `commons` tag, removing the
  checkout-dependent home-commit override from the default identity check.
- Tightened ecosystem manifest verification to reject files whose basename
  does not match the manifest version's canonical `vX.Y.Z.json` name before
  fetching published release content.

### Fixed

- Restored annotated tag refs in the release workflow before validating tag
  identity, preserving trust checks after `actions/checkout`.

## [0.1.1] — 2026-04-21

### Added

- Added `EXIT-CODES.md`, defining the shared session-outcome exit code
  convention for runners and callers, including survey findings, reserved
  POSIX ranges, caller/runner guidance, and forward-compatibility rules.
- Added `REQUEST.md` and `schemas/request/v1/request.schema.json` as the
  canonical request artifact spec (version `1.0.0`). REQUEST.md is the
  prose authority; the versioned JSON Schema is the machine-checkable
  realization.
- Added ADR-0005, formalizing commons as the spec authority for
  system-level cross-component artifact types: canonicalization criteria,
  the prose-plus-versioned-schema canonical form, semver rules across
  directory and full-version levels, immutable-reference requirements for
  conformance, methodology vendoring with provenance, and the runtime
  boundary (methodologies serve runtime; commons serves authoring).

### Changed

- Renamed repo identity from "governance" to "commons" in README. Updated
  all ecosystem repo links from pentaxis93 to tesserine org. Added base repo
  to the ecosystem listing.

## [0.1.0] — 2026-04-10

First release. Commons defines the shared principles and architectural
decisions that govern all Tesserine ecosystem components.

### Principles

- Seven bedrock principles organized as a topology: sovereignty, sequence,
  grounding, obligation to dissent, recursive improvement, transmission,
  verifiable completion.
- Sixteen engineering design principles governing how code decisions are made
  across the ecosystem: elimination over accommodation, fix at the source,
  honest naming, correctness over optimization, architecture as communication,
  review discipline, and others.

### Architectural decision records

- ADR-0001: Sovereignty — operator owns WHAT, runtime owns HOW.
- ADR-0002: Everything earns its place — no artifact or abstraction persists
  without demonstrated need.
- ADR-0003: Unconditional responsibility — every component owns its failure
  modes without blaming callers.
- ADR-0004: Compound improvement — every operation refines both the object
  and the process.
