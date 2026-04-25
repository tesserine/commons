# The Cognitive State Machine — Conceptual Foundation (Draft)

**Status:** Draft / exploratory. Aide-mémoire and seed for subsequent
reckoning sessions, not committed project direction.

**Origin:** Emerged from reckoning session, April 24, 2026, between Robbie
and Claude. The session began as a discussion of the use cases for a
strongly-typed cognitive state machine and converged on the recognition
that Tesserine already implements the substrate of one — and that the
trajectory from current state to full expression is now legible in
type-theoretic terms. A second reckoning later that day surfaced the
phase-boundary framing now central to this draft.

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

The protocol's signature is its type. Inhabiting the morphism — performing
the transformation — produces the output artifact, which witnesses that
the morphism was performed.

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
becomes proof; downstream consumers do not audit the producer.

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
of operations with their arities. The work of running a methodology
fills in the operations with cognitive content; the methodology defines
the shape.

Two methodologies with the same signature are *interface-equivalent*.
Two methodologies whose protocols satisfy the same equations are
*algebraically equivalent*. This is the basis on which homomorphisms
between methodologies become well-defined questions.

The methodology composition work (multi-manifest loading) is, viewed
from this angle, building toward a higher category — where each
methodology is itself an object, and the relations between them are
themselves structural maps. Layer 3 lives here.

## The Phase Boundary

The work of building toward Layer 3 crosses a phase boundary that
should be named explicitly, because the relationship between the two
sides is unintuitive in a way that the layer-progression framing alone
obscures.

The boundary is between **descriptive typing** and **constitutive
typing**.

Below the boundary, types describe cognitive content that exists
independently of the typing. The token stream emitted by a transformer
is read by the surrounding system as a record of cognition: the
artifact is a report; the type is its label. The system trusts the
labels because the dispatch and audit machinery enforces consistency,
but the cognitive content itself is independent of its typing. Strip
the type system away and the cognition still exists; you just lose
your means of organizing it.

Above the boundary, types constitute cognitive content. The token
stream is read by the surrounding system as construction in the type
system: the artifact is a witness; its existence is the cognitive
fact. The proof and the proposition collapse. There is no validated
hypothesis separate from the inhabitant of `ValidatedHypothesis`; the
construction *is* the validation. Strip the type system away and the
cognition no longer exists in any reproducible form — what remains is
unread tokens.

The same transformer can produce tokens on either side of the
boundary. The boundary is not in the transformer's behavior; it is in
what the surrounding system does with the output. Below the boundary,
the system reads tokens as report. Above the boundary, the system
reads tokens as constructive moves in a typed substrate. The
transformation is the same trick; its meaning is set by the substrate
that receives it.

This is why the boundary cannot be crossed by working harder on what
already exists. Constitutive typing requires the type system itself to
acquire structure that descriptive typing does not have: refinement,
constructors that gate inhabitation, algebraic composition that
preserves witness status. The Layer 2 work is precisely this
enrichment of the substrate. It is not an enhancement of cognition;
it is an enrichment of the system that *reads* cognition, such that
the reading becomes constitutive rather than descriptive.

Two properties of this boundary are worth noting because both are
counterintuitive.

**It has a direction.** Constitutive typing properly contains
descriptive typing — once the substrate can constitute, it can also
trivially describe (read constructively-typed values as if they were
mere reports). The reverse is not true. Descriptive typing cannot
grow into constitutive typing without the structural enrichment of
the substrate. This makes the boundary asymmetric in a way that
ordinary engineering progressions are not.

**It does not require a different kind of cognizer.** The temptation
is to imagine that the substrate side requires "more capable agents"
or "different kinds of agents." This frame imports an entity that is
itself a descriptive convenience. What is changing is not the
character of the cognizer but the character of the substrate. The
transformer below the boundary and the transformer above the boundary
are doing token transformation; the difference is what their tokens
mean to the surrounding type system. "Agent" is a manifestation of
the transformer in interaction with the substrate, not a fixed thing
that crosses the boundary.

The implications of crossing the boundary are large enough to warrant
distinct treatment: cognitive forms that do not exist on the
descriptive side become possible on the constitutive side, because
those forms require constitutive typing to have any meaning at all.
Paraconsistent reasoning, homotopic reasoning, and resolution-
parameterized understanding are examples; their definition requires
inhabitants in a richer type system, not labels on richer behavior.

