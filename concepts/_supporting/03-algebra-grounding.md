# Layer-3 Operational Grounding for the Cognitive State Machine Draft

**Status:** Wave-1 supporting finding for
[`tesserine/commons#16`](https://github.com/tesserine/commons/issues/16),
produced by
[`tesserine/commons#90`](https://github.com/tesserine/commons/issues/90).
This document is evidence for later synthesis. It is not an ADR, does not
promote the draft, and commits Tesserine to no project direction on its own.

**Question answered:** for which named Layer-3 capabilities does a
methodology-level functor or natural transformation carry concrete operational
value in the current Tesserine substrate, which capabilities are contingent on
absent machinery, and which are research direction?

**Verdict:** Layer 3 is not currently an operational mechanism. Tesserine has
two real methodology signatures, `groundwork` and `gazette`, and the same
`runa` interface can load either signature. That supports manual structural
comparison between methodologies, but it is not a functor or natural
transformation between them. `runa` currently loads one methodology manifest
into one graph and has no methodology-composition or multi-manifest surface.
The grounded near-term value is therefore signature comparison and sharper
absence reporting. Mechanical improvement transfer, methodology synthesis, and
cross-domain unification are contingent on composition and mapping witnesses or
remain research direction. Evidential-substrate-dependent cognitive forms are
also research direction until Layer-2 evidence-bearing typing exists.

## Evidence Base

The grounding uses current local substrate state, pinned so later readers can
inspect the same surfaces.

| Repo | Commit | Ground used |
| --- | --- | --- |
| `commons` | `1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef` | `concepts/_drafts/cognitive-state-machine.md`, prior supporting findings, `concepts/README.md`, `SOURCE-OF-TRUTH.md` |
| `runa` | `7e0c2170eeb554f51f3d7fc1e99cca26082acde1` | `ARCHITECTURE.md`, especially manifest loading, graph construction, project loading, selection, and session surfaces |
| `groundwork` | `11f0bec0f081f03b660e2084999b55cc09edb9d2` | `manifest.toml`, scoped software-contribution protocol signature |
| `gazette` | `80d167ac826acad143399b71edf273933cf4ce37` | `manifest.toml`, `protocols/{factcheck,publish}/PROTOCOL.md`, `schemas/{grounding,issue}.schema.json` |
| `agent-protocols` | `b31d6dbd95fa573f0d787ab99e719fca9794239d` | `bindings/tesserine.md` only as standard-to-implementation projection evidence |

## Established Ground

The CSM draft frames a methodology as a signature: a set of artifact types,
protocol operations, type signatures, and sequencing constraints. It says
methodology composition, or multi-manifest loading, would build toward a higher
category where methodologies are objects and relations between them are
structural maps
[`commons:concepts/_drafts/cognitive-state-machine.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].
Layer 3 begins only once substrate typing carries evidence about production:
then functors and natural transformations between methodologies become
definable, and the draft lists mechanical transfer, structural equivalence,
methodology synthesis, cross-domain unification, and evidentially meaningful
cognitive forms as possible capabilities
[`commons:concepts/_drafts/cognitive-state-machine.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].

The artifact-and-protocol audit (#86) established the current lower bound.
Tesserine already has a graph of validated artifact types and protocol edges,
and methodology-as-signature is the closest current analog to the
higher-category framing. But the audit also found the graph is operational
rather than algebraic: no identity morphisms, no declared equations, no product
witness carried through the graph, and no type-level functor between
methodologies
[`commons:concepts/_supporting/01-artifact-protocol-audit.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].

The Layer-2 witness grounding (#88) established the dependency Layer 3 cannot
skip. Evidence-bearing typing has value, but as separable transitions:
constructor gating and provenance-as-identity have the clearest current return,
while refinement-as-inhabitation and evidence-preserving composition are
targeted cases often partly served by cheaper mechanisms
[`commons:concepts/_supporting/02-witness-grounding.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].
Layer 3 claims that require typed values to carry production evidence therefore
depend on Layer-2 substrate work that is not yet implemented as a general
runtime property.

## Current Layer-3 Substrate

The concrete horizontal material is small. `groundwork` declares a scoped
software-contribution methodology with 12 artifact types and the scoped
pipeline `take -> plan -> implement -> verify -> submit -> review -> land`,
with `review` producing exactly one of `change-approved` or
`change-needs-revision`
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`].
`gazette` declares an unscoped periodical methodology with eight artifact
types and the editorial pipeline `survey -> report -> edit -> write ->
factcheck -> publish`, where `publish` produces both `issue` and `ledger`
[`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`].

The runtime interface can load a methodology manifest and build a graph from
that manifest. `runa` parses one manifest into model types, resolves schemas
and instruction files relative to that manifest, builds one dependency graph
from those protocol declarations, and evaluates either unscoped protocols or
scoped protocols for one work unit
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
That is signature loading. It is not methodology composition. The architecture
does not expose a surface where two methodology manifests are loaded together,
mapped, composed, or checked against equations
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].

`agent-protocols` is not horizontal cross-methodology evidence. Its Tesserine
binding maps the Agent Protocols standard onto its reference implementation:
`runa` as runtime and `groundwork` as authored methodology. The document says
a different runtime would bind with a sibling document, and its projection
case is manifest declarations as a runtime-facing projection of canonical
protocol documents
[`agent-protocols:bindings/tesserine.md@b31d6dbd95fa573f0d787ab99e719fca9794239d`].
That is a vertical standard-to-implementation relationship. It may inform the
projection idea inside methodology-as-signature, but it is not a functor
between `groundwork` and `gazette`.

## Capability Grounding

### Mechanical Improvement Transfer

**Verdict:** contingent on absent machinery; no current mechanical transfer.

The draft claim is that an improvement in one methodology can mechanically
transfer to another through a relating functor. Against the current substrate,
the candidate methodologies are `groundwork` and `gazette`. Both have artifact
types and protocols, but they do not share a declared mapping between their
signatures. `groundwork` is scoped by work unit and carries review disposition
as a required output choice. `gazette` is unscoped, publishes a periodical
issue, and carries continuity through a singleton `ledger`
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`].

There is a visible analogy: `groundwork`'s `verify`/`submit`/`review` path and
`gazette`'s `factcheck`/`publish` path both gate downstream publication or
delivery on evidence. Gazette is especially concrete: `factcheck` produces a
`grounding` with per-claim verdicts and `unsupported_count`, while `publish`
prohibits unsupported claims and requires partially supported claims to be
qualified
[`gazette:protocols/factcheck/PROTOCOL.md@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:protocols/publish/PROTOCOL.md@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/grounding.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
But this analogy is not a transfer mechanism. There is no runtime object that
relates `completion-evidence` to `grounding`, `review` to `publish`, or
`change-approved` to a published `issue`.

The operational value, if the missing machinery existed, would be real: a
methodological improvement such as "unsupported evidence must block terminal
delivery" could be expressed once and projected across related methodology
signatures. The current substrate can only support a human finding that both
methodologies contain evidence gates. Mechanical transfer requires at least a
declared mapping between signatures, a witness that mapped obligations
preserve meaning, and a runtime or verification surface that can check the
transfer. None exists today
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].

`agent-protocols` does not fill this gap. Its manifest-projection discussion
is about canonical protocol documents and a runtime-facing manifest inside the
groundwork/runa binding, not about transferring improvements between
`groundwork` and `gazette`
[`agent-protocols:bindings/tesserine.md@b31d6dbd95fa573f0d787ab99e719fca9794239d`].

### Structural Equivalence and Non-Equivalence

**Verdict:** partially grounded as operational comparison; proof-grade
equivalence or non-equivalence is contingent.

The current substrate can support a useful structural comparison. `groundwork`
and `gazette` are not interface-equivalent as loaded signatures. They differ
in artifact sets, scope model, terminal outputs, and branch structure.
`groundwork` has a scoped work-unit pipeline and an explicit review
sum through `change-approved` or `change-needs-revision`; `gazette` has an
unscoped chronicle pipeline, terminal `issue` and `ledger` outputs, and
continuity through the ledger
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`].
That comparison has operational value: an integrator can see that a
software-contribution methodology and a periodical methodology cannot be
substituted for each other merely because `runa` can load both.

The stronger draft claim is proof: two methodologies can be proven
structurally equivalent or non-equivalent. The substrate does not yet support
that. `runa` computes dependency ordering and readiness from one manifest's
declared artifact relationships; it does not store equations between protocol
compositions, identity morphisms, type-level products, or cross-methodology
mapping witnesses
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].
So today's non-equivalence is an evidence-backed analytical finding, not a
machine-checkable theorem.

This is the most grounded Layer-3 capability because it does not first require
multi-manifest execution. A supporting document can compare two signatures
from their manifests today. But proof-grade equivalence or non-equivalence
requires a formal account of what counts as same signature, same equations,
and preserved behavior across mappings. The current runtime does not define
those terms.

### Methodology Synthesis

**Verdict:** research direction, contingent on composition machinery and a
real synthesis case.

The draft claims new methodologies can be synthesized from compositions of
existing ones. The current runtime gives no operational target for that claim.
Project loading resolves one configured methodology path, parses one manifest,
and builds one graph. Session and CLI evaluation then operate within that
loaded graph and, for scoped evaluation, one delegated work unit
[`runa:ARCHITECTURE.md@7e0c2170eeb554f51f3d7fc1e99cca26082acde1`].

There are imaginable products of synthesis. For example, one might want a
methodology that combines `groundwork`'s contribution governance with
`gazette`'s grounded publication and continuity. But no current Tesserine
surface declares how artifact types from the two signatures compose, how
conflicting protocol names are resolved, how scoped and unscoped semantics mix,
or how terminal outputs from both methodologies form a coherent new signature
[`groundwork:manifest.toml@11f0bec0f081f03b660e2084999b55cc09edb9d2`;
`gazette:manifest.toml@80d167ac826acad143399b71edf273933cf4ce37`].

The honest finding is therefore negative. Methodology synthesis may become
operationally valuable after Tesserine has multi-manifest loading, composition
rules, conflict resolution, and evidence-preserving rules for composed
protocols. Without those, it is research direction rather than roadmap.

### Cross-Domain Unification

**Verdict:** research direction; no current warrant beyond two concrete
methodology signatures.

The draft's examples name medical diagnosis, software debugging, and legal
investigation as possible instances of one higher-order cognitive type
[`commons:concepts/_drafts/cognitive-state-machine.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].
Those examples are illustrative, not grounding. The actual Tesserine substrate
contains the software-contribution methodology `groundwork` and the periodical
chronicle methodology `gazette`
[`commons:SOURCE-OF-TRUTH.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].

The two existing signatures do show one reusable shape: both methodologies
make evidence gates part of a workflow before terminal delivery. But two
examples, no declared mapping, and no composition surface are not enough to
establish a higher-order cognitive type. The current value is again manual
comparison, not unification.

The cross-domain claim becomes operational only when there are enough real
methodology signatures, with enough shared evidential structure, for a common
type to explain actual transfer or verification. Until then, cross-domain
unification should remain research direction in the CSM synthesis.

### Evidential-Substrate-Dependent Cognitive Forms

**Verdict:** research direction, dependent on Layer 2 before Layer 3 can make
it operational.

The draft names paraconsistent reasoning, homotopic reasoning, and
resolution-parameterized understanding as cognitive forms that may become
expressible if they require evidential substrate to have meaning
[`commons:concepts/_drafts/cognitive-state-machine.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].
The draft itself says this belief has not been verified.

The current substrate has evidence-bearing content and workflow obligations,
not a general evidential type substrate. Gazette's factcheck/publish pair
contains supported, partially supported, and unsupported verdicts; `publish`
knows that partially supported claims may appear only as qualified claims and
unsupported claims must not appear
[`gazette:protocols/factcheck/PROTOCOL.md@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:protocols/publish/PROTOCOL.md@80d167ac826acad143399b71edf273933cf4ce37`;
`gazette:schemas/issue.schema.json@80d167ac826acad143399b71edf273933cf4ce37`].
That is a meaningful local evidential form. But it is a protocol obligation
and artifact content shape, not a type-level substrate that can express a
paraconsistent or homotopic cognitive form across methodologies.

The Layer-2 finding matters here. Constructor gating, provenance-as-identity,
refinement-as-inhabitation, and evidence-preserving composition would need to
make evidence part of typed existence before Layer 3 could compute with
cognitive forms as mathematical substance
[`commons:concepts/_supporting/02-witness-grounding.md@1f521b7dd0b88fe7684c62be69ed8cf6f8ef29ef`].
Until then, these forms remain research direction. The operational work should
not treat them as roadmap claims.

## Findings for Synthesis

1. **Layer 3 should not be treated as currently operational.** The current
   substrate supports loading different methodology signatures through the
   same runtime interface, not functors or natural transformations between
   methodologies.

2. **The horizontal and vertical axes must stay separate.** `groundwork` and
   `gazette` are the horizontal methodology pair available for
   cross-methodology reasoning. `agent-protocols` is vertical
   standard-to-implementation projection evidence for Agent Protocols to
   Tesserine, with a manifest-projection lesson inside the `groundwork`/`runa`
   binding. It is not cross-methodology evidence.

3. **Composition absence is decisive.** Because `runa` loads one manifest and
   builds one graph, mechanical improvement transfer, methodology synthesis,
   and cross-domain unification have no current operational mechanism. Their
   value is contingent on multi-manifest loading, composition rules, mapping
   witnesses, and equations.

4. **Structural comparison is the grounded near-term value.** The manifests
   can already show operational non-equivalence between `groundwork` and
   `gazette`. That is useful for synthesis and integration, but it is not yet
   algebraic proof.

5. **Layer 3 depends on Layer 2 per capability.** Capabilities that need typed
   values to witness production, provenance, or evidence preservation cannot
   become operational until the Layer-2 transitions are implemented where they
   have justified value.

6. **Research-only capabilities should remain research-only in #16.**
   Cross-domain unification and evidential-substrate-dependent cognitive forms
   are not falsified, but the current substrate does not warrant promoting
   them into roadmap direction.

## Verification Notes

- The document exists at `concepts/_supporting/03-algebra-grounding.md` and
  identifies its Wave-1 purpose, substrate, and relationship to #16, #86, and
  #88.
- Each named Layer-3 capability receives a verdict and reasoning.
- Operational claims cite a repo, path, and commit, or explicitly name the
  absent substrate they depend on.
- The document reports that methodology composition does not exist in `runa`
  today and explains the implication for reachability.
- The findings sharpen the draft's Layer-3 framing by separating horizontal
  methodology relations from vertical standard projection, naming Layer-2 and
  composition dependencies, and preserving research-only claims as research.
- The status remains a supporting finding only; this document does not ratify
  the CSM draft, alter `SOURCE-OF-TRUTH.md`, update the concepts index, or
  commit Tesserine to a roadmap.
