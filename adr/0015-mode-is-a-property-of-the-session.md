# ADR-0015: Mode Is a Property of the Session

**Status:** Accepted
**Traces to:** [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md) (formerly ADR-0001, now superseded), Design Principle 21 (Mode is a
property of the session, not the operation)

## Decision

Autonomous and interactive execution are modes of a session, not variants of
the operations inside that session.

The operation and contract layer is mode-agnostic by construction. Reading a
work unit, producing an artifact, advancing a lifecycle, recording output, or
evaluating a transition is the same operation regardless of whether a human is
driving an interactive session or an autonomous orchestrator is running the
loop. Mode reduces to one difference: who issues the verbs, and therefore who
runs the loop.

Authority lives in the authorization, not in the mechanical act. A shell
launch, button press, CLI command, MCP call, or orchestrator tick does not
create a different authority model for the operation it invokes. Under dual
mode, that sovereignty boundary resolves into two authority kinds:

**Conformance authority.** Runa and the methodology's typed dispositions hold
transition authority. A transition is gated by a typed disposition artifact
produced by the methodology and validated by runa. This is the only transition
gate, and it is identical in both modes.

**Intent authority.** The operator holds intent authority. Operator intent
enters once at the intent seed, through the canonical intent artifact and the
session direction declared from it. The operator may alter or withdraw that
intent, and the session regenerates from the changed seed. The operator is not
inserted as a per-operation approver of conforming output.

No per-operation human approval gate exists in either mode.

## Context

The Tesserine session lifecycle is expressed as methodology protocols and
validated runtime transitions. Runa executes the lifecycle through a validated
surface; methodology artifacts and typed dispositions define what can move.

The dual-mode work in runa requires autonomous and interactive sessions to be
first-class clients of that same validated surface. If interactive execution
hand-rolls operations or treats human presence as an authorization gate, the
architecture forks: autonomous mode becomes the validated path, while
interactive mode becomes a route around the substrate. That fork violates
the [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md) principle's boundary because the mechanical caller begins to change
who owns transition authority.

The intent artifact is the canonical door for operator intent. It lets the
operator declare what is being asked for without becoming the owner of every
operation the session later performs. The runtime and methodology retain
conformance authority over transitions; the operator retains sovereignty over
intent.

## Consequences

**One surface serves both modes.** Interactive drivers and autonomous
orchestrators are clients of the same validated operation surface. The surface
does not branch operation semantics based on caller identity, shell shape, or
launch path.

**Mode changes loop ownership, not operation meaning.** The only mode-shaped
difference is who issues verbs and at what checkpoint granularity. A session
verb has the same contract, validation, and transition consequence in both
modes.

**Authorization is attached to authority, not mechanics.** The act that invokes
an operation is not the source of authority. Authority comes from the
authorized role at the correct boundary: operator intent at the intent seed;
runtime-validated conformance at transition gates.

**Conformance is the transition gate.** A transition moves when the methodology
produces the required typed disposition and runa validates it. Human presence
in an interactive session does not add a second approval gate, and autonomous
execution does not remove a gate. Both modes use the same one.

**Interactive mode is the methodology's development harness.** Removing the
per-operation human gate transfers the full weight of correctness onto the
validator and the full weight of case-knowledge onto the protocol. Interactive
mode discharges that pressure by letting a human observe single steps closely
enough to surface protocol or validator defects. The repair happens at the
source: the protocol, schema, validator, or contract is corrected so the
substrate can carry the case next time.

**Conforming-but-bad output is a substrate defect.** If an output conforms but
the operator judges it bad, the answer is not a hand override. The acid test
has exposed missing case-knowledge or inadequate validation. Repairing that
defect is how the protocol earns autonomous trust; reintroducing a human gate
papers over the weak substrate and preserves the defect.

**Contracts can cite this principle directly.** Runa dual-mode contracts can
refer to this ADR and Design Principle 21 as the source invariant for
mode-agnostic invocation, disposition authority, and lifecycle reachability.
