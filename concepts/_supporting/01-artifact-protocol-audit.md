# Artifact and Protocol Audit for the Cognitive State Machine Draft

**Status:** Wave-1 supporting finding for
[`tesserine/commons#16`](https://github.com/tesserine/commons/issues/16),
produced by
[`tesserine/commons#86`](https://github.com/tesserine/commons/issues/86).
This document is evidence for later synthesis. It is not an ADR, does not
promote the draft, and commits Tesserine to no project direction on its own.

**Question answered:** does Tesserine's actual artifact-and-protocol substrate
support the draft's categorial vocabulary, and does the threshold framing
hold as one transition or as a cluster?

**Verdict:** the categorial vocabulary fits the Layer-1 substrate if read as a
runtime graph of validated artifact types and declared protocol edges, not as
a fully algebraic type system. The threshold framing holds as a real
distinction: current Tesserine mostly performs classification typing, while
evidential typing would require additional substrate mechanisms. The audit
does not support one single threshold. It shows a cluster of separable
transitions: constructor gating, refinement predicates, provenance carrying,
and evidence-preserving composition already appear in partial, local forms,
but they do not yet compose into the stronger property that existence of a
typed value is itself sound evidence of how it was produced.

## Evidence Base

The audit uses the current implementation substrate, pinned so later readers
can inspect the same ground.

| Repo | Commit | Ground used |
| --- | --- | --- |
| `commons` | `ab9b9d35d8ffbdb414aa58f9a6f89fceedd3a41f` | `concepts/_drafts/cognitive-state-machine.md`, `concepts/README.md`, `SOURCE-OF-TRUTH.md`, commons-owned schemas and contracts |
| `runa` | `beb996ced42d525979a4a8d6e237ae7b0a4b9676` | `docs/interface-contract.md`, `ARCHITECTURE.md`, runtime implementation descriptions |
| `groundwork` | `11f0bec0f081f03b660e2084999b55cc09edb9d2` | `manifest.toml`, `schemas/*.schema.json`, `protocols/*/PROTOCOL.md` |
| `gazette` | `80d167ac826acad143399b71edf273933cf4ce37` | `manifest.toml`, `schemas/*.schema.json`, `protocols/*/PROTOCOL.md` |
| `agent-protocols` | `b31d6dbd95fa573f0d787ab99e719fca9794239d` | `bindings/tesserine.md`, `schemas/protocol.schema.json` |

`runa` ADR-0001 material is deliberately out of scope. The audit grounds in
`runa` main-head implementation because ADR-0001 is downstream Tier-3 work
that depends on this CSM ratification path; including it would add no
artifact/protocol implementation evidence and would risk circular grounding.

## Substrate Inventory

`runa` defines the runtime boundary. A methodology supplies artifact types,
protocol declarations, and trigger conditions; `runa` validates artifacts,
computes the graph from artifact relationships, enforces preconditions and
postconditions, injects context, and does not interpret methodology semantics
[`runa:docs/interface-contract.md@beb996ced4`]. `runa` ships no artifact
types; every artifact type is methodology-owned, with JSON Schema at
`schemas/{name}.schema.json` and protocol instructions at
`protocols/{name}/PROTOCOL.md`.

`groundwork` is a scoped work methodology. Its manifest declares 12 artifact
types: `request`, `requirements`, `work-unit`, `behavior-contract`,
`implementation-plan`, `test-evidence`, `completion-evidence`,
`change-proposal`, `change-approved`, `change-needs-revision`,
`completion-record`, and `research-record`
[`groundwork:manifest.toml@11f0bec0`]. Its protocol graph is:

| Protocol | Signature surface |
| --- | --- |
| `survey` | `request` -> `requirements`; may produce `research-record` |
| `decompose` | `requirements` -> `work-unit`; may produce `research-record` |
| `take` | scoped `work-unit` -> `behavior-contract`; may produce `research-record` |
| `plan` | scoped `behavior-contract`, accepting `work-unit` -> `implementation-plan`; may produce `research-record` |
| `implement` | scoped `behavior-contract` x `implementation-plan` -> `test-evidence` |
| `verify` | scoped `behavior-contract` x `test-evidence` x `work-unit` -> `completion-evidence` |
| `submit` | scoped `completion-evidence` x `behavior-contract` -> `change-proposal` |
| `review` | scoped `change-proposal` x `behavior-contract` -> exactly one of `change-approved` or `change-needs-revision` |
| `land` | scoped `change-approved` x `change-proposal` -> `completion-record` |

`gazette` is an unscoped periodical methodology. Its manifest declares eight
artifact types: `brief`, `beat`, `dispatch`, `lineup`, `draft`, `grounding`,
`issue`, and `ledger` [`gazette:manifest.toml@80d167ac`]. Its protocol graph
is:

| Protocol | Signature surface |
| --- | --- |
| `survey` | `brief`, accepting `ledger` -> `beat` |
| `report` | `beat` -> `dispatch` |
| `edit` | `beat` x `dispatch` -> `lineup` |
| `write` | `lineup` x `dispatch` -> `draft` |
| `factcheck` | `draft` x `dispatch` -> `grounding` |
| `publish` | `draft` x `grounding` x `lineup` x `beat` -> `issue` x `ledger` |

`commons` owns several cross-component contracts and schemas. They are
important substrate authority, but most are not themselves runa methodology
artifact types unless a methodology vendors or declares them. `REQUEST.md` and
`schemas/request/v1/` are the canonical request artifact contract; the forge
capability contract and schema define provider-neutral work-unit/change
operations; the ecosystem release manifest schema defines release records
[`commons:SOURCE-OF-TRUTH.md@ab9b9d3`,
`commons:schemas/@ab9b9d3`].

`agent-protocols` does not add a runa artifact type. It defines a protocol
document standard and a Tesserine binding. The binding maps artifact to
methodology artifact type plus JSON Schema, precondition to `requires` and
`accepts`, postcondition to `produces` plus schema validation, disposition to
`required_output_choices`, and inter-protocol graph to the graph computed by
`runa`. It also records a transitional authority inversion: the manifest is
currently authoritative for inter-protocol declarations, while the target is
to generate manifest declarations from canonical protocol documents
[`agent-protocols:bindings/tesserine.md@b31d6db`].

No `agentd` artifact/protocol declaration surface was found in the audited
substrate. `agentd` is therefore excluded except as a downstream runtime/host
consumer named by the source-of-truth map
[`commons:SOURCE-OF-TRUTH.md@ab9b9d3`].

## Categorial Vocabulary

### Objects

The draft's "objects = artifact types" maps cleanly to the runa substrate at
the methodology boundary. Artifact type names are declared in a manifest and
their inhabitants are JSON files validated against the corresponding schema
[`runa:docs/interface-contract.md@beb996ced4`]. `groundwork` and `gazette`
both inhabit this model directly through their manifests.

The boundary is methodology-relative. `survey` and artifact names are not
global concepts across all methodologies; `groundwork`'s `survey` consumes
`request`, while `gazette`'s `survey` consumes `brief`. The methodology is
the signature boundary that gives those names meaning. The vocabulary fits if
"object" means "artifact type in a loaded methodology signature," not "global
ecosystem type."

### Morphisms

The draft's "morphisms = protocols" also fits, with operational qualifiers.
A protocol declaration names required inputs, optional inputs, required
outputs, optional outputs, output choices, trigger conditions, and scope
[`runa:docs/interface-contract.md@beb996ced4`]. The graph is not authored as
a sequence; `runa` computes it from artifact relationships.

The qualifiers matter. These are partial, stateful morphisms over a validated
workspace, not total pure functions. A protocol may have optional accepted
inputs, optional outputs, trigger freshness behavior, scoped work-unit
partitioning, and forge side effects outside the artifact graph. `review` is
especially instructive: it has no ordinary `produces` entry, but has a
required output choice where exactly one of `change-approved` or
`change-needs-revision` must validate
[`groundwork:manifest.toml@11f0bec0`]. The categorial vocabulary should
therefore describe the substrate as a graph of typed transitions, while
preserving the runtime qualifiers that make those transitions executable.

### Composition

Composition exists as graph computation. `runa` builds dependency edges from
`requires`/`accepts` to `produces`/`may_produce`/choice members, orders ready
protocols topologically, and uses triggers plus freshness/currentness to
decide when a later protocol can run [`runa:ARCHITECTURE.md@beb996ced4`].
`groundwork`'s scoped pipeline and `gazette`'s editorial pipeline both show
this: outputs from one protocol become inputs to later protocols.

Where the metaphor breaks is algebraic law. The substrate has no explicit
identity morphism, no declared equations between protocol compositions, and no
runtime proof that two paths are equivalent. Composition is operationally
computed and enforced, not yet algebraically reasoned about.

## Composition Primitives

### Products

Products are present in two forms. At the protocol level, multiple required
inputs behave like products: `implement` requires `behavior-contract` x
`implementation-plan`; `publish` requires `draft` x `grounding` x `lineup` x
`beat` [`groundwork:manifest.toml@11f0bec0`,
`gazette:manifest.toml@80d167ac`]. At the artifact-content level, JSON Schema
objects with required fields are product-like structures.

This is a practical product shape, not a first-class product type in the
runtime. `runa` enforces the presence and schema validity of each required
artifact, but it does not name `(A x B)` as a constructed type or carry a
product witness through the graph.

### Sums

Sums are present more sharply. `required_output_choices` model mutually
exclusive protocol outcomes: `review` must yield exactly one of
`change-approved` or `change-needs-revision`
[`groundwork:manifest.toml@11f0bec0`,
`runa:docs/interface-contract.md@beb996ced4`]. JSON Schemas also contain
content-level sums, such as `behavior_form` being `scenario` or `gate`, and
Gazette enums such as `development` or `archive_gap`
[`groundwork:schemas/behavior-contract.schema.json@11f0bec0`,
`gazette:schemas/dispatch.schema.json@80d167ac`].

The runtime-enforced sum is the output choice. Schema enums are validated
content distinctions, but `runa` does not route on every enum as a type-level
sum unless the distinction is represented as an artifact type or required
output choice.

### Subtyping and Refinement

Refinement exists as schema validation. An artifact inhabits its artifact type
only if its JSON instance satisfies that type's schema
[`runa:docs/interface-contract.md@beb996ced4`]. Several schemas add
predicate-like constraints: required fields, enums, conditional gate/scenario
forms, and review outcome finding constraints
[`groundwork:schemas/*.schema.json@11f0bec0`].

Subtyping is not a runtime concept today. `change-approved` and
`change-needs-revision` share review-outcome structure, but the runtime sees
two artifact types, not subtypes of a declared `review-outcome`. A valid
`behavior-contract` with `behavior_form = "gate"` is a schema-valid member of
`behavior-contract`, not a runtime subtype named `gate-contract`. The substrate
therefore has refinement predicates in the validation sense, but not
polymorphic subtyping in the draft's stronger sense.

### Recursion

Recursion is weak in the runa artifact-type layer. `groundwork` records
work-unit dependencies as string references, and its submit/review path can
loop through `change-needs-revision`, but those are graph/reference
structures, not recursive artifact types
[`groundwork:schemas/work-unit.schema.json@11f0bec0`,
`groundwork:manifest.toml@11f0bec0`]. `gazette` carries continuity through
`ledger` and inherited/open threads across issues, but again as content and
workflow continuity, not a recursive type constructor
[`gazette:schemas/ledger.schema.json@80d167ac`].

`agent-protocols` has an explicitly recursive schema for protocol steps:
`step` is a `oneOf` between a leaf step and a composite step, and composite
steps contain nested steps
[`agent-protocols:schemas/protocol.schema.json@b31d6db`]. That proves
recursive structure exists in the broader Tesserine protocol-document
substrate, but not as a first-class runa methodology artifact-type operation.

### Parameterization

Parameterization is mostly outside the current runtime substrate. Scoping by
`work_unit` partitions artifacts for delegated work; `gazette` uses `issue_id`
and `publication_target`; schemas use ordinary fields to carry domain values
[`runa:docs/interface-contract.md@beb996ced4`,
`gazette:schemas/brief.schema.json@80d167ac`]. These are parameters in the
data sense, not type parameters such as `Hypothesis[MedicalDomain]`.

Methodologies themselves are the closest current analog: the same runtime
interface loads different signatures (`groundwork`, `gazette`). The audit
does not find a type-level generic artifact mechanism inside runa.

## Threshold Analysis

### Classification Typing Holds

Current Tesserine clearly has classification typing. Artifact type plus schema
classifies content; protocol declarations classify which artifact types a
protocol consumes and produces; triggers and graph computation select work
from those classifications. `runa` validates artifacts before treating them as
available inputs and refuses protocol completion when declared outputs are
missing or invalid [`runa:docs/interface-contract.md@beb996ced4`].

That is already enough for the draft's Layer-1 claim: Tesserine has a typed
cognitive state graph in the operational sense. The substrate reads artifacts
as typed instances and routes protocols accordingly.

### Constructor Gating Is Partial

The current substrate gates construction only on controlled production paths.
When an agent produces an artifact through `runa-mcp`, the tool schema is
derived from the artifact schema, `work_unit` is injected where applicable,
and `runa` validates before writing the artifact
[`runa:ARCHITECTURE.md@beb996ced4`]. After a live protocol run, postconditions
also require declared outputs to exist and validate.

But existence of a valid artifact file does not generally prove a particular
protocol constructed it. `runa scan` reconciles JSON files under
`.runa/workspace/{type}/{instance}.json`; external inputs such as `request` or
`brief` are intentionally seeded from outside the protocol graph, and any
valid workspace artifact can be scanned into state
[`runa:ARCHITECTURE.md@beb996ced4`]. Execution records add operational
completion evidence for runs, but that evidence is not the artifact type
itself.

So constructor gating exists as a path property of the MCP/live execution
surface, not as a universal type-inhabitation property. This is one threshold
transition, and Tesserine has not crossed it globally.

### Refinement Predicates Exist, But Not As Subtype Witnesses

JSON Schema predicates are real and enforced. They can distinguish gate-form
from scenario-form contracts, require every Gazette candidate to carry a source
trail, and reject invalid review dispositions
[`groundwork:schemas/behavior-contract.schema.json@11f0bec0`,
`gazette:schemas/dispatch.schema.json@80d167ac`].

However, those predicates classify artifact content. They do not by
themselves make the typed value evidence that a specific protocol ran, nor do
they establish subtype relationships between artifact types. This transition
is separable from constructor gating: Tesserine has many refinement predicates
without full constructor evidence.

### Provenance Carrying Is Local And Content-Level

The substrate carries several provenance-like facts. `work-unit` contains an
opaque forge handle; `change-proposal` records branch, commit, base, version,
and handle; the runa store records content hashes, schema hashes, timestamps,
and execution-record snapshots; Gazette artifacts carry source trails and
grounding verdicts
[`groundwork:schemas/work-unit.schema.json@11f0bec0`,
`groundwork:schemas/change-proposal.schema.json@11f0bec0`,
`runa:ARCHITECTURE.md@beb996ced4`,
`gazette:schemas/grounding.schema.json@80d167ac`].

Those facts matter, but most are content or store metadata, not type identity.
The type `grounding` does not become `grounding[via factcheck, with dispatch
D]`; the runtime validates the `grounding` artifact and later protocols can
consume it, but the construction history is not encoded as the type. Provenance
carrying is therefore another separable transition, not automatically bundled
with refinement.

### Evidence-Preserving Composition Is Not General Yet

Some evidence survives local transitions. A required output choice preserves
which branch review took; a `completion-evidence` artifact records criterion
coverage; Gazette's `grounding` and `issue` schemas require claim verdicts and
exclude unsupported published grounding by schema/content contract
[`groundwork:schemas/completion-evidence.schema.json@11f0bec0`,
`gazette:schemas/issue.schema.json@80d167ac`].

The runtime does not yet have a general rule that a product of
evidence-bearing types carries both witnesses, or that a sum carries the
selected witness as a type-level fact. Evidence preservation is implemented
case by case in artifact content, output choices, and execution metadata.

## Finding

The draft's threshold framing should be retained as approach, with one
important sharpening for synthesis:

1. **The classification-vs-evidential distinction holds.** Current runa
   dispatch and enforcement classify artifacts by type and schema. It can
   trust that a value is schema-valid for a type. It cannot generally infer
   from the value's type alone that a specific protocol constructed it.
2. **The threshold is a cluster.** Constructor gating, refinement predicates,
   provenance carrying, and evidence-preserving composition separate in the
   actual substrate. Tesserine has refinement predicates now; it has partial
   constructor gating on controlled MCP/live paths; it carries provenance in
   content and store metadata; it preserves evidence in local artifacts and
   output choices. None of those local mechanisms is yet a unified evidential
   type system.
3. **Layer 1 is real but operational.** Tesserine forms a small-category-like
   graph of artifact types and protocol declarations, but the implementation
   is an evented runtime over validated workspace state. Any synthesis should
   keep the operational qualifiers instead of smoothing them into pure
   category theory.
4. **Layer 2 work should be decomposed by transition.** If the project pursues
   evidential typing, it should not assume one upgrade crosses the threshold.
   The implementation questions are at least: how values become constructor
   gated, how refinements become named inhabitation facts, how provenance
   becomes part of type identity or a consulted authority, and how composition
   preserves those witnesses.
5. **The agent-protocols binding is relevant evidence.** It shows the same
   single-home pressure at the protocol-declaration layer: the target is to
   generate manifest declarations from canonical protocol documents, but the
   current substrate still treats the manifest as authority. This is not
   evidential typing, but it is a concrete instance of the move from
   hand-maintained classification surfaces toward generated, checkable
   witnesses.

## Verification Notes

This document satisfies the `#86` acceptance criteria as follows:

- It exists at `concepts/_supporting/01-artifact-protocol-audit.md` and states
  its Wave-1 supporting status.
- It maps actual `runa`, `groundwork`, `gazette`, `commons`, and
  `agent-protocols` surfaces to objects, morphisms, products, sums,
  refinement, recursion, and parameterization.
- It reports a grounded threshold verdict: the distinction holds, and the
  threshold is a cluster of separable transitions.
- Every structural claim names a repo, path family, and commit from the
  evidence table.
- It does not promote the draft, write an ADR, or make downstream commitments.

