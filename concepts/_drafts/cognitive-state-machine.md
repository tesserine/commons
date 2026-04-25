# The Cognitive State Machine — Conceptual Foundation (Draft)

**Status:** Draft / exploratory. Aide-mémoire and seed for subsequent
reckoning sessions, not committed project direction.

**Origin:** Emerged from reckoning session, April 24, 2026, between Robbie
and Claude. The session began as a discussion of the use cases for a
strongly-typed cognitive state machine and converged on the recognition
that Tesserine already implements the substrate of one — and that the
trajectory from current state to full expression is now legible in
type-theoretic terms.

**Eventual home (proposed):** tesserine/commons, as a foundational
concept document. Specific commitments derive from it as ADRs.

**Status before formalization:** Pre-work required (see final section).
The conceptual basis below is sharp enough to capture; it is not yet
sharp enough to commit the project to.

---

## The Basis

The cognitive state of an agent is carried by its artifacts. An
artifact is an idea-described-in-text. The artifact **is** the
cognitive state — there is no separate "state" floating alongside the
artifact that needs to be made type-shaped. The artifact's type
classifies the kind of cognitive content it carries.

A specific Hypothesis is to the type Hypothesis exactly what the value
`42` is to the type Integer. The type tells you what kind of thing the
artifact is; the artifact is a specific inhabitant of that type.

This collapses a confusion that obscured the structure of what
Tesserine has built. The system already implements a typed cognitive
state machine in the literal mathematical sense. The typing is not
aspirational; the typing **is** what makes protocol selection coherent.

## Protocols as Morphisms

A protocol is a typed transformation between artifact types. Examples:

- `Survey: Input → Survey`
- `Decompose: Survey → Decomposition`
- `Validate: (Hypothesis × Evidence) → ValidatedHypothesis | RefutedHypothesis`

The protocol's signature is its type. The agent's work is the act of
inhabiting the morphism — performing the transformation. The output
artifact witnesses that the morphism was performed.

In category-theory terms, Tesserine forms a small category:

- **Objects:** artifact types (Hypothesis, Evidence, Plan,
  Decomposition, etc.)
- **Morphisms:** protocols
- **Composition:** sequencing of protocols, with the dependency graph
  defining valid orderings
- **Identity:** the trivial no-op (probably needs no explicit
  existence)

This is a category in the precise sense. The categorial structure
already exists in Tesserine; what was missing was the vocabulary to
name it.

## Composition Primitives

The artifact type system supports — or could support, with
enrichment — the standard algebraic operations on types. Each operation
expresses a different way artifacts can carry cognitive structure.

### Subtyping (refinement)

`ValidatedHypothesis` is a subtype of `Hypothesis`: every validated
hypothesis is a hypothesis, plus carries validation evidence.
`RefutedHypothesis` is similar, with refutation evidence.

Subtyping enables polymorphism over cognitive states. A protocol like
`Cite: Hypothesis → Citation` accepts any Hypothesis. A protocol like
`Publish: ValidatedHypothesis → Publication` accepts only validated
ones. The cognitive constraint becomes a type constraint enforced by
the runtime.

