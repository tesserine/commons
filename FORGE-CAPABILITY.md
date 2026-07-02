# Forge Capability

Canonical contract for the forge capability: the connector-layer interface for
work-unit tracker and change-proposal operations across forge providers.

The forge capability lets a methodology ask for forge-domain effects without
binding to a forge provider. A methodology binds to the capability and calls
the operations it needs. A deployment selects a connector implementing this
capability for one provider, and the connector maps the abstract calls to that
provider's APIs, repository model, tracker model, and credential surface.

Provider coordinates and secrets are outside this interface. Repository names,
tracker identifiers, provider hosts, query URLs, SSH remotes, tokens, and
provider-specific user identities resolve inside the connector from deployment
configuration. A caller supplies only capability-domain data.

## Version

`1.2.0`

## Stable Identifier

Two reference forms exist and serve different purposes:

- **Navigation (mutable).** `https://raw.githubusercontent.com/tesserine/commons/main/schemas/forge-capability/v1/forge-capability.schema.json`.
  Useful for humans browsing the current authoritative version. Not
  acceptable as a conformance target: `main` moves.
- **Conformance (immutable).** Either a commit-SHA URL
  (`https://raw.githubusercontent.com/tesserine/commons/<commit-sha>/schemas/forge-capability/v1/forge-capability.schema.json`)
  or a release-tag URL
  (`https://raw.githubusercontent.com/tesserine/commons/<release-tag>/schemas/forge-capability/v1/forge-capability.schema.json`).
  These URLs are schematic; provenance and conformance claims must replace
  the placeholder token with a real immutable identifier. Connector,
  methodology, and runtime vendoring provenance must use an immutable form.

The versioned path segment (`schemas/forge-capability/v1/...`) is the
major-version URL-stability boundary described by ADR-0005. Once published,
`v1` keeps the same identity and location. Minor and patch releases may evolve
the content in place only through additive optional fields and clarifications
that do not break a conforming consumer. Breaking changes go to a new
directory. Conformance claims pin to a full semver such as `1.0.0`, not to the
major version alone.

## Concepts

### Capability

A capability is the abstract, domain-neutral operation interface a methodology
binds to for one substrate domain. The concept itself names no domain. A
specific capability carries a substrate domain as content.

The forge capability is the first capability. It covers forge-domain work:
tracker tickets, work-unit progress, change proposal delivery, review
disposition reflection, close-out, and application of approved change.

### Connector

A connector implements one capability for one provider. `github` and
`sourcehut` are connectors implementing the forge capability. A connector is
the single home of its provider's coordinates and the single producer of its
provider's identities.

The connector boundary is in-process. A connector contributes MCP tools to
runa's MCP surface by providing a tool specification and handlers. Runa
composes the union of selected tool-sets for a deployment.

### Forge Work-Unit Identity

A forge work-unit identity names exactly one unit of work, in exactly one
scope, on one provider deployment. Two properties make an identity sound, and
they are required of every connector regardless of provider:

- **Complete.** The owning connector can re-target precisely that one unit from
  the identity alone. An identity that resolves to more than one unit — or to a
  different unit under a different deployment — is not complete.
- **Scoped.** The identity carries the coordinate that determines which
  deployment, tracker, or repository it belongs to. A connector must validate
  that coordinate against its configured scope and reject a foreign-scope
  identity **before performing any operation**, destructive operations
  especially. A bare item number is not a scoped identity.

This model is provider-agnostic. It is the contract; a provider is a
projection of it. `github` projects the scope as `owner/repo`; `sourcehut`
projects the scope as a tracker identifier. Neither provider defines the model,
and the model is never derived from one provider's incidental form and patched
toward the others.

Two forms of identity cross the capability seam:

- A **reference** is the caller-facing locator used to first reach a unit (the
  input to `read-ticket`). It may carry provider coordinates. It is opaque to
  the engine and methodology — they never parse it — but the connector resolves
  it, and validates any coordinate it carries against the connector's
  configured scope, rejecting a foreign scope.
- A **handle** is the connector-issued identity returned by an operation and
  used thereafter (the `{ id, display }` below). Its `id` is complete and
  scoped per the properties above.

