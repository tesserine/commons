# commons

Shared principles and standards for the Tesserine ecosystem.

## What this is

This repo holds the bedrock principles, design principles, and architectural decision records (ADRs) that define standards across all Tesserine components. Every repo — whether it builds infrastructure, runtime, or methodology — derives its standards from what lives here.

## Ecosystem repos

The canonical roster and ownership map live in
[SOURCE-OF-TRUTH.md](SOURCE-OF-TRUTH.md). Summary:

- **[agentd](https://github.com/tesserine/agentd)** — container lifecycle daemon for autonomous agent sessions
- **[runa](https://github.com/tesserine/runa)** — cognitive runtime enforcing methodology topologies
- **[groundwork](https://github.com/tesserine/groundwork)** — contributor methodology plugin (first methodology)
- **[base](https://github.com/tesserine/base)** — reference container image for agent sessions
- **[gazette](https://github.com/tesserine/gazette)** — periodical-chronicle methodology plugin (not in the ecosystem release set)
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
- **[RELEASE.md](RELEASE.md)** — release process for Tesserine cargo-workspace repos, formalized by [ADR-0006](adr/0006-release-discipline.md)
- **[RELEASING.md](RELEASING.md)** — commons-specific release ceremony for this docs and schemas repository
- **[ECOSYSTEM-RELEASE.md](ECOSYSTEM-RELEASE.md)** — ecosystem release manifest format and cross-repo verification contract
- **[schemas/](schemas/)** — versioned JSON Schemas that are the machine-checkable realizations of canonical artifact specs; indexed in [schemas/README.md](schemas/README.md)
- **[adr/](adr/)** — architectural decision records, indexed with status and lineage in [adr/README.md](adr/README.md). Six principle-shaped ADRs (0001–0004, 0007, 0013) have been superseded by the canonical corpus at `pentaxis93/principles` and replaced with pointer documents. Nine genuine decisions (0005–0006, 0008–0012, 0014–0015) remain active.
- **[concepts/](concepts/)** — conceptual foundation documents, indexed in [concepts/README.md](concepts/README.md). Currently holds only **exploratory drafts** (`concepts/_drafts/`), which are not committed project direction.

## Relationship to individual repos

Each repo may have its own repo-specific ADRs that trace back to the shared principles defined here. This repo holds what is universal across the ecosystem; individual repos hold what is specific to their domain.

## Proposing changes

Open an issue or pull request on this repo. Changes to shared principles affect the entire ecosystem, so proposals should demonstrate that the change serves the ecosystem's trajectory, not just one repo's convenience.
