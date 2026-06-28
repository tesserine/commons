# ADR-0016: Connector-Layer Architecture and Forge Capability

**Status:** Accepted
**Traces to:** [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md) (primary), [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md) (secondary)
**Instantiates:** [Architectural layers bounded by contracts](https://github.com/pentaxis93/commons/blob/main/golden-rules/README.md) — the pentaxis93 golden rule this decision realizes for the forge domain: the capability is the contract; connectors are the swappable adapters behind it.

## Decision

Tesserine introduces a connector layer between methodology obligations and
provider substrates. A **capability** is the abstract, domain-neutral operation
interface a methodology binds to for one substrate domain. The concept names no
domain by itself; a specific capability carries a substrate domain as content.

The first capability is the **forge capability**: domain `forge`, with these
eight operations:

- `read-ticket`
- `create-ticket`
- `claim-work-unit`
- `record-progress`
- `reflect-disposition`
- `close-out`
- `deliver-change-proposal`
- `apply-approved-change`

A methodology binds to a capability, not a provider, and may use any subset of
the capability's operations. A methodology using only ticket creation and
progress recording does not have to exercise change-proposal delivery; a
publishing methodology that owns its own repository can use proposal and apply
operations without taking on tracker creation. Subset use must compose without
provider-specific branches at the methodology boundary.

A **connector** implements one capability for one provider. `github` and
`sourcehut` are connectors implementing the forge capability. Forge names the
substrate domain and provider class; the connector is the primary deployable
concept. A deployment selects which connector binds a methodology to its chosen
substrate.

The capability interface is the abstract provider-agnostic caller contract.
Provider coordinates, query URLs, repository names, tracker identifiers, SSH
remotes, and credentials resolve inside the connector from deployment
configuration. They never appear in the capability interface. Forge operations
whose caller inputs converge are direct; operations whose provider mechanics
diverge are expressed through one abstraction both connectors map onto:
opaque work-unit handles, opaque change handles, source-control facts, typed
dispositions, completion context, and apply evidence.

A connector is an in-process Rust component that contributes a set of MCP tools
to runa's existing MCP surface: a tool specification plus handlers. Runa
exposes the union of contributed tool-sets. Connectors are first-class crates
in the runa workspace. Engine crates do not depend on any provider connector;
provider connectors depend on the plugin contract defined by the engine; a
composition layer links the engine with the connectors selected for a
deployment.

The engine is substrate-agnostic. Provider identity, provider hosts, and
provider operations live only in connectors. The engine treats work-unit and
change handles as opaque values: an `id` compared for equality and a `display`
string rendered for humans. The handle shape is `{ id, display }`, replacing
forge-shaped `oneOf` handles in engine-facing contracts.

Each connector is the single home of its provider's coordinates and the single
producer of its provider's identities. No engine path and no methodology reads
provider coordinates or constructs a provider identity; both are obtained only
from the connector. Downstream implementation must enforce this with a
build-or-CI guard that fails on reconstructed provider identity and with a
cold-start integration test exercising the real acquisition path against a
configured deployment that includes a non-default host.

Name collisions in the tool-set union are loud composition failures. They are
resolved by a declared alias at the composition site, qualified by role rather
than provider and explicit rather than auto-applied.

The forge capability contract is a cross-component artifact governed by
[ADR-0005](0005-system-conventions.md). Its canonical form is the prose
authority [`FORGE-CAPABILITY.md`](../FORGE-CAPABILITY.md) at repo root plus
the versioned schema
[`schemas/forge-capability/v1/forge-capability.schema.json`](../schemas/forge-capability/v1/forge-capability.schema.json).
The prose is authoritative; the schema is its mechanical realization.

## Context

The connector epic needs a layer-zero contract before runa, connector, and
groundwork slices can proceed independently. The existing forge-address work
surfaced the important failure mode: schema-conforming provider identity can
still be wrong for a configured deployment when non-connector code
reconstructs provider grammar from scattered coordinates.

The previous shape coupled methodology mechanics and engine validation to
forge-shaped identities: GitHub issue and pull-request URLs on one side,
SourceHut tracker IDs and proposal refs on the other. That made provider
identity visible outside the provider implementation and forced engine paths to
know provider grammar. It also left divergent operations vulnerable to a
per-provider parameter list rather than an interface a methodology can bind to.

The connector layer moves provider identity and provider mechanics behind an
in-process component boundary while preserving the session MCP surface as the
agent-facing operational substrate. The methodology speaks capability
operations. The selected connector maps those operations to provider APIs and
provider storage.

## Consequences

**Methodologies become provider-agnostic at the operation boundary.** A
methodology declares that it needs the forge capability and calls the operations
it needs. It does not switch on GitHub, SourceHut, hostnames, tracker IDs, or
repository coordinates.

**Connectors own provider configuration and identity production.** Deployment
configuration resolves inside the connector. Handles crossing the capability
boundary are opaque and connector-issued. The engine may compare handle `id`
values and render `display`; it must not parse provider identity out of either
field.

**Divergent provider mechanics map to one abstraction.** GitHub's issue and PR
model and SourceHut's ticket, proposal-ref, and patch application model are
both represented through work-unit handles, change handles, source-control
facts, typed disposition data, completion context, and apply evidence. The
contract does not grow provider-specific fields as new connectors appear.

**Runa composes tool-sets, not provider branches.** The runtime's MCP surface is
the union of tool-sets contributed by the selected methodology and connectors.
Composition fails loudly on collisions unless the composition site declares a
role-qualified alias. Aliasing is explicit configuration, not a provider-named
automatic prefix.

**Engine crates stay provider-free.** Provider connector crates may depend on
the runa plugin contract. Engine crates depend on that contract but not on
provider connectors. The composition layer links the deployment-specific set.

**Downstream enforcement is required.** The architecture is not satisfied by
documentation alone. Runa and connector work must include a guard that catches
reconstructed provider identity outside connectors, and an integration test
that proves cold-start acquisition works against a configured non-default host.

**Future capabilities are siblings, not extensions of forge.** Task
management, calendaring, strategic planning, or other substrate domains get
their own capability contracts only when a real connector and methodology need
them. This ADR defines exactly one capability now: the forge capability.

**What this means for the builder agent:** When implementing downstream slices,
do not add provider coordinates, credentials, provider tags, URLs, tracker IDs,
or SSH remotes to the capability interface. Put them in the connector's
deployment configuration and produce opaque handles at the connector boundary.
When an operation differs by provider, design the shared abstraction first and
map provider mechanics into it inside each connector.