### Opaque Handle

The shared handle shape is:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `id` | yes | string | Connector-issued identity token, compared for equality only. |
| `display` | yes | string | Human-readable rendering of the handled object. |

Additional fields are not permitted.

The handle is opaque to the engine and methodology. The engine may compare
`id` values for equality and render `display`; it must not parse either field,
infer provider type, reconstruct provider coordinates, or derive provider
identity grammar from the value.

Connectors choose the `id` encoding, but it is not free: the `id` must be a
complete, scoped identity per **Forge Work-Unit Identity** above — it encodes
the provider scope and the item such that it re-targets exactly one work unit,
and the connector rejects any handle whose scope differs from its configured
scope before performing an operation. "Compared for equality only" describes
the engine's treatment, not a licence for a non-self-contained id. Callers
cannot construct handles except by receiving them from a connector operation.

## Operation Contract

The forge capability has exactly eight operations. A methodology may use a
subset; unused operations impose no provider-specific obligations on that
methodology.

Every operation name below is canonical. Provider coordinates and credentials
are never operation inputs.

### `read-ticket`

Reads an existing deployment-local tracker ticket and returns its work-unit
snapshot.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `reference` | yes | string | A connector-interpreted ticket reference in the active deployment. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | Opaque work-unit ticket handle produced by the connector. |
| `title` | yes | string | Ticket title or subject. |
| `body` | no | string or null | Ticket body text if present. |
| `state` | yes | string | Connector-normalized ticket state label. |
| `comments` | no | array of comment entries | The ticket's comment log, ordered oldest first. |

The ticket body is the work-unit's spec; the comment log is its running
record — review state, dispositions, and directives live there. The snapshot
carries the log so a caller grounds on the whole ticket, not the spec alone.
Each comment entry carries `body` (required, string); the connector includes
`author` (string) and `created_at` (string, a provider-normalized timestamp)
when the provider supplies them.

The reference is opaque to the engine and methodology: they never parse it. It
is the caller-facing form of a forge work-unit identity (see **Forge Work-Unit
Identity**), so it may carry provider coordinates — a deployment renders
references in a coordinate-bearing form. The connector resolves the reference
to a provider ticket and validates any coordinate it carries against the
connector's configured scope, rejecting a foreign scope. The reference grammar
and its resolution are connector-owned; the caller never needs to know them.

### `create-ticket`

Creates a tracker ticket in the connector's configured work-unit home and
returns the connector-issued work-unit handle.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `title` | yes | string | Work-unit ticket title. |
| `body` | yes | string | Work-unit ticket body. |

Output is the same ticket snapshot shape returned by `read-ticket`. A
just-created ticket carries an absent or empty comment log.

### `claim-work-unit`

Marks a work-unit as claimed or in progress on the provider surface.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | Opaque work-unit handle previously produced by the connector. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | The claimed work-unit handle. |
| `receipt` | yes | string | Connector-produced record of the claim effect. |

The actor or assignee identity is connector/deployment configuration, not a
caller parameter.

### `record-progress`

Records progress text against a work-unit's provider surface.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | Opaque work-unit handle. |
| `body` | yes | string | Progress text to record. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | Work-unit handle the progress was recorded against. |
| `receipt` | yes | string | Connector-produced record of the progress event. |

### `deliver-change-proposal`

Delivers a reviewable change proposal version and returns an opaque change
handle. GitHub can map this to a pull request; SourceHut can map it to a
persistent feature branch plus immutable proposal ref. The interface is one
abstraction, not a per-provider parameter list.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Opaque work-unit handle the proposal belongs to. |
| `branch` | yes | string | Source-control branch or carrier name for revision work. |
| `commit` | yes | string | Exact proposed commit or stable revision identifier. |
| `base` | yes | string | Target base revision or branch. |
| `summary` | yes | string | Human-readable proposal summary. |
| `body` | yes | string | Proposal body for reviewers. |
| `version` | yes | integer | Immutable review-round version for this work unit, starting at 1. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `handle` | yes | handle | Opaque change handle produced by the connector. |
| `work_unit` | yes | handle | Work-unit handle supplied by the caller. |
| `commit` | yes | string | Delivered commit or stable revision identifier. |
| `version` | yes | integer | Delivered review-round version. |

