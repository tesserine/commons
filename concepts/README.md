# Concepts

Conceptual foundation documents for the Tesserine ecosystem. A ratified
concept lives directly in `concepts/` and may be cited as committed
project direction. Nothing currently has that status.

## `_drafts/` — exploratory, not committed

Documents under [`_drafts/`](_drafts/) are **exploratory**. They are
aide-mémoire and seeds for future reckoning sessions. They are not
committed project direction, no ADR derives from them, and **no repository
or document may depend on them** until they are promoted out of `_drafts/`
through their stated pre-work.

| Draft | Status | Tracking |
| --- | --- | --- |
| [`cognitive-state-machine.md`](_drafts/cognitive-state-machine.md) | Exploratory draft. Captures the April 2026 reckoning that Tesserine already implements the substrate of a typed cognitive state machine. Pre-work (enumerated in the document) is not discharged; ratification has not occurred. | [commons#16](https://github.com/tesserine/commons/issues/16) |

Relationship to the running system: [`runa`](https://github.com/tesserine/runa)
is the implemented cognitive runtime, and
[`runa/ARCHITECTURE.md`](https://github.com/tesserine/runa/blob/main/ARCHITECTURE.md)
is canonical for its actual architecture. The draft describes a possible
type-theoretic *trajectory*, not the current implementation. runa
deliberately does not import the draft's vocabulary.

## Promotion

Promoting a draft requires: discharging its stated pre-work, deriving any
specific commitments as ADRs, moving the file out of `_drafts/`, and
updating this index plus [`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md) in
the same change.
