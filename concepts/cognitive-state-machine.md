# Cognitive State Machine

**Status:** Ratified conceptual foundation for Tesserine.

**Authority:** This document is the canonical home of the Tesserine
cognitive-state-machine concept. It ratifies a grounded conceptual foundation
and trajectory; it is not an ADR, does not create a roadmap commitment, and
does not by itself direct any project to implement Layer-2 or Layer-3
machinery.

**Audience:** Tesserine contributors, maintainers, and agents orienting on the
ecosystem's cognitive substrate.

## What Is Ratified

Tesserine's cognitive state is carried by artifacts. An artifact is
cognitive content in a typed, durable form. The artifact's type classifies the
kind of cognitive content it carries, and a protocol is a declared
transformation between artifact types.

The ratified claim is deliberately grounded: Tesserine already has an
operational typed cognitive-state graph. `runa` loads a methodology signature,
validates artifacts against methodology-owned schemas, computes a graph from
declared artifact relationships, and routes protocols over that graph. That is
real Layer-1 typed structure, but it is an evented runtime over validated
workspace state, not a pure algebraic type system.

The April 2026 draft was right to identify a trajectory from classification
typing toward evidential typing, but the Wave-1 findings sharpened the claim.
The threshold is not one switch. It is a cluster of separable transitions:
constructor gating, refinement-as-inhabitation, provenance-as-identity, and
evidence-preserving composition. Current Tesserine has partial local forms of
those mechanisms, not a unified evidential type substrate.

## Evidence Base

This ratification synthesizes the three landed Wave-1 findings for
`tesserine/commons#16`:

| Finding | Work unit | Result carried into this foundation |
| --- | --- | --- |
| Artifact and protocol audit | `tesserine/commons#86` | Layer 1 is a runtime graph of validated artifact types and protocol edges; the categorial vocabulary fits only with operational qualifiers; the threshold is a cluster, not one transition. |
| Layer-2 witness grounding | `tesserine/commons#88` | Constructor gating and provenance-as-identity have the clearest current operational value; refinement and composition often have cheaper existing mechanisms and should be justified per case. |
| Layer-3 operational grounding | `tesserine/commons#90` | Layer 3 is not currently operational; `runa` loads one methodology graph and has no multi-manifest composition, mapping-witness, functor, or natural-transformation surface. |

Those supporting documents were pre-work evidence for this synthesis. Their
history remains the traceable ground for the claims below.

## Layer 1: Operational Typed Graph

Layer 1 is present. A methodology declares artifact types, schemas, protocol
inputs and outputs, output choices, trigger conditions, and scoped or
unscoped execution. `runa` validates artifacts and computes readiness from
those declarations.

The category-theory vocabulary is useful if it preserves the runtime
qualifiers:

- **Objects** are artifact types inside a loaded methodology signature, not
  global ecosystem types.
- **Morphisms** are protocol declarations, but they are partial, stateful
  runtime transitions over a workspace, not total pure functions.
- **Composition** is computed operationally by graph edges and readiness, not
  by declared algebraic laws.
- **Products and sums** appear through required input sets, JSON Schema
  objects, and required output choices, but they are not first-class runtime
  type constructors.
- **Refinement** exists through schema validation, not through runtime
  subtype witnesses.
- **Recursion and parameterization** exist only in local content or adjacent
  standards, not as general runa artifact-type operations.

The practical consequence is important: Tesserine can soundly say an artifact
is valid for a declared type. It cannot generally infer from that type alone
that a specific protocol constructed the artifact.

## The Threshold Cluster

The threshold is the change from "this typed value is valid content" to
"this typed value is evidence about how it was produced." The Wave-1 findings
show four separable transitions.

**Constructor gating.** A value inhabits a type only through named producer
protocols. Tesserine has this discipline on the controlled live MCP path, but
valid workspace artifacts can also be scanned into the store. Existence of a
valid `test-evidence`, `completion-evidence`, `change-approved`, or Gazette
`grounding` artifact does not globally prove the conventional producing
protocol ran.

**Refinement-as-inhabitation.** A value inhabits a refined type because it
satisfies a named predicate the runtime can route on. Tesserine already has
strong JSON Schema predicates, conditional schemas, enums, and required output
choices. Named refinements become valuable only when a protocol must consume
the refined fact as a dispatchable input rather than inspect broad artifact
content.

