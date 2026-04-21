# Request

Canonical contract for the request artifact — the entry point that triggers
a session in the Tesserine ecosystem.

A request artifact is the lightweight door through which operator intent
crosses into an execution session. Every methodology that supports
operator-initiated work has a notion of "request"; making this canonical
preserves methodology-agnosticism at the session boundary while letting
producers (agentd and methodology tools) and consumers (runa, methodology
runtimes) agree on shape without coupling to a specific methodology.

## Version

`1.0.0`

## Stable identifier

Two reference forms exist and serve different purposes:

- **Navigation (mutable).** `https://raw.githubusercontent.com/tesserine/commons/main/schemas/request/v1/request.schema.json`.
  Useful for humans browsing the current authoritative version. Not
  acceptable as a conformance target: `main` moves.
- **Conformance (immutable).** Either a commit-SHA URL
  (`https://raw.githubusercontent.com/tesserine/commons/<sha>/schemas/request/v1/request.schema.json`)
  or a release-tag URL
  (`https://raw.githubusercontent.com/tesserine/commons/v0.1.1/schemas/request/v1/request.schema.json`).
  Methodology vendoring provenance and cross-repo conformance claims must
  use an immutable form; a conformance claim against a moving target is
  not a conformance claim.

The versioned path segment (`schemas/request/v1/...`) is independently
immutable by convention: once published, a `v1` directory does not change
shape. Breaking changes go to a new directory.

## Contract

A request is a JSON object with the following fields:

| Field | Required | Type | Constraints | Meaning |
| --- | --- | --- | --- | --- |
| `description` | yes | string | non-empty | What is being asked for. |
| `source` | yes | string | non-empty | Where the request originated (operator, user report, automated detection). |
| `context` | no | string | — | Anything else the requester wants to include. |

Additional properties are not permitted.

## Machine-checkable schema

The authoritative JSON Schema for this contract lives at
[`schemas/request/v1/request.schema.json`](schemas/request/v1/request.schema.json).

When this document and the schema disagree, **this document is
authoritative** and the schema is a defect to be corrected. Review catches
divergence before it ships; runtime consumers of the schema are not
expected to cross-check against this prose.

## Change policy

Semantic versioning:

- **Minor and patch.** Clarifying rewordings, adding a new optional field
  that existing producers and consumers can ignore without loss, or
  tightening descriptions without narrowing the accepted value set.
  Applied in place at the current `vN/` path; full semver advances.
- **Major.** Removing a field, making an optional field required,
  narrowing a value space, renaming fields, or any other change that can
  break an existing conforming consumer. Requires a new versioned
  directory (`v2/`, `v3/`, ...) alongside the existing one. Old versions
  remain reachable forever; consumers migrate by changing their
  conformance declaration.

## Vendoring

Methodologies that produce or consume request artifacts embed a copy of
the canonical schema in their own `schemas/` directory with provenance
metadata identifying the canonical version they conform to (full semver
plus commit-SHA or release-tag URL). ADR-0005 describes the full
system-conventions pattern.
