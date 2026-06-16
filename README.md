# commons

**The constitution of the Tesserine ecosystem — enforced, not aspirational.**

Most projects have conventions that live in prose and drift in practice.
commons is built so that drifting from the constitution *fails a test
somewhere*: the shared exit-code contract is vendored downstream with
provenance and verified by parity tests
([EXIT-CODES.md § Downstream Conformance](EXIT-CODES.md#downstream-conformance)),
the request-artifact schema is vendored with immutable provenance and a
coherence gate ([ADR-0005](adr/0005-system-conventions.md)), and the release
ceremony is checked by executable verifiers in every release-component repo.

This repo is the ecosystem's convention and ADR authority: cross-component
contracts, release identity, the decision record, and —
most importantly — the **[source-of-truth map](SOURCE-OF-TRUTH.md)**, which
names exactly one canonical home for every shared concept and the rule that
everyone else links rather than mirrors. When two documents disagree, the map
says which one is wrong. The bedrock principles themselves live at their
canonical home, [pentaxis93/principles](https://github.com/pentaxis93/principles);
this repo carries the pointers and the decisions that trace to them.

## Ecosystem repos

The canonical roster and ownership map live in
[SOURCE-OF-TRUTH.md](SOURCE-OF-TRUTH.md). Summary:

- **[agentd](https://github.com/tesserine/agentd)** — container lifecycle daemon for autonomous agent sessions
- **[runa](https://github.com/tesserine/runa)** — cognitive runtime enforcing methodology topologies
- **[groundwork](https://github.com/tesserine/groundwork)** — contributor methodology plugin (first methodology)
- **[base](https://github.com/tesserine/base)** — reference container image for agent sessions
- **[gazette](https://github.com/tesserine/gazette)** — periodical-chronicle methodology plugin (not in the ecosystem release set)
- **[agent-protocols](https://github.com/tesserine/agent-protocols)** — draft standard for the protocol document form: one canonical model per protocol, diagrams as computed projections (not in the ecosystem release set)
- **[example-hello](https://github.com/tesserine/example-hello)** — canonical cross-stack integration fixture
- **[ops](https://github.com/tesserine/ops)** — retired; redirects to successor documents

The five release components (agentd, base, commons, groundwork, runa) are
defined by [ECOSYSTEM-RELEASE.md](ECOSYSTEM-RELEASE.md). Future repos
inherit these principles by default.

## Contents

- **[SOURCE-OF-TRUTH.md](SOURCE-OF-TRUTH.md)** — canonical ownership map: which repository and document owns each ecosystem-level concept
- **[PRINCIPLES.md](PRINCIPLES.md)** — seven bedrock principles (historical). Canonical home: [`pentaxis93/principles`](https://github.com/pentaxis93/principles).
- **[DESIGN-PRINCIPLES.md](DESIGN-PRINCIPLES.md)** — 21 engineering design principles (historical). Canonical home: [`pentaxis93/principles`](https://github.com/pentaxis93/principles).
- **[EXIT-CODES.md](EXIT-CODES.md)** — shared session-outcome exit code contract for runners and callers across the ecosystem
- **[REQUEST.md](REQUEST.md)** — canonical contract for the request artifact, the entry point that triggers a session
- **[FORGE-CAPABILITY.md](FORGE-CAPABILITY.md)** — canonical connector-layer contract for provider-agnostic forge operations and opaque handles
- **[RELEASE.md](RELEASE.md)** — release process for Tesserine cargo-workspace repos, formalized by [ADR-0006](adr/0006-release-discipline.md)
- **[RELEASING.md](RELEASING.md)** — commons-specific release ceremony for this docs and schemas repository
- **[ECOSYSTEM-RELEASE.md](ECOSYSTEM-RELEASE.md)** — ecosystem release manifest format and cross-repo verification contract
- **[schemas/](schemas/)** — versioned JSON Schemas that are the machine-checkable realizations of canonical artifact specs; indexed in [schemas/README.md](schemas/README.md)
- **[scripts/](scripts/)** — executable verifiers: `verify-ecosystem-manifest`
  (validates a published ecosystem manifest; see [ECOSYSTEM-RELEASE.md](ECOSYSTEM-RELEASE.md)),
  the commons release tooling (`release-check`, `release-cut` — see
  [RELEASING.md](RELEASING.md)), and their test harnesses
  (`test-ecosystem-manifest`, `test-release-check`,
  `verify-release-adoption.sh`). Python dependencies: `pip install -r requirements.txt`.
- **[adr/](adr/)** — architectural decision records, indexed with status and lineage in [adr/README.md](adr/README.md). Six principle-shaped ADRs (0001–0004, 0007, 0013) have been superseded by the canonical corpus at `pentaxis93/principles` and replaced with pointer documents. Ten genuine decisions (0005–0006, 0008–0012, 0014–0016) remain active.
- **[concepts/](concepts/)** — conceptual foundation documents, indexed in [concepts/README.md](concepts/README.md). Currently holds only **exploratory drafts** (`concepts/_drafts/`), which are not committed project direction.

## Relationship to individual repos

Each repo may have its own repo-specific ADRs that trace back to the shared principles defined here. This repo holds what is universal across the ecosystem; individual repos hold what is specific to their domain.

## Proposing changes

Open an issue or pull request on this repo. Changes to shared principles affect the entire ecosystem, so proposals should demonstrate that the change serves the ecosystem's trajectory, not just one repo's convenience.
