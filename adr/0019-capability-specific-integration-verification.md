# ADR-0019: Capability-Specific Integration Verification

**Status:** Accepted
**Traces to:** [Verifiable Completion](https://github.com/pentaxis93/principles/blob/main/principles/verifiable-completion.md) (primary), [Sequence](https://github.com/pentaxis93/principles/blob/main/principles/sequence.md), [Honest Signal](https://github.com/pentaxis93/principles/blob/main/principles/honest-signal.md)
**Extends:** [ADR-0011](0011-ecosystem-release-identity-and-ceremony.md) and [ADR-0014](0014-component-independent-versioning.md)

## Decision

Ecosystem integration verification keeps the canonical fixture gate for every
release, and gains a capability-specific dimension when the ecosystem release
version says the release is carrying operator-facing change.

A minor or major ecosystem release requires a capability-specific integration
exercise before stable publication. The exercise covers the new or changed
operator-facing capability the release introduces. A patch ecosystem release
does not add that exercise; the canonical fixture gate remains the complete
integration-verification gate for patch releases.

The discriminator is the ecosystem version chosen under ADR-0014. ADR-0014
already makes the release author decide the ecosystem-level shape: major means
breaking change in operator-facing contracts, minor means ecosystem-level new
capability, and patch means bugfix or hardening. Capability-specific integration
verification consults that decision rather than adding a second per-release
classification.

The capability-specific exercise may be automated when a fixture exists, or
human-in-the-loop when the release is the first real use of the capability. In
both forms the exercise is acid-test-coupled: surfaced friction is triaged by
the dividing question, "Can this capability be made public fact honestly as-is,
or only by working around a defect?"

Substrate-defect friction blocks stable publication. The fix is made at the
source, a new release candidate is cut, and integration verification runs
again. Capability-shape friction is recorded as a change-vector and does not
block unless publishing through it would fake the pass. The exit condition is a
clean acid-test-blocking-friction ledger: completion means no blocking friction
remains, not that the first real use found no friction at all.

## Context

ADR-0011 established integration verification as the release-cycle gate between
per-component release candidates and stable ecosystem manifest publication.
`ECOSYSTEM-RELEASE.md` realizes that gate with the canonical
`tesserine/example-hello` fixture and three pass criteria: terminal success,
deliver-step schema validity, and MCP-tool delivery. Those criteria prove the
integrated stack runs and the methodology artifact seam still works.

They are intentionally generic, which is also their gap. A release can ship a
new operator-facing capability and still pass the standing fixture without ever
exercising that capability. The M1 interactive handover is the concrete case:
the `greet(name)` fixture can remain green while the dual-mode
interactive-to-interactive handover is never run.

Requiring a capability-specific exercise for every release would be a false
signal. Patch releases do not carry new operator-facing capability by
definition under ADR-0014; forcing a bespoke exercise for them would either
invent a proxy or make the operator prove something the release is not
claiming. The step earns its place only where its absence leaves an unverified
claim.

## Consequences

Minor and major ecosystem releases have two integration-verification layers:
the standing fixture gate that proves the integrated stack and artifact seam,
and the capability-specific exercise that proves the release's new or changed
operator-facing claim.

Patch ecosystem releases keep the standing fixture gate alone. This preserves
the release ceremony's dose: the verification burden increases where the
release's public claim increases, and it stays lean where the release is a
bugfix or hardening release.

The release author does not make an extra "capability exercise required?"
judgment. They choose the ecosystem version under ADR-0014; this ADR derives
the verification obligation from that version. If the author is tempted to
choose a patch version to avoid the exercise while shipping new
operator-facing behavior, the version choice is wrong.

The acid test becomes part of integration verification rather than a separate
post-hoc narrative. Defects in the release substrate halt publication and are
repaired at their source. Friction that only reveals the next shape of the
capability is captured as follow-up work. The release proceeds only when the
blocking-friction ledger is clean.

What this means for the builder agent:

- When cutting or verifying a minor or major ecosystem release, identify the
  new or changed operator-facing capability and exercise it before stable
  publication.
- When cutting or verifying a patch ecosystem release, run the canonical
  fixture gate; do not invent a capability exercise unless the version choice
  itself is wrong.
- When capability exercise friction appears, classify it by the acid-test
  question. Repair substrate defects before release; record non-blocking
  capability-shape change-vectors without pretending the release found no
  friction.

What this does not mean: this ADR does not change the ecosystem manifest schema,
the canonical `example-hello` fixture, or the per-component release-candidate
ceremonies. It changes the integration-verification ceremony that must be
completed before stable ecosystem publication.
