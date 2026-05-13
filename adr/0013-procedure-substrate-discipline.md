# ADR-0013: Procedure Substrate Discipline

**Status:** Accepted
**Traces to:** Principle 3 (Grounding), Principle 4 (Obligation to Dissent),
ADR-0003 (Unconditional Responsibility), Design Principle 8 (Fixes belong at
discovery, not deferred)

## Decision

When executing a documented procedure where the documentation defines the
procedure substrate, a gap in that documentation is substrate work. It is not a
local obstacle to route around, an operator note to remember, or a retrospective
topic that can safely remain informal.

This discipline applies during procedure-following work: release ceremonies,
deployment, cutover, integration verification, recovery procedures, and any
other operation where the documented procedure is the authority an agent is
executing. The recognition condition is not "a document could be improved." It
is "following the documented procedure now requires knowledge, sequence,
parameters, checks, or recovery mechanics that the procedure itself does not
provide."

The timing of discovery determines the mechanism:

**Mid-procedure.** If the gap surfaces while the procedure is still in flight
and continuing would require off-doc investigation or local improvisation, halt
the procedure. File substrate-level work for the gap, run the governance cycle
needed to repair the documented procedure, re-derive any local artifacts from
the updated documentation, and resume from the updated substrate.

**Post-procedure.** If the procedure has already completed, or the gap affects
the next execution rather than the completed outcome, forward-file the gap as
future substrate work, typically against the next-version milestone. The next
session's procedure follows the fixed substrate once that work lands. Do not
declare the gap closed because the immediate operation finished, and do not
absorb it as local knowledge.

The common discipline is the same in both cases: substrate gaps are documented
as substrate work, never normalized as local workarounds. Future executions
follow the documented procedure as updated.

## Context

The ecosystem already has the principles that require this behavior. Principle
3 requires grounding against the real substrate rather than momentum. Principle
4 and ADR-0003 require participants to act when they see something wrong.
Design Principle 8 rejects deferred fixes at discovery time.

Those principles establish responsibility, but procedure-following work needs a
more specific operational mechanic. During a release ceremony, deployment,
cutover, integration verification, or recovery procedure, the documentation is
not merely descriptive support material. It is the execution substrate. When it
has a gap, an agent that keeps moving by reconstructing the missing procedure
locally has already left the substrate, even if the local workaround is correct.

This discipline emerged through repeated ecosystem practice: the Oracy v0.1.0
integration session, the Oracy v0.1.0 cutover on 2026-05-06 and 2026-05-07,
and the v0.1.2 integration verification preparation on 2026-05-13. Those
sessions demonstrated both halt-and-fix-upstream mechanics for active
procedures and forward-filing mechanics for gaps discovered after an operation
had crossed its completion boundary.

## Consequences

**Procedure documentation remains the authority.** Agents execute the
documented procedure, not remembered operator practice. When the procedure is
insufficient, the repair belongs to the procedure substrate before the next
execution depends on it.

**Timing decides halt versus forward-file.** A mid-procedure gap halts because
continuing would create an undocumented branch of the procedure. A
post-procedure gap is filed forward because the completed operation should not
be rewritten into a pretend upstream fix. Both mechanisms preserve the same
invariant: future execution depends on repaired documentation, not informal
memory.

**Local artifacts are re-derived after substrate repair.** If an in-flight
procedure produced notes, manifests, command plans, checklists, or other local
artifacts before the halt, those artifacts are recalculated from the repaired
procedure before resumption. A local artifact derived from a known-broken
substrate is not carried forward as authority.

**The issue is filed at the substrate level.** If the gap belongs to a shared
procedure, the work item is filed against the repository or methodology that
owns that procedure. The issue names the missing substrate, the execution
moment that exposed it, and the condition future agents need the documentation
to satisfy.

**This ADR is a meta-discipline.** It does not enumerate every release,
deployment, cutover, integration verification, or recovery document. Concrete
procedures live in their own artifacts. This ADR defines how agents behave when
those artifacts become insufficient while they are being executed.

## Failure Modes

**Retrospective laundering.** A local workaround is labeled "for
retrospective," but no substrate work lands and the next execution inherits the
same gap.

**Halt rationalization.** A mid-procedure agent notices the substrate gap but
continues because the missing step looks easy to infer. Ease of inference does
not make the gap local.

**Done-work complacency.** A post-procedure agent treats completion of the
immediate operation as closure for the documentation gap. The object completed;
the substrate remains broken.

**Exploratory workaround.** Investigation commands are framed as "let's figure
out how to make this work" when the documented procedure has already stopped
providing an executable path. The moment the agent must discover procedure
semantics outside the procedure, the substrate gap has fired.

## Adjacent Disciplines

**Fix-now-when-cheap.** Cheap local defects should still be fixed immediately:
a typo in the agent's own session note, a wrong value in a command the agent
just wrote, or another defect wholly owned by the local work surface. A
substrate defect surfaced while executing a procedure is different even when
the workaround feels local, because future agents will execute the same
documented substrate.

**General governance fire.** Governance work also fires for new requirements,
design questions, code review findings, and other cross-cutting concerns. This
discipline fires more specifically when executing a documented procedure and
the procedure substrate itself has a gap.

**Cutover-mode operational defaults.** Cutover and deployment work already
require operational caution. Procedure substrate discipline does not compete
with that caution. When a documentation gap surfaces inside cutover or
deployment work, both disciplines apply: protect the operation, and repair or
forward-file the substrate gap according to timing.

## What this means for the builder agent

When you are following a documented procedure and the procedure stops being
self-sufficient, name the substrate gap immediately. If the gap is
mid-procedure, halt and get the substrate repaired before resuming from
re-derived local artifacts. If the gap is post-procedure, file future substrate
work with enough context for the next session to execute from repaired
documentation. Do not convert missing procedure knowledge into private memory,
session notes, or one-off command discovery. The durable fix is the substrate
future agents will read.
