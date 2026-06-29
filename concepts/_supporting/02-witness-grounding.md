# Layer-2 Witness Grounding for the Cognitive State Machine Draft

**Status:** Wave-1 supporting finding for
[`tesserine/commons#16`](https://github.com/tesserine/commons/issues/16),
produced by
[`tesserine/commons#88`](https://github.com/tesserine/commons/issues/88).
This document is evidence for later synthesis. It is not an ADR, does not
promote the draft, and commits Tesserine to no project direction on its own.

**Question answered:** for which separable Layer-2 transitions does
evidence-bearing typing carry concrete operational value in the current
Tesserine substrate, and where does that evidence sharpen the draft's framing?

**Verdict:** Layer 2 has operational value, but not as one monolithic upgrade.
Constructor gating and provenance-as-identity have the clearest current return:
they address real places where valid artifacts and recorded provenance are not
the same as type-level evidence of production. Refinement-as-inhabitation and
evidence-preserving composition also matter, but the current substrate already
closes many candidate gaps more cheaply through JSON Schema predicates,
required output choices, execution records, and artifact content contracts. The
finding for synthesis is therefore targeted: treat Layer 2 as a set of
separable substrate enrichments whose value must be justified per transition.

## Evidence Base

The grounding uses current local substrate state, pinned so later readers can
inspect the same surfaces.

| Repo | Commit | Ground used |
| --- | --- | --- |
| `commons` | `09961fd686744e6b28bc7c955d3e265717cdf815` | `concepts/_drafts/cognitive-state-machine.md`, `concepts/_supporting/01-artifact-protocol-audit.md`, `concepts/README.md`, `SOURCE-OF-TRUTH.md`, `FORGE-CAPABILITY.md`, `adr/0017-forge-work-unit-identity-model.md` |
| `runa` | `7e0c2170eeb554f51f3d7fc1e99cca26082acde1` | `docs/interface-contract.md`, `docs/session-surface-contract.md`, `ARCHITECTURE.md`, `libagent/src/{store,session,enforcement,selection,context}.rs`, `runa-mcp/src/handler.rs` |
| `groundwork` | `11f0bec0f081f03b660e2084999b55cc09edb9d2` | `manifest.toml`, `schemas/{behavior-contract,implementation-plan,test-evidence,completion-evidence,change-proposal,change-approved,change-needs-revision,work-unit}.schema.json`, scoped protocol declarations |
| `gazette` | `80d167ac826acad143399b71edf273933cf4ce37` | `manifest.toml`, `schemas/{dispatch,draft,grounding,issue,ledger}.schema.json`, editorial protocol declarations |
| `agent-protocols` | `b31d6dbd95fa573f0d787ab99e719fca9794239d` | `bindings/tesserine.md`, `schemas/protocol.schema.json` |

## Audit Cluster Recap

The prior audit found that Tesserine already has classification typing:
artifact types plus schemas classify content, protocol declarations classify
which types each protocol consumes and produces, and runa routes work over that
validated graph. The same audit found that the draft's threshold is not one
switch. It separates into constructor gating, refinement predicates,
provenance carrying, and evidence-preserving composition
[`commons:concepts/_supporting/01-artifact-protocol-audit.md@09961fd686744e6b28bc7c955d3e265717cdf815`].

The CSM draft calls Layer 2 the substrate work by which existence of a typed
value becomes sound evidence about production: only named constructors produce
the type, structural predicates govern inhabitation, provenance can become part
of type identity, and composition preserves the resulting witnesses
[`commons:concepts/_drafts/cognitive-state-machine.md@09961fd686744e6b28bc7c955d3e265717cdf815`].
This document tests that framing against actual operational cases.

## Constructor Gating

**Operational value:** high, for artifacts whose downstream consumers treat
existence as completion evidence.

Current runa validates artifacts when they are produced through the MCP output
tool and enforces declared postconditions before a session advances. The output
tool schema is derived from the artifact schema, `work_unit` is injected for
scoped work, and postconditions require declared outputs or exactly one
required output choice member to exist and validate
[`runa:runa-mcp/src/handler.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/enforcement.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/session.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
That is real constructor discipline for the live production path.

The current substrate does not make that discipline a universal inhabitation
rule. `runa scan` reconciles JSON files under `.runa/workspace/{type}/` into
the store, and readiness uses valid artifacts from that store. A valid
workspace artifact can therefore become an input even when its file was not
produced by the protocol that conventionally constructs that type
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:docs/interface-contract.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/store.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/selection.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].

The admitted failure is concrete in groundwork. `verify` requires
`test-evidence`, `submit` requires `completion-evidence`, and `land` requires
`change-approved`; their triggers are artifact-presence triggers over those
types. A schema-valid instance of one of those types is enough to participate
in readiness even if the runtime has no type-level proof that `implement`,
`verify`, or `review` produced it
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/test-evidence.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/completion-evidence.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-approved.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
Constructor gating would prevent the false inference "a valid
`test-evidence` exists, therefore the `implement` protocol ran" unless the
runtime can attach that construction witness.

Gazette has the same shape. `publish` requires `draft`, `grounding`, `lineup`,
and `beat`, and `factcheck` produces `grounding`. A valid `grounding` artifact
contains claim verdicts and an unsupported count, but the type itself does not
prove it was constructed by the `factcheck` protocol over the paired `draft`
and `dispatch`
[`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/grounding.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
Constructor-gated inhabitation of `grounding` would let `publish` rely on the
artifact type as evidence that the factcheck transition occurred, not merely
that a valid verdict-shaped file is present.

The cheaper mechanism that already exists is execution recording. runa records
freshness-relevant input snapshots per `(protocol, work_unit)` and uses those
records to suppress reruns only when the current input set matches
[`runa:docs/interface-contract.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/store.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/selection.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
That closes freshness, not constructor identity. The operational case for
Layer-2 constructor gating is therefore narrow but real: make production
evidence part of artifact inhabitation for artifact types that downstream
protocols treat as completed work.

## Refinement-as-Inhabitation

**Operational value:** mixed. Many candidate refinements are already served by
schema predicates; named inhabitation facts would matter only where protocols
need to route or rely on the refined fact as a type-level input.

The current substrate has strong refinement predicates. `behavior-contract`
uses `behavior_form` to require either scenarios or gates, but not both;
`implementation-plan` and `test-evidence` carry matching scenario-form or
gate-form mappings; review outcomes distinguish approval from revision through
separate artifact types and schema predicates about blocking findings
[`groundwork:schemas/behavior-contract.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/implementation-plan.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/test-evidence.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-approved.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-needs-revision.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].

For those cases, Layer-2 refinement does not buy the first line of defense.
The failure "a gate contract also contains scenarios" is already prevented by
JSON Schema. The failure "a revision disposition has no blocking finding" is
already prevented by the `change-needs-revision` schema, and the routing
between approval and revision is already expressed as a required output choice
in the `review` protocol
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-needs-revision.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
These are cheaper mechanisms than introducing a named subtype solely to
repeat a validation predicate.

The operational capability a stronger refinement layer would enable is
different: protocols could declare dependencies on named refinements rather
than on one broad artifact type plus content inspection. For example, if a
future protocol must consume only gate-form contracts, `behavior-contract`
currently gives it a valid artifact whose form must be inspected from content;
there is no artifact type such as `gate-behavior-contract` or inhabitation fact
the runtime can route on
[`runa:docs/interface-contract.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`groundwork:schemas/behavior-contract.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
No current protocol in the inspected substrate needs that routing. The finding
is therefore no-current-warrant for broad refinement machinery, with a reserved
case for future protocols that need refined predicates as dispatchable input
facts.

Gazette reinforces that caution. `dispatch`, `draft`, `grounding`, and `issue`
schemas already require source trails, claim confidence, grounding verdicts,
and published issue constraints that exclude unsupported claims
[`gazette:schemas/dispatch.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/draft.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/grounding.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/issue.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
Layer-2 refinement would add value only where those content predicates need to
become named, reusable type-level evidence instead of local schema checks.

## Provenance-as-Identity

**Operational value:** high, where a consumer needs to know not only that an
artifact is valid, but which scope, input set, proposal version, or forge unit
the artifact is bound to.

Tesserine already carries substantial provenance, but mostly as content or
store metadata. A `work-unit` has an opaque connector-issued handle whose `id`
must be complete and scoped; the forge capability requires connectors to
validate handle scope before effects; ADR-0017 makes that identity contract
provider-agnostic
[`commons:FORGE-CAPABILITY.md@09961fd686744e6b28bc7c955d3e265717cdf815`;
`commons:adr/0017-forge-work-unit-identity-model.md@09961fd686744e6b28bc7c955d3e265717cdf815`;
`groundwork:schemas/work-unit.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
That is a real scoped identity mechanism, but it is not a type identity such as
`work-unit[tesserine/commons#88]`; it is artifact content plus connector
validation.

`change-proposal` also carries concrete provenance: branch, commit, base,
review-round version, and a connector-issued handle. Review artifacts carry
`against_version`, and runa scopes readiness and context by `work_unit`
[`groundwork:schemas/change-proposal.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-approved.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`groundwork:schemas/change-needs-revision.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`runa:libagent/src/context.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/selection.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
The runtime can compare scope and validate content, but downstream consumers
must still inspect fields to know which commit or review round a proposal or
approval describes.

runa's store records content hashes, schema hashes, modification timestamps,
optional work-unit extraction, and execution-record input snapshots
[`runa:libagent/src/store.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
Those facts are strong local provenance for freshness and audit. The admitted
gap is that they are not consulted as type identity by consumers: the type
`completion-evidence` does not say "completion evidence for behavior contract
hash H, test evidence hash T, and work unit W." A reader or protocol can
recover that relation by inspecting records and fields, not by asking the type.

The operational capability enabled by provenance-as-identity is therefore a
sound join between typed artifact existence and the exact production context.
For groundwork, it would let review and land distinguish "approval for this
proposal version and commit" as an identity-level fact instead of a content
predicate. For Gazette, it would let `issue` be identified as publication of
the particular `draft` plus `grounding` plus `lineup` set, rather than as an
issue artifact whose content carries traces to those inputs
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/issue.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
This is not a replacement for existing hashes and handles. It is a higher
level use of them: making the identity of the typed value include the
provenance that is currently adjacent to it.

## Evidence-Preserving Composition

**Operational value:** targeted. The substrate has local composition evidence,
but no general rule that products and sums preserve witnesses.

Products appear as multiple required inputs. `implement` requires
`behavior-contract` and `implementation-plan`; `verify` requires
`behavior-contract`, `test-evidence`, and `work-unit`; Gazette `publish`
requires `draft`, `grounding`, `lineup`, and `beat`
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`].
runa can enforce that those inputs exist and validate, and its execution
records can preserve the input snapshot used for freshness
[`runa:libagent/src/enforcement.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/store.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
That is operationally useful, but it does not construct a first-class product
witness saying the output preserves each input's production evidence.

Sums appear most clearly as required output choices. Groundwork `review`
requires exactly one of `change-approved` or `change-needs-revision`, and runa
postconditions reject zero or multiple members
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`runa:docs/interface-contract.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
`runa:libagent/src/enforcement.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
For this case, the current cheaper mechanism is strong: the selected branch is
preserved as the produced artifact type. A general sum-witness mechanism would
not obviously buy much more for review unless downstream protocols need to
carry the selected branch together with its constructor and provenance as one
identity.

Gazette shows the positive and negative sides. `publish` composes `draft` and
`grounding` into `issue` and `ledger`; `issue` content preserves candidate
ids, coverage accounting, qualified claims, archive gaps, and a ban on
unsupported published grounding
[`gazette:schemas/draft.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/grounding.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/issue.schema.json@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/ledger.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
That content preserves enough evidence for a reader and for current workflow
checks. It does not prove, as a general algebraic fact, that all witnesses in
the input product survive into the output product.

The `agent-protocols` binding points toward where composition evidence may
become valuable. It treats the manifest as the current runtime-facing authority
for declarations while declaring a target where manifest declarations are
generated projections from canonical protocol documents and checked for
convergence
[`agent-protocols:bindings/tesserine.md@b31d6dbd95fa573f0d787ab99e719fca9794239d`;
`agent-protocols:schemas/protocol.schema.json@b31d6dbd95fa573f0d787ab99e719fca9794239d`].
That is a concrete composition problem: a protocol document, its manifest
projection, and its runtime behavior should preserve the same contract. The
current binding handles this as validation and projection discipline, not as
Layer-2 type algebra. The synthesis should keep that cheaper path in view
unless a real cross-methodology composition case needs stronger witnesses.

## Findings for Synthesis

1. **Layer 2 should remain decomposed by transition.** Constructor gating,
   refinement-as-inhabitation, provenance-as-identity, and
   evidence-preserving composition do not have equal current value
   [`commons:concepts/_supporting/01-artifact-protocol-audit.md@09961fd686744e6b28bc7c955d3e265717cdf815`].
2. **Constructor gating has a real admitted failure.** Valid workspace
   artifacts can participate in readiness without type-level proof that the
   declared producer protocol constructed them
   [`runa:docs/interface-contract.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
   `groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
3. **Refinement is not the first place to spend machinery.** JSON Schema
   conditionals, enums, separate artifact types, and required output choices
   already prevent many refinement failures; named refinements become valuable
   only when a protocol must dispatch on the refined fact
   [`groundwork:schemas/behavior-contract.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
   `groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
4. **Provenance-as-identity is promising because provenance already exists.**
   Forge handles, proposal commit/version fields, store hashes, and execution
   records are concrete material that could be lifted from content or metadata
   into identity-level evidence
   [`commons:FORGE-CAPABILITY.md@09961fd686744e6b28bc7c955d3e265717cdf815`;
   `runa:libagent/src/store.rs@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`;
   `groundwork:schemas/change-proposal.schema.json@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
5. **Evidence-preserving composition is a later, sharper question.** Current
   products and sums have local enforcement and content evidence; a general
   witness algebra should wait for a case where those local mechanisms are
   insufficient
   [`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`;
   `agent-protocols:bindings/tesserine.md@b31d6dbd95fa573f0d787ab99e719fca9794239d`].

## Verification Notes

This document satisfies the `#88` acceptance criteria as follows:

- It exists at `concepts/_supporting/02-witness-grounding.md`, states its
  Wave-1 supporting status, links `#16` and `#88`, states the question, gives a
  verdict, restates the audit cluster, and records the evidence base.
- It grounds Layer 2 per audit transition: constructor gating,
  refinement-as-inhabitation, provenance-as-identity, and
  evidence-preserving composition.
- Every operational case cites the repo, path, and full commit for the
  artifact type, protocol signature, runtime behavior, store mechanism, forge
  mechanism, or binding surface that warrants it.
- It reports how the evidence sharpens the draft: constructor and provenance
  have the clearest current value; refinement and composition often have
  cheaper existing mechanisms.
- It preserves status as a supporting finding for synthesis, not committed
  direction, and does not alter the draft, concepts index, source-of-truth map,
  ADRs, or downstream repositories.