Subtyping is also how artifacts become **witnesses**. A
`ValidatedHypothesis` is not merely "a hypothesis with a `validated:
true` field." It is a value that *only the Validate protocol can
construct*. Its existence proves validation occurred. The artifact
becomes proof; downstream consumers do not audit the agent.

### Products

Artifacts that combine. `(Hypothesis × Evidence)` is a pair type
carrying both. The Validate protocol operates on this product.
Composition of artifacts into compound artifacts is a product
operation.

### Sums

Artifacts that alternate. `(ValidatedHypothesis | RefutedHypothesis)`
is a sum type — the disjoint union of two possibilities, with the type
indicating which path was taken. Outcome-bearing protocols return sums.

### Recursion

Artifacts that contain themselves. A Decomposition whose subgoals are
themselves Decompositions. Tree-structured cognitive content has this
shape.

### Parameterization

Artifacts that generalize across domains. `Hypothesis[MedicalDomain]`
vs. `Hypothesis[SoftwareBugDomain]`. Same cognitive structure, different
subject matter. Domain-portability becomes a type-level operation.

### Sufficiency

These five operations (subtyping/refinement, products, sums, recursion,
parameterization) are sufficient to express any algebraic data type.
Tesserine's artifact type system today does not speak this vocabulary
explicitly. The Layer 2 work below is, in part, making it speak this
vocabulary.

## Methodology as Signature

A methodology in Tesserine declares what artifact types exist, what
protocols exist with their type signatures, and what sequencing
constraints apply. In algebraic terms, this is a **signature**: a set
of operations with their arities. The agent's work fills in the
operations with cognitive content; the methodology defines the shape.

Two methodologies with the same signature are *interface-equivalent*.
Two methodologies whose protocols satisfy the same equations are
*algebraically equivalent*. This is the basis on which homomorphisms
between methodologies become well-defined questions.

The methodology composition work (multi-manifest loading) is, viewed
from this angle, building toward a higher category — where each
methodology is itself an object, and the relations between them are
themselves structural maps. Layer 3 lives here.

## The Three Layers

### Layer 1: The categorial substrate (have it)

A category C of artifact types and protocols. Runtime type-checking at
protocol dispatch (runa enforces that input artifact type matches
protocol expectation). Composition via the dependency graph.
Methodology as the signature defining which C is in scope for a given
run.

This is more than was previously credited. The categorial structure
already exists; what was missing was the vocabulary to name it.
Tesserine, today, is a typed cognitive state machine.

### Layer 2: Artifacts as witnesses (gap is type-system enrichment)

For artifacts to be proof witnesses rather than structural documents,
the artifact type system needs:

- **Refinement types** so ValidatedHypothesis is constructively
  distinguishable from Hypothesis at the type level, not merely by
  document content
- **Algebraic data types** (products, sums, recursion,
  parameterization) for composite artifacts
- **Constructor discipline** so only the Validate protocol can
  construct a ValidatedHypothesis — non-construction means
  non-occurrence

Once artifacts are witnesses, downstream consumers can trust the
artifact without auditing the producing agent. The audit trail
becomes the artifact graph itself; type-checking replaces forensics.

### Layer 3: Methodology algebra (gap is the higher category)

Once methodologies have well-defined signatures and the artifact type
system supports algebra, **functors and natural transformations
between methodologies become definable.** At this layer:

- An improvement in one methodology can mechanically transfer to
  another via the relating functor
- Two methodologies can be proven structurally equivalent or
  non-equivalent
- New methodologies can be synthesized from compositions of existing
  ones
- Cross-domain unification (medical diagnosis, software debugging,
  legal investigation as instances of one higher-order cognitive type)
  becomes possible

Layer 3 is the level at which cognition becomes a mathematical
substance you can compute with — not merely describe.

## What This Trajectory Means

Tesserine's positioning shifts under this framing.

It is not "an autonomous AI agent infrastructure" — that description
captures Layer 1 operationally but misses what the substrate enables.
It is the foundational substrate for cognition as an engineering
discipline: a place where reasoning is composable, verifiable,
refactorable, and provably equivalent across instances. The container
metaphor (agentd:containerd, runa:runc) describes the operational
shape; the categorial framing describes the cognitive shape. Both are
true. Neither alone is sufficient.

The shift is the same order as the shift from alchemy to chemistry:
from accumulating empirical recipes for cognitive workflows to
deriving them from a typed substrate with composition laws.

## Open Questions

These are not yet reckoned and should not be treated as decided.

**1. Runtime vs. static type-checking.** Layer 1's type-checking
happens at runtime in runa. Layer 2's witnesses could be
runtime-checked or statically-checked. These are different shapes of
work and different research bets. The choice depends on what
trade-offs matter (development speed, error-detection earliness,
tooling ecosystem) and what's available.

**2. The vehicle for Layer 2.** Is the right move to enrich the
existing artifact-type machinery in place, or for runa to grow a small
type *system* (not just type *checking*)? These are different
magnitudes of work and different invasiveness levels.

**3. Operational return on Layer 2.** What does artifact-as-witness
buy in practice? If three specific cases can be named where its
absence currently bites or its presence would enable something new,
the case is grounded. If not, Layer 2 risks being elegant theory
without operational return.

**4. Operational return on Layer 3.** Same test. What specific value
does a functor between methodologies provide — to a user, an operator,
an integrator? If speculative, Layer 3 is research direction, not
roadmap.

**5. Relation to in-flight v0.1.1 work.** Audit trail (#76), exit
codes epic, protocol coherence audit (#213) — does the typed-cognition
trajectory complement, redirect, or supersede any of them? Without
this reconciliation, the document floats apart from current execution.

**6. Day-One alignment.** Does the trajectory strengthen the
foundation, or represent gold-plating? Initial reckoning suggests
strengthening, but that deserves explicit verification rather than
assertion.

## Pre-Work

Before this draft can become a committed commons-level foundation
document, the following reckoning sessions are required. Each becomes
its own session whose output feeds the eventual Tier 2 document.

1. **Tesserine artifact-and-protocol audit.** Map every actual
   artifact type and protocol against the categorial vocabulary.
   Identify irregularities. Confirm that what exists actually forms a
   category cleanly, or surface where the metaphor breaks.

2. **Layer 2 grounding.** Identify three concrete cases where
   artifact-as-witness would prevent a real failure or enable a real
   capability. Without this, Layer 2 is theory.

3. **Layer 3 grounding.** Identify what specific value a functor or
   natural transformation provides in operational terms. Without this,
   Layer 3 is speculation.

4. **Runtime-vs-static reckoning.** Examine the trade-offs explicitly
   with criteria for resolution.

5. **In-flight work alignment.** Reconcile the trajectory with current
   v0.1.1 work. Identify which committed work is on the trajectory,
   which is orthogonal, and whether anything is in tension.

6. **Light external survey.** Comparable work in PL theory, typed
   agent architectures, cognitive frameworks. Not to copy, but to
   know context and use right vocabulary where prior art has good
   vocabulary.

7. **Audience clarification.** Who is the eventual document for?
   Internal Tesserine contributors? External developers evaluating the
   project? Future Claude/Codex instances orienting on the system?
   The document's depth and assumed background depend on the answer.

8. **Day-One alignment confirmation.** Explicit reckoning that the
   trajectory strengthens rather than constrains the foundation.

## What This Document Is For

This draft captures the conceptual breakthrough of the April 24
session before it cools. It is not yet authoritative. It is:

- **Aide-mémoire** preserving the reckoning so it persists across
  context boundaries
- **Seed** for the pre-work sessions enumerated above
- **Scaffold** that the eventual commons-level document will inherit
  from

The texture of how the categorial framing emerged — through the
specific reckoning move that recognized the artifact as the cognitive
state itself, rather than a description of it — is itself part of
what the eventual foundation document needs to teach. That texture
lives here for now.

---

*The default is to describe cognition. The discipline is to compute
with it.*
