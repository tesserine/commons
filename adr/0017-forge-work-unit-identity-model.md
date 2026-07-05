# ADR-0017: Forge Work-Unit Identity Model

**Status:** Accepted
**Traces to:** [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md) (primary), [Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md), [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md)
**Refines:** [ADR-0016](0016-connector-layer-architecture-and-forge-capability.md) (the opaque-handle model stands; this ADR specifies what makes a handle adequate)

## Decision

A forge work-unit identity names exactly one unit of work, in exactly one
scope, on one provider deployment. Two properties are required of every
connector's identities, regardless of provider:

- **Complete.** The owning connector re-targets precisely that one unit from
  the identity alone.
- **Scoped.** The identity carries the coordinate that determines which
  deployment, tracker, or repository it belongs to, and the connector validates
  that coordinate against its configured scope and rejects a foreign-scope
  identity *before performing any operation* — destructive operations
  especially.

This holds for both forms that cross the capability seam. A **reference**
(the `read-work-unit` input) is the caller-facing locator; it may carry provider
coordinates, is opaque to the engine and methodology, and is resolved and
scope-validated by the connector. A **handle** (`{ id, display }`) is the
connector-issued identity; its `id` is complete and scoped. "Compared for
equality only" describes the engine's treatment of the `id`, not a licence for
a non-self-contained value.

The model is provider-agnostic and is the contract. A provider is a projection
of it: `github` projects scope as `owner/repo`, `sourcehut` projects scope as a
tracker identifier. The model is never derived from one provider's incidental
form and patched toward the others.

At ADR acceptance time, this identity-model tightening moved the forge
capability to `1.1.0` in place under `schemas/forge-capability/v1/`. The
current v2 major keeps this identity model while renaming the caller-facing
read operation to `read-work-unit`.

## Context

ADR-0016 established the connector layer and the opaque `{ id, display }`
handle, with the engine comparing `id` for equality only. That framing left the
`id`'s *content* entirely to the connector ("whatever internal provider
identity they need"), and described the historical v1 `read-ticket` reference
as carrying no provider coordinates. Both were under-specifications rather than
decisions.

Under that text a number-only handle — `github:issue:42` with no repository — is
conformant. Passed to a connector configured for a different repository, it
comments on, closes, or merges issue/PR 42 in *that* repository: a
destructive-operation cross-scope hazard. Two connector implementations of the
same capability diverged exactly where the contract was silent — `sourcehut`
encoded its tracker coordinate and validated it, `github` did not — which is the
signature of a missing contract, not a connector defect. The reference clause
separately contradicted what runa renders to agents (`github:owner/repo#N`,
coordinate-bearing).

The repair is not to patch each connector. It is to ground the capability in the
general principle of what a work-unit identity must guarantee — complete and
scoped, with scope validated before any effect — so that the identity model has
one home (the capability) and each connector projects its provider into it.
This keeps `github` and `sourcehut` as instances of the contract rather than
letting either define it (usage sets a floor, not a ceiling).

## Consequences

- Connectors must issue complete, scoped handles and validate the scope of any
  inbound handle or reference before acting. A connector's identity encoding is
  its own, but its adequacy is contractual.
- The change tightens a connector obligation and reconciles prose; it does not
  alter the caller-facing interface shape (operations, `{ id, display }`,
  reference-as-string). No conforming *consumer* (methodology or engine) breaks,
  so the capability evolves in place to `1.1.0` within `v1/` rather than to a
  new major directory. Connector descriptors declare `1.1.0`.
- The runa connector slice (tesserine/runa#203) is re-crafted against this
  version: connectors own reference→handle resolution and scope validation, and
  the engine's legacy reference parsing (`libagent`) is retired by the later
  epic unit, never duplicated as a second home.
- The current forge-capability v2 major keeps this identity model and names the
  caller-facing read operation `read-work-unit`; the v1 `read-ticket` spelling
  is retained only as historical context for the under-specification this ADR
  corrected.
