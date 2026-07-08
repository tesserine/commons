# Design as Substrate

**Status:** Ratified conceptual foundation for Tesserine.

**Authority:** This document is the canonical home of the design-as-substrate
discipline — how a contract governs a domain whose quality is reckonable
rather than checkable. [`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md) names it
canonical; consumers cite this document as the discipline's authority and
instantiate the discipline locally (see
[Consuming This Discipline](#consuming-this-discipline)). It ratifies a
general discipline; it is not an ADR and creates no specific project
commitment.

**Audience:** Contract authors governing a quality domain; authors of design
systems and of the surfaces that consume them; reviewers discharging
reckon-gates.

## What Is Ratified

A contract can govern a domain whose quality is decided by judgment — design
is the motivating domain, coherence the motivating property — and it can do
so with the judgment mandated and recorded rather than faked as a checklist
or abandoned as vibe. The discipline is general; four claims carry it:

1. Every contract criterion is **checkable or reckonable**, and a contract
   owes each kind a different thing: a guarantee for checkable criteria; a
   mandated, principled, recorded reckoning for reckonable ones
   ([The Two Kinds of Criteria](#the-two-kinds-of-criteria)).
2. Declaring the design system as a **closed, single-homed substrate**
   converts part of coherence into a check
   ([Design as Substrate, Not Vibe](#design-as-substrate-not-vibe)).
3. A contract over a reckonable-quality domain has **three layers** —
   declared substrate, checkable floor, mandatory reckon-gate — each
   classified checkable or reckonable
   ([The Three-Layer Contract Shape](#the-three-layer-contract-shape)).
4. **Whole-properties derive top-down**: coherence is authored first, from a
   governing fact
   ([Whole-Properties Derive Top-Down](#whole-properties-derive-top-down)).

## The Two Kinds of Criteria

Every criterion in a contract is one of two kinds, and one question decides
which: **can a mechanical assay decide pass/fail without judgment?**

A **checkable** criterion is decided by a mechanical assay — a command, a
schema validation, an inspection of artifact shape. Running the assay settles
the criterion; no judgment enters. This is the form
[Verifiable Completion](https://github.com/pentaxis93/principles/blob/main/principles/verifiable-completion.md)
names directly: completion as an observable state, with the evidence deciding
the claim.

A **reckonable** criterion is decided only by judgment — a qualified reader
reckoning from principles. "These surfaces read as one designed system,"
"this document carries the discipline and not merely its vocabulary": what
decides such a criterion is a reasoned judgment, grounded in named
principles, by a reader competent to hold them.

The classification follows the deciding act, not the phrasing. A
qualitatively phrased criterion is often checkable once restated against a
declared substrate: "spacing is consistent" becomes checkable the moment a
spacing scale is declared and the criterion becomes "every spacing value is
drawn from the declared scale." The classification discipline is to push each
criterion toward checkable as far as the domain's declarable core allows —
that push is the substrate move of the next section — and to classify as
reckonable exactly what remains: the criteria where, after the push, judgment
is still the deciding act.

What a contract owes the two kinds differs, and the difference is the
discipline:

- **A contract guarantees its checkable criteria.** The contract names the
  assay; the assay runs; its pass is the criterion holding.
- **For its reckonable criteria, a contract mandates that a principled
  reckoning happens** — and never substitutes a checklist for the judgment.
  The mandate has three parts, and all three are owed:
  - a **named gate** — the reckoning is a named step with a defined place in
    the process, so whether it ran is a fact;
  - **named grounding principles** — the judgment reasons from principles the
    contract names, so two reckoners argue from the same ground and a
    reckoning can be examined for whether its principles actually governed;
  - a **recorded reckoning** — the judgment's content (what was weighed,
    against which principles, with what finding) enters the completion
    evidence as the criterion's result.

The three parts make the mandate itself observable while the quality stays
reckoned: that a named gate ran, grounded on named principles, leaving a
recorded reckoning — each is a checkable fact. What the contract guarantees
about a reckonable criterion is that the reckoning happened; the judgment
inside the reckoning is what discharges the criterion. This is how a
reckonable criterion meets Verifiable Completion honestly: the evidence is
the record of a judgment, never a mechanical stand-in for one.

**Hollow green** is a passing signal standing where a judgment was owed: a
checklist or mechanical assay presented as deciding reckonable quality. The
green is real as a check-run — something executed and passed — and empty as
evidence: what it measured is vocabulary, structure, or presence, and the
quality it stands in for was never reckoned. The authority over reckonable
quality is a principled judgment; a checklist is a model of that authority,
not a consultation of it, and a gate that models its authority can pass what
the authority rejects
([Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md),
the *consult, don't model* corollary). A contract that writes a checklist for
a reckonable criterion manufactures hollow green by construction: every
delivery that satisfies the checklist turns the criterion green, including
the deliveries the judgment would fail.

## Design as Substrate, Not Vibe

Design is the motivating domain because its quality reads as pure judgment.
Coherence — the property that a body of surfaces presents as one designed
thing — has no single assay, and a domain held entirely by judgment decays
toward vibe: criteria no two reviewers hold the same way. The substrate move
converts the domain's declarable core into checks.

The move: declare the design system — the tokens, the type scale, the
section grammar — as a **closed, single-homed substrate** that surfaces
consume. Closed: the set's members are enumerated, so whether any value
belongs to it is decidable. Single-homed: one locus is authoritative for the
set, and every surface consumes it from there
([Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md)).
The declaration is the seam between the design system and its surfaces,
declared once, built to, and verified against
([Contract-First](https://github.com/pentaxis93/principles/blob/main/compositions/contract-first.md)).

What the declaration buys is **closure as a check**: every design value a
surface uses is drawn from the declared set — every color a declared token,
every size a step of the declared scale, every section an instance of the
declared grammar — so no ad-hoc value escapes the declared set. Closure is
checkable: an assay enumerates the values a surface uses and decides
membership mechanically. The prohibition reads in its positive form — every
value used is a member of the set — which is the form an assay verifies
([Positive Form](https://github.com/pentaxis93/principles/blob/main/principles/positive-form.md)).
For the declared part of the domain, "does this look right" becomes "is this
on-substrate": pass/fail, no judgment.

Closure is the checkable part of coherence, not the whole of it. A surface
can be fully on-substrate and still fail to cohere; that remainder is
reckonable and is governed by the reckon-gate layer of the shape below. The
substrate move's yield is the honest split: the part of design quality the
declared set can carry becomes a guaranteed check, and the part it cannot
carry is mandated to judgment rather than left as vibe.

First consumers, named descriptively: the Tesserine design system
([commons#110](https://github.com/tesserine/commons/issues/110)) and the
Gazette design contract
([tesserine/gazette#14](https://github.com/tesserine/gazette/issues/14))
instantiate this discipline for Tesserine's design domain. Which vehicle
carries their tokens and which assay checks their closure are those projects'
own decisions; this document states the discipline they instantiate, not
their implementations.

## The Three-Layer Contract Shape

A contract over a reckonable-quality domain has three layers. Each layer is
classified, and the classification is the layer's obligation:

1. **Declared substrate** — *checkable.* The domain's declarable core,
   declared as a closed set with a single home, with closure as the
   criterion: everything the governed artifact uses is drawn from the set.
   This layer converts the largest declarable share of the domain's quality
   into a guarantee.
2. **Floor and negative constraints** — *checkable.* The minimums that hold
   regardless of judgment and the prohibitions that bound the space — a
   contrast floor, a minimum target size, a maximum measure — each stated as
   the positive fact its assay verifies: "every text-and-background pair
   meets the contrast floor"
   ([Positive Form](https://github.com/pentaxis93/principles/blob/main/principles/positive-form.md)).
   A constraint phrased qualitatively still belongs to this layer when
   declaring its threshold lets an assay decide it; it belongs to the layer
   below only when no declared threshold removes the judgment.
3. **Reckon-gate** — *reckonable; mandated and recorded.* The mandatory,
   principle-anchored judgment over what the first two layers cannot carry —
   for design, the coherence of the whole. It carries the full mandate of
   [The Two Kinds of Criteria](#the-two-kinds-of-criteria): named gate, named
   grounding principles, recorded reckoning.

The three layers are one contract, and each layer holds exactly what its
kind can hold: the first two are what the contract guarantees, the third is
what it mandates; the gate spends judgment on nothing an assay decides, and
no assay stands where the judgment is owed. The shape is
[Contract-First](https://github.com/pentaxis93/principles/blob/main/compositions/contract-first.md)
carried to a quality seam: the substrate and floors declare the seam's
checkable truth, and the reckon-gate declares — as a mandate — the part of
the seam's truth that is a judgment.

## Whole-Properties Derive Top-Down

Coherence is a **whole-property**: it belongs to the artifact as a whole,
and no part carries it. Parts can each be excellent, and every pair of parts
consistent, while the whole expresses nothing — a whole-property asserts a
relation of every part to one governing thing, not relations of parts to
each other.

A whole-property is **authored first, from a governing fact**. The governing
fact is a stated organizing decision — a design language, a governing
metaphor, a compositional rule — that exists before the parts. The substrate
derives from it: the tokens, the scale, and the grammar are its projections
into declarable form. The surfaces consume the substrate. The reckon-gate
judges against it: with a governing fact stated, coherence has an answerable
form — every part reads as an expression of the governing fact — and the
reckoning has ground
([Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md)).
Top-down is this derivation order: governing fact → substrate → surfaces,
with judgment anchored at the top.

Assembly runs the other direction and arrives elsewhere: locally good
choices accumulate at best into consistency — parts that do not contradict
one another — and parts that do not contradict one another can still express
nothing in common. Consistency of parts is checkable and worth having; it is
the substrate layer's business. The whole-property is a different fact, and
it exists only where a governing fact was authored for the parts to express.

The boundary with extract-from-use is exact. Extract-from-use — build the
concrete instances first, then extract the shared thing — fits **mechanics**:
where the extracted thing is a mechanism present in each instance, as with
forge operations extracted from working per-forge implementations, extraction
recovers what the instances already carry. A whole-property is present in no
instance, so the instances hold nothing to extract; deferring coherence to a
later extraction leaves the intervening surfaces built without a governing
fact, and what extraction then finds is whatever they happen to share.
Extraction generalizes what exists; a whole-property is authored from what is
needed
([Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md)).

## Consuming This Discipline

This document is the discipline's single public home;
[`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md) names it canonical. A
consumer — a design system declaring its substrate, a design contract
governing surfaces, any contract author governing a reckonable-quality
domain — consumes it in one mode: **cite this document as the discipline's
authority, and instantiate the discipline locally.** The instantiation is the
consumer's own: its own declared substrate, its own floors, its own
reckon-gates with their own named grounding principles. The discipline's
statement stays here; a consumer document carries the citation to this home
plus its local instance, and a reader of the consumer who needs the
discipline itself follows the citation
([Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md)).
That citation is what the consumer's reader can act on: the door into the
discipline fits them without the consumer restating what lives here
([Transmission](https://github.com/pentaxis93/principles/blob/main/principles/transmission.md)).

The same mode governs this document's own authorities. The universals it
reasons from live at their canonical corpus,
[pentaxis93/principles](https://github.com/pentaxis93/principles), and are
consulted here by citation:
[Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md),
[Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md),
[Positive Form](https://github.com/pentaxis93/principles/blob/main/principles/positive-form.md),
[Verifiable Completion](https://github.com/pentaxis93/principles/blob/main/principles/verifiable-completion.md),
[Transmission](https://github.com/pentaxis93/principles/blob/main/principles/transmission.md),
and the composition
[Contract-First](https://github.com/pentaxis93/principles/blob/main/compositions/contract-first.md).
What this document owns is what no cited home states: the
checkable/reckonable partition, the substrate move, and the three-layer
shape those principles compose into.

## Feedback Loop

The discipline improves through its consumers' friction. A criterion that
resists classification, a domain the three layers fit badly, a reckon-gate
that decayed into a checklist in practice, a substrate whose closure check
proved ungovernable — each is a change-vector for this asset: a filed unit
of friction that steers the asset's next change. File it on the
[tesserine/commons tracker](https://github.com/tesserine/commons/issues)
labeled `asset:design-as-substrate`; the open change-vectors are listed by
[this query](https://github.com/tesserine/commons/issues?q=label%3A%22asset%3Adesign-as-substrate%22).
A reader about to rely on the discipline reads the open change-vectors
first: they are the live, known friction with what this document states.

## Governance

No ADR is derived from this ratification. The promotion contract requires
ADRs only for specific commitments ([`concepts/README.md`
§Promotion](README.md#promotion)), and this document creates none: it states
a general discipline and leaves every implementation choice — token vehicle,
closure assay, gate procedure, design-system scope — with the projects that
instantiate it.

Downstream documents cite this foundation as the discipline's canonical
home. They must not cite it as a commitment by the Tesserine design system,
the Gazette design contract, or any other project to a particular
implementation direction. When an instantiating project proposes such a
choice, the choice needs its own work unit, its own evidence, and — where
the decision is significant — its own ADR.
