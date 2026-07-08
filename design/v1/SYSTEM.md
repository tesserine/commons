# Tesserine Design System

**Version:** 1.0.0
**Home:** `design/v1/` — the door, closure boundary, and citation form are in
[`design/README.md`](../README.md).

This document is the versioned prose of the system: the governing fact at its
head, the derivation of each member family from it, and the selection
guidance a consumer works from. The members themselves enumerate from
[`tokens.json`](tokens.json), [`type-scale.json`](type-scale.json), and
[`section-grammar.json`](section-grammar.json).

## The Governing Fact

> **Every Tesserine surface is a typeset record: the quiet, documentary
> projection of a machine-readable artifact that remains the product.**

This decision was authored before any member below existed, and every member
derives from it. Its ground: Tesserine is an ecosystem of autonomous agents
working under explicit, contract-enforced methodology, and what those agents
produce is machine-readable record — contracts, manifests, ledgers,
chronicles. The machine-readable artifact is the product; the agent-first
reading path is canonical; a rendered surface exists so that a human
overseeing the work can read the record
([gazette#10](https://github.com/tesserine/gazette/issues/10), the first
consumer's governing fact, states the same order for its own domain). A
surface with that job attests; it does not persuade, sell, or entertain. Its
visual language is therefore the language of documents of record — the
ledger, the law report, the newspaper of record — not the language of product
marketing.

Four entailments carry the fact into the member families. Each member's
`derivation` field names the entailment it derives through.

1. **A document's ground.** A typeset record is read like paper: warm ink on
   warm paper, book faces rather than display faces, a measure set for
   sustained reading, secondary matter receding without dropping legibility.
   Nothing about the ground announces a brand; the ground's job is to
   disappear under the record.
2. **One rhythm, one ratio.** A record's structure is measured, not
   decorated: every spatial interval is a named fraction or multiple of the
   one reading line, every text size a power of the one modular ratio, and
   structure is marked by weight and the least sufficient rule — never by
   ornament. Hierarchy ranks; it does not shout.
3. **Ink speaks only for the record.** Color departs from ink solely to
   carry what the artifact itself says: its states (passing, needing
   attention, failing) and its citations. Verbatim machine matter stays
   visibly machine-shaped. No color, face, or mark exists for atmosphere.
4. **Composed as a record.** A surface presents the record's own parts in
   the record's own order: identity, summary, content entries with evidence
   standing co-equal, and provenance closing every projection — a typeset
   record ends by citing the artifact it projects.

## The Members

### Tokens — [`tokens.json`](tokens.json)

Family derivation: the token set is the fact's ground and marking discipline
made enumerable. Entailment 1 yields the paper/ink pair, the receding
secondary ink, the book face, and the reading measure. Entailment 2 yields
the spatial rhythm — every space token a named fraction or multiple of the
reading line (the body step's `1rem` size at its `1.5` line height, hence
`1.5rem`) — plus the two text weights that mark structure against running
matter and the hairline that delineates with the least sufficient mark.
Entailment 3 yields the only departures from ink: three state inks and one
citation ink, and the machine face for verbatim matter. There is no token
without a clause of the fact behind it, and no clause without its tokens.

### Type scale — [`type-scale.json`](type-scale.json)

Family derivation: entailment 2 fixes one modular ratio, `1.25` (a major
third) on a `1rem` reading base — enough interval to rank a record's
structure, too little to shout over it. The scale's depth is the record's
projected depth: a machine-readable artifact projects an identity line, at
most three levels of interior structure (an entry's title, a heading within
it, a minor subhead), running matter, and caption-grade metadata — six
steps, powers 4 through -1, no step without a part of the record that needs
it. Leading tightens as size grows so that every step sits on the reading
rhythm rather than floating above it.

### Section grammar — [`section-grammar.json`](section-grammar.json)

Family derivation: entailment 4 names the parts a record projects and their
order; the grammar declares exactly those as forms. One surface form carries
the ground (entailment 1) as a single reading column; a masthead opens with
the record's identity; an optional lede carries the record's own summary;
entries carry titled content and evidence stands co-equal beside them,
machine-shaped per entailment 3; a colophon closes every surface with
provenance and citation, because a projection that did not cite its artifact
would contradict the fact that the artifact remains the product. Forms
separate on the rhythm and delineate with the hairline (entailment 2).

## Selecting from the System

A consumer building a rendering surface faces four classes of selection
decision. Each row names the member that answers it.

### Which section form?

| The content is | Form |
| --- | --- |
| The whole page (exactly one, wraps everything) | `section.surface` |
| The record's identity — name, kind, when projected (first, exactly once) | `section.masthead` |
| The record's own summary or standfirst (at most once, after the masthead) | `section.lede` |
| A titled unit of the record's content (repeatable) | `section.entry` |
| The record's data shown verbatim — tables, statistics, machine output (repeatable) | `section.evidence` |
| Provenance and citation of the projected artifact (last, exactly once) | `section.colophon` |

Composition is declared on `section.surface`: masthead, optional lede, one
or more entries or evidence blocks in the record's order, colophon.

### Which type step and weight?

| The text is | Step | Weight |
| --- | --- | --- |
| The surface's identity line (masthead only) | `type.display` | `weight.structure` |
| An entry's title | `type.title` | `weight.structure` |
| A heading within an entry | `type.heading` | `weight.structure` |
| A minor subhead, or the lede's standfirst | `type.subhead` | `weight.text` |
| Running text | `type.body` | `weight.text` |
| Metadata, captions, provenance, evidence data | `type.caption` | `weight.text` |

Structural marks (`weight.structure`) belong to text that ranks the record;
everything read in sequence carries `weight.text`.

### Which color?

| The role is | Token |
| --- | --- |
| The ground behind everything | `color.paper` |
| Text, by default | `color.ink` |
| Secondary matter that should recede — metadata, captions, provenance | `color.ink-muted` |
| A delineating rule (always at `stroke.hairline` width) | `color.rule` |
| A citation or link | `color.reference` |
| A state the record reports as passing or healthy | `color.state-ok` |
| A state the record reports as needing attention | `color.state-attention` |
| A state the record reports as failing | `color.state-failure` |

No other color exists. If a value seems needed that is none of these roles,
the record is not carrying that meaning, and the surface must not invent it.

### Which space, measure, and face?

| The decision is | Token |
| --- | --- |
| Space inside one line group (label to value, mark to text) | `space.quarter` |
| Space between grouped elements inside a form | `space.half` |
| Space between blocks of running matter | `space.line` |
| Space between sections | `space.double` |
| Line length of the reading column | `measure.reading` |
| Face for everything read as prose | `font.text` |
| Face for verbatim machine matter | `font.machine` |

### When more than one member could serve

Select the quietest member that still preserves the record's distinction:
the smaller space, the lower step, ink before any departure from ink.
Escalate one member at a time, and only when the record's structure or state
would otherwise be lost to the reader. This rule is the fact applied to
selection — a typeset record is quiet, and every departure from quiet must
be carried by the record itself.

## Consuming This System

The closure boundary and the citation form are stated once, at the door:
[`design/README.md`](../README.md). The worked consumption example at
[`example/`](example/) demonstrates a surface drawing every design value
from the members above; [`scripts/test-design-substrate`](../../scripts/test-design-substrate)
and [`scripts/test-design-closure`](../../scripts/test-design-closure) are
the assays that hold this version to what this document claims.