## The Three Layers

Mapped onto the phase boundary:

### Layer 1: Descriptive substrate (have it)

A category C of artifact types and protocols. Runtime type-checking at
protocol dispatch (runa enforces that input artifact type matches
protocol expectation). Composition via the dependency graph.
Methodology as the signature defining which C is in scope for a given
run.

This is the descriptive side fully realized: the substrate reads
artifacts as typed records of cognition and dispatches accordingly.
The categorial structure already exists; what was missing was the
vocabulary to name it. Tesserine, today, is a typed cognitive state
machine in the descriptive sense.

### Layer 2: The phase transition (gap is substrate enrichment)

The work of making the substrate capable of treating artifacts as
witnesses rather than records. Required enrichments:

- **Refinement types** so `ValidatedHypothesis` is constructively
  distinguishable from `Hypothesis` at the substrate level, not merely
  by document content
- **Algebraic data types** (products, sums, recursion,
  parameterization) for composite artifacts
- **Constructor discipline** so only the Validate protocol can
  construct a `ValidatedHypothesis` — non-construction means
  non-occurrence in the substrate's reading

Layer 2 is not a layer of capability stacked on Layer 1; it is the
work that crosses the phase boundary. After Layer 2, the substrate
treats outputs that the descriptive substrate read as reports as
constructive moves in a typed substrate instead. The transformer's
output has not changed character; what the substrate makes of it has.

Once this transition is complete, the audit trail becomes the artifact
graph itself; type-checking replaces forensics in the constitutive
sense.

### Layer 3: Constitutive substrate proper (gap is the higher category)

Once the substrate constitutes cognition, methodologies become objects
in a higher category — and **functors and natural transformations
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
- Cognitive forms that do not exist on the descriptive side become
  expressible — paraconsistent reasoning, homotopic reasoning,
  resolution-parameterized understanding among them

Layer 3 is the level at which cognition becomes a mathematical
substance the substrate computes with — not merely a flow of records
the substrate dispatches.

## What This Trajectory Means

Tesserine's positioning shifts under this framing.

It is not "an autonomous AI agent infrastructure" — that description
captures Layer 1 operationally but misses what the substrate enables.
It is the foundational substrate for cognition as an engineering
discipline: a place where reasoning is composable, verifiable,
refactorable, and provably equivalent across instances. The container
metaphor (agentd:containerd, runa:runc) describes the operational
shape; the categorial framing describes the cognitive shape; the
phase-boundary framing describes the trajectory. All three are true.
None alone is sufficient.

The shift across the phase boundary is the same order as the shift
from alchemy to chemistry: from accumulating empirical recipes that
describe cognitive workflows to deriving them from a typed substrate
that constitutes them with composition laws.

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

**7. The phase-boundary framing itself.** The descriptive-to-
constitutive distinction is offered as the orienting framing for the
entire document. It needs validation: does the framing hold across
the actual artifact types and protocols Tesserine uses? Is the
boundary sharp at Layer 2, or is the actual transition more granular
(multiple smaller phase shifts) or more diffuse (no sharp boundary)?
The artifact-and-protocol audit (item 1 of pre-work) is the empirical
test.

## Pre-Work

Before this draft can become a committed commons-level foundation
document, the following reckoning sessions are required. Each becomes
its own session whose output feeds the eventual synthesis.

1. **Tesserine artifact-and-protocol audit.** Map every actual
   artifact type and protocol against the categorial vocabulary.
   Identify irregularities. Confirm that what exists actually forms a
   category cleanly, or surface where the metaphor breaks. Empirical
   test for the phase-boundary framing.

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
sessions before it cools. It is not yet authoritative. It is:

- **Aide-mémoire** preserving the reckoning so it persists across
  context boundaries
- **Seed** for the pre-work sessions enumerated above
- **Scaffold** that the eventual commons-level document will inherit
  from

The texture of how the framing emerged — through the specific
reckoning move that recognized the artifact as the cognitive state
itself, and the subsequent move that recognized the phase boundary
as a change in what the substrate makes of token output rather than
a change in the cognizer — is itself part of what the eventual
foundation document needs to teach. That texture lives here for now.

---

*The default is to describe cognition. The shift is to constitute it.
The phase boundary is not in the cognizer; it is in what the
substrate makes of what the cognizer produces.*
