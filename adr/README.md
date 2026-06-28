# ADR Register

Architectural decision records for the Tesserine ecosystem. This register
is the index; each ADR file is authoritative for its own content. Repos
implementing a decision link to the ADR — they do not restate it.

Six principle-shaped ADRs (0001–0004, 0007, 0013) are superseded: their
content ascended to the canonical principles corpus at
[`pentaxis93/principles`](https://github.com/pentaxis93/principles), and the
files here are pointer documents naming each principle's canonical home.
ADR-0018 is superseded by inheritance: its policy is homed in the pentaxis93
base layer at [`pentaxis93/commons`](https://github.com/pentaxis93/commons)
(ADR-0001), which this ecosystem inherits, and the file here points to that
base. Twelve genuine ecosystem decisions remain active.

Repo-local ADRs (e.g. `groundwork/docs/architecture/decisions/`) cover
repo-local scope and are not registered here.

| # | Title | Status | Traces to | Lineage | Purpose |
| --- | --- | --- | --- | --- | --- |
| [0001](0001-sovereignty.md) | Sovereignty | Superseded | — | ascended → [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md) | Pointer to canonical principle |
| [0002](0002-everything-earns-its-place.md) | Everything Earns Its Place | Superseded | — | ascended → [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md) + [Parsimony](https://github.com/pentaxis93/principles/blob/main/principles/parsimony.md) | Pointer to canonical principles |
| [0003](0003-unconditional-responsibility.md) | Unconditional Responsibility | Superseded | — | ascended → [Obligation to Dissent](https://github.com/pentaxis93/principles/blob/main/principles/obligation-to-dissent.md) | Pointer to canonical principle |
| [0004](0004-compound-improvement.md) | Compound Improvement | Superseded | — | ascended → [Recursive Improvement](https://github.com/pentaxis93/principles/blob/main/principles/recursive-improvement.md) | Pointer to canonical principle |
| [0005](0005-system-conventions.md) | System Conventions for Cross-Component Artifacts | Accepted | Sovereignty (primary), Grounding | — | commons is spec authority for cross-component artifact types; canonical = prose + versioned schema pair; methodologies vendor with provenance |
| [0006](0006-release-discipline.md) | Release Discipline for Cargo-Workspace Repos | Accepted | Sovereignty (primary), Verifiable Completion | tag grammar defined by 0012 | `cargo-release` as the single atomic release operation; workspace-version invariant |
| [0007](0007-day-one-stance.md) | Day-One Stance | Superseded | — | ascended → [Evolvability](https://github.com/pentaxis93/principles/blob/main/principles/evolvability.md) + [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md) + [Transmission](https://github.com/pentaxis93/principles/blob/main/principles/transmission.md) | Pointer to canonical principles |
| [0008](0008-clean-session-ownership.md) | Component Orthogonality in Session Composition | Accepted | Sovereignty (primary) | — | agentd composes the session runtime; runa executes the methodology; neither absorbs the other's responsibilities |
| [0009](0009-operator-metrics-convention.md) | Operator Metrics Convention | Accepted | Grounding (primary), Verifiable Completion | — | Shared convention for Prometheus-compatible runtime metrics |
| [0010](0010-deployment-release-candidates.md) | Deployment Release Candidates | Accepted | Grounding (primary), Verifiable Completion | — | Deployment testing uses immutable RC tags, never moving branches |
| [0011](0011-ecosystem-release-identity-and-ceremony.md) | Ecosystem Release Identity and Ceremony | Accepted | Verifiable Completion (primary), Sovereignty, Grounding | uniform-version rule superseded by 0014 | Ecosystem release declared by a JSON manifest committed to commons; ceremony and verification obligations |
| [0012](0012-ecosystem-release-version-grammar.md) | Ecosystem Release Version Grammar | Accepted | Verifiable Completion (primary), Sovereignty | constrains 0006/0011 tags | SemVer 2.0.0 tag grammar: `vX.Y.Z`, `vX.Y.Z-rc.N`, no leading zeroes |
| [0013](0013-procedure-substrate-discipline.md) | Procedure Substrate Discipline | Superseded | — | ascended → [Source Repair](https://github.com/pentaxis93/principles/blob/main/principles/source-repair.md) | Pointer to canonical principle |
| [0014](0014-component-independent-versioning.md) | Component-Independent SemVer and Curatorial Ecosystem Release Versioning | Accepted | Sovereignty (primary), Verifiable Completion, Grounding | partially supersedes 0011 | Components version independently; the ecosystem version is curated, not aggregated |
| [0015](0015-mode-is-a-property-of-the-session.md) | Mode Is a Property of the Session | Accepted | Sovereignty (formerly ADR-0001), Design Principle 21 | — | Autonomous and interactive execution are modes of one session, not variant session types |
| [0016](0016-connector-layer-architecture-and-forge-capability.md) | Connector-Layer Architecture and Forge Capability | Accepted | Sovereignty (primary), Grounding | — | Methodologies bind to provider-agnostic capabilities; connectors implement provider-specific MCP tool-sets behind opaque handles |
| [0017](0017-forge-work-unit-identity-model.md) | Forge Work-Unit Identity Model | Accepted | Grounding (primary), Single Home, Sovereignty | refines 0016 | A forge work-unit identity is complete and scoped; connectors validate scope before any effect; a provider is a projection of the model, not its source |
| [0018](0018-repository-merge-and-history-policy.md) | Repository Merge and History Policy | Superseded | — | inherited → [pentaxis93/commons ADR-0001](https://github.com/pentaxis93/commons/blob/main/adr/0001-repository-merge-and-history-policy.md) | Pointer to the inheriting base ADR |
| [0019](0019-capability-specific-integration-verification.md) | Capability-Specific Integration Verification | Accepted | Verifiable Completion (primary), Sequence, Honest Signal | extends 0011/0014 | Minor and major ecosystem releases exercise the new or changed operator-facing capability before stable publication; patch releases retain the fixture-only gate |

## Conventions

- Numbering is sequential and never reused.
- Status values: `Accepted`, `Superseded`. Partial supersession is stated
  on the Status line of the affected ADR (see 0011).
- New ADRs add a row here in the same change ([SOURCE-OF-TRUTH.md](../SOURCE-OF-TRUTH.md)
  change policy).

Verification: the table has one row per `adr/*.md` decision file —
`ls adr/*.md | grep -v README | wc -l` equals the row count (19).
