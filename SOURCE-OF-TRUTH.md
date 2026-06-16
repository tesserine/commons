# Source of Truth

Canonical ownership map for the Tesserine ecosystem.

This document is canonical for exactly one thing: **which repository and
document owns each ecosystem-level concept.** For every concept below, the
named canonical document is authoritative. Every other repository links,
summarizes, or vendors-with-provenance — it does not restate. When a
document elsewhere disagrees with the canonical named here, the canonical
wins and the other document is a defect.

Audience: maintainers and agents deciding where to read, where to write,
and where a change must land.

## Ecosystem topology

Tesserine is an ecosystem for running autonomous AI coding agents under an
explicit, contract-enforced methodology. The authority stack, from doctrine
down to runtime:

| Tier | Repos | Role |
| --- | --- | --- |
| Doctrine | [`commons`](https://github.com/tesserine/commons), external [`pentaxis93/principles`](https://github.com/pentaxis93/principles) | Principles, ADRs, cross-component contracts, release convention |
| Methodology | [`groundwork`](https://github.com/tesserine/groundwork), [`gazette`](https://github.com/tesserine/gazette) | runa-loadable methodology plugins encoding how work is done |
| Engine | [`runa`](https://github.com/tesserine/runa) | Cognitive runtime: loads a methodology, enforces its topology, validates artifacts, drives agent invocations |
| Runtime / host | [`agentd`](https://github.com/tesserine/agentd), [`base`](https://github.com/tesserine/base) | Daemon running runa sessions in isolated containers with sealed audit; reference container image |
| Smoke test | [`example-hello`](https://github.com/tesserine/example-hello) | Cross-stack integration fixture |
| Retired | [`ops`](https://github.com/tesserine/ops) | Tombstone; former operational layer, redirects to successors |

## Repository roster

This is the canonical roster of all Tesserine repositories. The **release
set** — the components composed into an ecosystem release manifest — is a
subset, owned by [`ECOSYSTEM-RELEASE.md`](ECOSYSTEM-RELEASE.md). The two
lists intentionally differ: a repository can be part of the ecosystem
without being a release component.

| Repo | Role | Release set | Status |
| --- | --- | --- | --- |
| `agentd` | Agent-session daemon (isolation, audit) | yes | active |
| `base` | Reference container image | yes | active |
| `commons` | Ecosystem doctrine, contracts, release identity | yes | active |
| `groundwork` | First methodology plugin (software contribution) | yes | active |
| `runa` | Cognitive runtime / execution engine | yes | active |
| `gazette` | Second methodology plugin (periodical chronicle) | no | active, out-of-band |
| `agent-protocols` | Standard for the protocol document form (canonical model + derived views); Tesserine binding recorded in [`bindings/tesserine.md`](https://github.com/tesserine/agent-protocols/blob/main/bindings/tesserine.md) | no | active, draft standard |
| `example-hello` | Canonical integration fixture | no | active, fixture |
| `ops` | Former operational layer | no (historical manifests only) | retired |

`schema_version: 1` ecosystem manifests published before the `ops`
retirement include `ops` as a sixth component; `schema_version: 2`
manifests use the five-component release set. See
[`ECOSYSTEM-RELEASE.md`](ECOSYSTEM-RELEASE.md).

## Canonical sources

| Concept | Canonical | Owner | Everyone else |
| --- | --- | --- | --- |
| Principles | [`pentaxis93/principles`](https://github.com/pentaxis93/principles) | external | `commons` holds redirect pointers ([PRINCIPLES.md](PRINCIPLES.md), [DESIGN-PRINCIPLES.md](DESIGN-PRINCIPLES.md), superseded ADRs); `groundwork/principles/` is an independent *fallback default*, not a mirror |
| Ecosystem ADRs | [`adr/`](adr/) + [`adr/README.md`](adr/README.md) register | `commons` | repos cite ADRs by link; repo-local ADRs (e.g. `groundwork/docs/architecture/decisions/`) cover repo-local scope only |
| Exit codes | [`EXIT-CODES.md`](EXIT-CODES.md) | `commons` | `runa` and `agentd` implement and back-reference; they do not redefine |
| Request artifact | [`REQUEST.md`](REQUEST.md) + [`schemas/request/v1/`](schemas/request/v1/) | `commons` | methodologies vendor with provenance per [ADR-0005](adr/0005-system-conventions.md) |
| Forge capability contract | [`FORGE-CAPABILITY.md`](FORGE-CAPABILITY.md) + [`schemas/forge-capability/v1/`](schemas/forge-capability/v1/) + [ADR-0016](adr/0016-connector-layer-architecture-and-forge-capability.md) | `commons` | `runa`, forge connectors, and methodologies vendor or cite with provenance; they do not expose provider coordinates or reconstruct provider identities outside connectors |
| Schema authority pattern | [ADR-0005](adr/0005-system-conventions.md) + [`schemas/README.md`](schemas/README.md) | `commons` | methodology-private schemas stay in their methodology |
| Release convention | [`RELEASE.md`](RELEASE.md), [`ECOSYSTEM-RELEASE.md`](ECOSYSTEM-RELEASE.md), ADR-0006/0010/0011/0012/0014 | `commons` | per-repo `RELEASING.md` files are thin operator runbooks that defer convention here |
| Release shell tooling | per-repo `scripts/release-check` + `release-cut`, each repo-owned | each release-component repo | the scripts share ancestry ([commons#21](https://github.com/tesserine/commons/issues/21)) but are deliberately independent — no repo is upstream and fixes do not propagate; ownership statement: [base RELEASING.md § Release Tooling Ownership](https://github.com/tesserine/base/blob/main/RELEASING.md#release-tooling-ownership) |
| Ecosystem release set + manifest format | [`ECOSYSTEM-RELEASE.md`](ECOSYSTEM-RELEASE.md) | `commons` | published manifests under [`releases/ecosystem/`](releases/ecosystem/) are the per-release record |
| Methodology format / interface | [`runa/docs/interface-contract.md`](https://github.com/tesserine/runa/blob/main/docs/interface-contract.md) + [authoring guide](https://github.com/tesserine/runa/blob/main/docs/methodology-authoring-guide.md) | `runa` | `groundwork` and `gazette` conform; they do not extend the format |
| Session surface (driver ↔ runa) | [`runa/docs/session-surface-contract.md`](https://github.com/tesserine/runa/blob/main/docs/session-surface-contract.md) | `runa` | drivers (agentd, operators) conform |
| Runtime implementation architecture | [`runa/ARCHITECTURE.md`](https://github.com/tesserine/runa/blob/main/ARCHITECTURE.md) | `runa` | the commons cognitive-state-machine *concept* draft is exploratory and separate (see below) |
| Work-unit / issue methodology | [`groundwork`](https://github.com/tesserine/groundwork) (decompose protocol, work-unit-craft skill, work-unit-model) | `groundwork` | any repo doing work through the methodology follows it |
| Forge mechanics | [`groundwork/mechanics/`](https://github.com/tesserine/groundwork/tree/main/mechanics) | `groundwork` | invariant handles in `manifest.toml`; per-forge implementations in parallel directories |
| Session execution, isolation, audit | [`agentd/ARCHITECTURE.md`](https://github.com/tesserine/agentd/blob/main/ARCHITECTURE.md) | `agentd` | — |
| Operational runbooks (agent host) | [`agentd/docs/runbooks/`](https://github.com/tesserine/agentd/tree/main/docs/runbooks) | `agentd` | `ops` is retired and redirects there; host-specific deployment state belongs to the operator's own host repository |
| Examples / onboarding | distributed: each repo owns its examples; `example-hello` is the canonical cross-stack integration fixture (per [`ECOSYSTEM-RELEASE.md`](ECOSYSTEM-RELEASE.md)) | each repo | examples demonstrate, they do not redefine contracts |
| Documentation discipline | [`groundwork/skills/orient/`](https://github.com/tesserine/groundwork/tree/main/skills/orient) (always-on documentation discipline) | `groundwork` | applies wherever the methodology runs |
| Cognitive-state-machine concept | [`concepts/_drafts/cognitive-state-machine.md`](concepts/_drafts/cognitive-state-machine.md) | `commons` | **exploratory draft, not committed direction** — see [`concepts/README.md`](concepts/README.md) and [commons#16](https://github.com/tesserine/commons/issues/16); no repo may depend on it until ratified |

## Map, not mirror

When a concept appears in more than one repository, exactly one location is
canonical and every other location links to it. Copies are permitted only
as **vendored artifacts with provenance**:

- The copy must record the canonical's immutable URL (commit-SHA or
  release-tag form) and the full semver of the canonical version it
  conforms to ([ADR-0005](adr/0005-system-conventions.md)).
- Where practical, a coherence test must fail when the copy drifts from
  its declared canonical.

The exemplar to imitate: groundwork vendors the commons request schema with
an `x-tesserine-canonical` provenance block
([`groundwork/schemas/request.schema.json`](https://github.com/tesserine/groundwork/blob/main/schemas/request.schema.json))
and a test that enforces content parity
([`groundwork/tests/test_request_schema_vendoring.py`](https://github.com/tesserine/groundwork/blob/main/tests/test_request_schema_vendoring.py)).

Prohibited: new mirrors of principles, exit codes, release convention,
request schema, the ecosystem roster, methodology format, forge mechanics,
or operational runbooks. Reduce existing duplicates to links.

## Release convention vs release tooling

These are deliberately split:

- **Convention** — what a release *is* (atomic operation, tag grammar,
  manifest identity, verification obligations) — is canonical in
  `commons` (this repo).
- **Shell tooling** — the `release-check` / `release-cut` script family is
  **per-repo-owned**: each release-component repo implements the ceremony
  against its own release surface. The implementations share ancestry from
  the ceremony adoption ([commons#21](https://github.com/tesserine/commons/issues/21))
  but are deliberately independent — no repo is the tooling upstream, and a
  fix in one does not propagate. Each script carries a provenance header
  stating this.
- **Per-repo `RELEASING.md`** files are thin operator runbooks: repo-specific
  steps plus links up to the commons convention and the tooling-ownership
  statement in base's RELEASING.md.

## Verification

- A concept has exactly one canonical: `rg -l '<concept>'` across repos
  finds one defining document; all other hits are links or
  provenance-marked vendored copies.
- Roster coherence: the roster table above, `README.md`'s ecosystem list,
  and `ECOSYSTEM-RELEASE.md`'s release set agree or explicitly state why
  they differ.
- ADR register coherence: `adr/README.md` row count equals the number of
  `adr/*.md` decision files.

## Change policy

Re-homing a canonical, adding an ecosystem-level concept, or adding/retiring
a repository requires updating this map in the same change. A canonical
named nowhere in this map is not canonical.