### `reflect-disposition`

Records a typed review disposition on the provider surfaces after the
methodology has acted on it.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Opaque work-unit handle. |
| `change` | yes | handle | Opaque change handle. |
| `disposition` | yes | object | Typed disposition: `approved` or `needs-revision`, reviewed proposal version, reviewer, timestamp, and findings. |
| `body` | yes | string | Human-readable disposition reflection text. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Work-unit handle the disposition was reflected against. |
| `change` | yes | handle | Change handle the disposition was reflected against. |
| `receipt` | yes | string | Connector-produced record of the reflection effect. |

### `apply-approved-change`

Applies the exact approved change version. GitHub can map this to merging a
pull request whose head matches the approved commit; SourceHut can map it to
fetching an immutable proposal ref, verifying the approved commit, and pushing
the target ref. The caller contract is identical for both.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Opaque work-unit handle. |
| `change` | yes | handle | Opaque change handle. |
| `approved_version` | yes | integer | Approved review-round version. |
| `approved_commit` | yes | string | Exact commit or stable revision identifier approved for application. |
| `base` | yes | string | Base revision or branch recorded with the approved proposal. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Work-unit handle whose change was applied. |
| `change` | yes | handle | Change handle applied. |
| `applied_commit` | yes | string | Exact commit or revision applied. |
| `receipt` | yes | string | Connector-produced record of the apply effect. |

### `close-out`

Records completion context and closes or resolves the work-unit provider
surface.

Caller input:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Opaque work-unit handle. |
| `completion` | yes | object | Completion context: criterion summary, gaps, merge or apply reference, and documentation status. |
| `body` | yes | string | Human-readable close-out text. |

Output:

| Field | Required | Type | Meaning |
| --- | --- | --- | --- |
| `work_unit` | yes | handle | Work-unit handle closed out. |
| `receipt` | yes | string | Connector-produced record of the close-out effect. |

## Connector Tool-Spec

A connector implementing the forge capability contributes a tool-set
descriptor with:

- `capability`: `forge`
- `version`: full semver, initially `1.0.0`
- `handle_schema`: `#/$defs/handle`
- one MCP tool for each of the eight canonical operations

Each tool descriptor names the canonical `operation`, the exposed MCP tool
`name`, and the schema references for input and output. The canonical exposed
name is the operation name. If composition would collide with another tool in
runa's tool-set union, composition fails loudly unless the composition site
declares an alias. Aliases are role-qualified and explicit; they are not
automatically provider-prefixed.

The tool-set union belongs to runa composition. The connector owns its handlers
and provider mapping. The engine owns neither provider coordinates nor provider
identity grammar.

## Machine-Checkable Schema

The authoritative JSON Schema for this contract lives at
[`schemas/forge-capability/v1/forge-capability.schema.json`](schemas/forge-capability/v1/forge-capability.schema.json).
The authoritative schema intentionally omits `$id`; machine identity for this
canonical lives in immutable provenance and conformance references, not in
embedded schema metadata.

When this document and the schema disagree, **this document is authoritative**
and the schema is a defect to be corrected. Review catches divergence before it
ships; runtime consumers of the schema are not expected to cross-check against
this prose.

## Change Policy

Semantic versioning:

- **Minor and patch.** Clarifying rewordings, adding optional fields that
  preserve compatibility for conforming consumers, or tightening descriptions
  without narrowing the accepted value set. Applied in place at the current
  `vN/` path while full semver advances.
- **Major.** Removing an operation, renaming an operation, making an optional
  field required, narrowing a value space, exposing provider coordinates or
  credentials in the caller interface, changing handle opacity, or any other
  change that can break an existing conforming consumer. Requires a new
  versioned directory (`v2/`, `v3/`, ...) alongside the existing one.

## Vendoring

Connectors, methodologies, and runtime components that consume this canonical
embed the schema or operation definitions with provenance metadata identifying
the canonical version they conform to: full semver plus commit-SHA or
release-tag URL. That immutable provenance carries the canonical machine
identity for the vendored copy. ADR-0005 describes the full
system-conventions pattern.