**Provenance-as-identity.** A value's identity includes the scope, inputs,
producer, version, or external handle that make it the specific value it is.
Tesserine already carries useful provenance in forge handles, proposal fields,
store hashes, timestamps, and execution records. Those facts are content or
metadata today; they are not generally part of type identity.

**Evidence-preserving composition.** Products and sums preserve the witnesses
of their members. Tesserine preserves evidence locally through output choices,
artifact content, and execution snapshots, but has no general rule that a
product of evidence-bearing values carries both witnesses or that a sum
carries the selected witness as a type-level fact.

Layer 2, if pursued, is the substrate work that turns selected parts of this
cluster into sound inference. The findings do not justify treating Layer 2 as
one broad upgrade. Each transition must earn its place from operational value.

## Layer 2: Conditional Substrate Enrichment

Layer 2 is not a new kind of artifact or a smarter agent. It is an enrichment
of what the substrate can infer from typed artifact existence.

The grounded cases are uneven:

- Constructor gating has a real admitted failure where valid artifacts can
  participate in readiness without type-level proof of their producer.
- Provenance-as-identity is promising because scoped handles, proposal
  versions, hashes, and execution snapshots already exist as material that
  could be lifted into identity-level evidence.
- Refinement-as-inhabitation is justified only where schemas and output
  choices are insufficient because routing needs a named refined fact.
- Evidence-preserving composition is a later question unless local artifact
  content, output choices, and execution records fail a concrete case.

This foundation therefore keeps Layer 2 as trajectory, not roadmap. It names
the substrate enrichments that would make evidential typing sound and the
conditions under which they would be worth building.

## Layer 3: Not Currently Operational

Layer 3 is the higher-categorical account: methodologies as objects, with
functors, natural transformations, structural equivalence, mechanical transfer,
and synthesis between methodology signatures.

Current Tesserine does not implement that layer. `groundwork` and `gazette`
are real methodology signatures, and `runa` can load either one through the
same runtime interface. That supports manual structural comparison. It does
not provide a functor or natural transformation between them.

The current substrate has no surface for loading two methodology manifests
together, declaring mappings between artifact types or protocols, checking
equations, composing methodologies, or carrying mapping witnesses. Mechanical
improvement transfer, methodology synthesis, and cross-domain unification are
therefore contingent on absent machinery. Evidential-substrate-dependent
cognitive forms, such as paraconsistent or homotopic reasoning, remain
research direction until the relevant Layer-2 substrate exists.

The grounded near-term Layer-3 value is comparison: the manifests can show
where methodologies are structurally similar or different. That is useful, but
it is an analytical finding, not machine-checkable equivalence.

## Pre-Work Disposition

The draft's empirical pre-work is complete through the three Wave-1 findings.
The remaining draft questions are resolved by this synthesis at the level they
currently earn.

**Runtime vs. static checking.** No choice is made. The foundation names the
distinction, but no Layer-2 implementation commitment exists that would make a
runtime or static vehicle decision meaningful.

**Vehicle for Layer 2.** No vehicle is selected. The findings require any
future vehicle to justify itself per transition, especially constructor
gating and provenance-as-identity.

**Operational return.** The operational return is concrete for selected
Layer-2 transitions, weak or contingent for others, and absent for Layer 3 as
current machinery.

**In-flight alignment.** This foundation does not redirect or supersede
in-flight work. The named efforts from the draft's open questions
(`agentd#76`, `groundwork#213`) are closed, and a trajectory that commits no
implementation direction cannot override their outcomes.

**External landscape.** No cross-domain or PL-theory claim is promoted into
roadmap direction. External survey belongs to future research work only when a
specific implementation or comparative claim needs it.

**Audience.** The document serves internal contributors, maintainers, and
agents that need a stable conceptual home. It is not a marketing page and not
an implementation guide.

**Day-One alignment.** Ratification strengthens the foundation by making the
current substrate claim more honest, not larger: Layer 1 is real but
operational, Layer 2 is conditional and decomposed, and Layer 3 is research or
contingent until machinery exists.

## Governance

No ADR is derived from this ratification. The promotion contract requires ADRs
only for specific commitments. The Wave-1 findings establish no specific
commitment: Layer 2 is conditional, Layer 3 has no current operational
mechanism, and the research-direction claims remain research.

Downstream documents may cite this foundation as the canonical concept home.
They must not cite it as proof that Tesserine has evidential typing, Layer-3
composition, cross-domain unification, or a roadmap to build them. When an
implementation choice is proposed, it needs its own work unit, evidence, and
ADR if the decision is significant.
