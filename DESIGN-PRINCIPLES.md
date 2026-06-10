# Design Principles

> **Canonical home:** These design principles have been ascended to their
> universal level at
> [`pentaxis93/principles`](https://github.com/pentaxis93/principles).
> That corpus is the single source of truth; this file remains for
> historical reference and link stability.

Engineering judgment for the ecosystem. These principles sit
between the bedrock principles (PRINCIPLES.md) and project-specific ADRs —
they govern how we think about code across all repos.

Each principle was learned through friction: review rounds that revealed
architectural mistakes, bugs that traced back to design decisions, or
patterns that emerged across multiple projects.

---

## Elimination over accommodation

### 1. Relentlessly replace brittle with robust

When you find a brittle solution — one that works today but will break
under pressure, at scale, or when assumptions change — replace it with a
robust one. Do not accommodate brittleness with workarounds, documentation,
or process. This stance is the root of principles 2–5: each is a specific
form of replacing something brittle with something robust.

### 2. One mechanism, not two

When two systems must agree, make them one system. Two filters that must
stay in sync will diverge. Two sources of truth for the same decision will
contradict. If a remediation patches a second filter to match a first,
look for the architectural fix that eliminates the class.

### 3. Eliminate the class, not the instance

When a fix makes a subsystem smarter about one more edge case, ask whether
the subsystem should exist. The recognition signal: "each fix makes the
subsystem smarter about one more edge case without eliminating the class of
bug." If the pattern is visible by round 3-4, name it — don’t wait for
round 10.

### 4. Computed over stored for derived state

If the source of truth is available at query time, derive the answer
instead of storing it. Stored derived state goes stale, creating
consistency bugs and meta-staleness problems.

### 5. Policy over status tracking

When a status is always true by convention, enforce it as policy rather
than tracking it. Eliminates a state dimension and the engine complexity
to manage it.

---

## Fix at the source

### 6. Silent code teaches louder than docs

Code that silently accepts a condition models that condition as acceptable.
Agents and reviewers follow the code’s model, not the documentation’s
disclaimers. When code and docs disagree about what’s supported, fix the
code — that’s where the false signal originates.

### 7. Trace assumptions to their origin

When a reviewer or agent makes a wrong assumption, trace it back to the
code or artifact that created it. The surface correction is documentation;
the real fix is at the source. Issues are seeds — contamination in the
seed propagates through the plan into the implementation with perfect
fidelity.

### 8. Fixes belong at discovery, not deferred

One fix now prevents compounding friction across every future change. A
known problem deferred accumulates interest. Silence in the face of a
known problem is complicity with that problem.

---

## Honest naming and structure

### 9. Name what it is, not what you wish it were

Borrowed prestige inflates architecture. Honest naming compresses to the
real shape. If a layer exists only because an adjacent system has one,
it doesn’t earn its place.

### 10. Fail explicitly, never silently

Silent degradation paths create false assumptions about what’s supported.
Explicit failure is clearer than graceful degradation — it prevents
downstream systems from building on capabilities that don’t exist.

---

## Correctness over optimization

### 11. Ship correct, then optimize

Pre-v1.0, correctness matters more than avoiding wasted work. An
optimization that introduces a correctness gap is a regression. Wasted
work produces identical output; incorrect optimization produces wrong
output.

### 12. Omit rather than half-implement

A deferred feature is better than a half-correct one. The instinct to
"complete all acceptance criteria" is weaker than the instinct to ship
correct code.

---

## Architecture as communication

### 13. Self-maintaining over maintainer-dependent

Prefer architectures where the system maintains itself. Runtime resolution
over build-time embedding. Upstream verification over local verification
files. A self-maintaining design is better than a maintainer-dependent
design, even if less elegant.

### 14. Spec and implementation are separate scopes

A boundary spec defines the interface. The work to implement it is a
separate scope. Mixing them confuses executors — the agent cannot
distinguish constraints from descriptions.

### 15. Ground to needs, not to code

Code is current state, not ground truth. Ground to what is needed, then
compare code to what needs require. Treating what the system currently does
as the definition of what it should do is the most common grounding failure.

---

## Review discipline

### 16. Fix is the default disposition

Accept must be acceptable permanently — not "we’ll address it holistically
later." Defer requires an issue so it doesn’t pass silently. When in doubt,
fix.

---

## Self-describing interfaces

### 17. Interfaces describe themselves

An interface that exposes its own schema lets consumers — humans landing
cold, autonomous agents, code generators — discover capability through the
interface itself. Documentation maintained alongside is a second source of
truth that will drift; documentation derived from schema cannot. The schema
is the contract, not a paraphrase of the contract.

Markdown describing an API requires every consumer to read it, trust it,
and discover staleness only after failure. A queryable schema requires no
trust: the consumer asks the surface what it can do and the surface
answers from the live contract.

Every fresh context window is the first time an agent encounters a
surface. The surface that describes itself enables action without
operator-mediated discovery.

### 18. Schema is the source; documentation is derived

When schema and docs both describe a contract, the question is which one
moves first. Schema-first means changes propagate to docs automatically —
drift is structurally impossible. Doc-first means a human must mirror
changes and the system has no way to know when they failed to.

Prefer formats and pipelines where docs are generated from schema. The
direction of derivation is the principle; the format is implementation.

### 19. Uniform patterns across surfaces

Pagination shape, authentication mechanism, error structure, identifier
format, mutation semantics — these are cognitive load that amortizes if
uniform across an ecosystem and compounds if inconsistent. When two
surfaces in the same ecosystem disagree on pagination, every consumer pays
the integration cost twice and the inconsistency teaches new surfaces that
disagreement is allowed.

This is not "everyone copies one specification." It is "the patterns are
uniform" — which may mean shared specification, or may mean a thin layer
of conventions each surface adopts naturally.

### 20. Verify before act

A consumer constructing a call should be able to check validity before
committing. Type-check the call against the schema. Dry-run the operation.
Introspect the available arguments. Validate the payload against the
contract.

The cost of building this capability is paid once. The cost of consumers
acting on stale assumptions, failing partway through, and cleaning up
partial state is paid every call. For autonomous consumers, the cleanup
cost includes confusing downstream state that propagates into the next
call.

---

## Session mode

### 21. Mode is a property of the session, not the operation

The operation and contract layer is mode-agnostic by construction. Reading a
ticket, writing an artifact, advancing a lifecycle, or recording output is the
same operation whether a human is driving an interactive session or an
autonomous orchestrator is running the loop.

Mode changes who issues the verbs and at what checkpoint granularity. It does
not change the verbs' semantics, authorization model, validation gates, or
artifact contracts. Authorization lives in the authorization, not in the
mechanical act of launching a shell, calling a tool, or pressing a key.

Transitions are gated by conformance: typed dispositions produced by the
methodology and validated by the runtime. Operator intent enters at the
request seed. Neither mode adds a per-operation human approval gate for
conforming output.

---

*Each principle was extracted from a concrete mistake. The mistake is the
teacher; the principle is the lesson encoded so the mistake need not repeat.*
