# Concepts

Conceptual foundation documents for the Tesserine ecosystem. A ratified
concept lives directly in `concepts/` and may be cited as committed
project direction.

## Ratified Concepts

| Concept | Status | Tracking |
| --- | --- | --- |
| [`cognitive-state-machine.md`](cognitive-state-machine.md) | Ratified conceptual foundation. Establishes Tesserine's operational typed cognitive-state graph and the grounded trajectory toward evidential typing; commits the project to no Layer-2 or Layer-3 implementation direction. | [commons#16](https://github.com/tesserine/commons/issues/16), [commons#92](https://github.com/tesserine/commons/issues/92) |

Relationship to the running system: [`runa`](https://github.com/tesserine/runa)
is the implemented cognitive runtime, and
[`runa/ARCHITECTURE.md`](https://github.com/tesserine/runa/blob/main/ARCHITECTURE.md)
is canonical for its actual architecture. The cognitive-state-machine concept
describes the ecosystem's grounded conceptual substrate and trajectory; runa
does not import its vocabulary as implementation architecture.

## Promotion

Promoting a draft requires: discharging its stated pre-work, deriving any
specific commitments as ADRs, moving the file out of `_drafts/`, and
updating this index plus [`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md) in
the same change. The cognitive-state-machine draft has been promoted by
[commons#92](https://github.com/tesserine/commons/issues/92); no ADR was
derived because the ratification creates no specific project commitment.
