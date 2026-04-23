# ADR-0008: Component Orthogonality in Session Composition

**Status:** Accepted
**Traces to:** Principle 1 (Sovereignty) — primary

## Decision

In an agentd-managed session, agentd composes the session runtime; runa
owns `.runa/` content; the agent declares intent. Each component's
surface is orthogonal to the others at clean boundaries: the agent
declares what the operator wants; agentd composes how that intent
becomes a running container; runa initializes and orchestrates its own
artifact tree. No component reaches into another's named domain, and
the agent declaration carries no imperative glue.

## Context

Phase E integration testing on April 23, 2026 surfaced a session
failure that initially appeared to be an ownership collision between
runa and agentd. Runa's `runa init` (executed as the unprivileged
session user) failed with permission errors against `.runa/` — a
symlink agentd's container setup had created pointing into a
root-owned audit directory.

The first architectural framing located the problem as ambiguous
ownership: both runa and agentd reaching for session-state
initialization without clear authority. A proposed resolution moved
all `.runa/` content writing into agentd, excluding runa from its own
directory in agentd-managed contexts. Further reckoning showed that
framing misidentified the defect.

The actual defect was narrower. Runa's init works correctly when
invoked against a session-user-writable working directory — as the
April 12 standalone test confirmed. The April 23 failure was
specifically about container-setup permissions: agentd configured the
audit directory target under ownership the session user could not
write to, then expected runa init to operate there. That is a
container-setup bug, not a sovereignty crisis.

Separately, the April-12-era agent declaration used its `command`
field as a shell-script slot that stitched together `runa init`,
config appending, workspace synthesis, and the final `runa run` exec.
A shell-script slot inside declarative config is a signal that the
declarative layer is missing concepts; the escape hatch absorbs work
that should be the main path.

Resolving these two concerns — the permission collision and the
escape hatch — does not require collapsing responsibilities. It
requires each component's surface to be orthogonal to the others:

- The agent declaration expresses operator intent declaratively; it
  holds no shell program.
- agentd composes the container runtime, including setting up
  `.runa/` with ownership the session user can write to.
- runa initializes `.runa/` content via `runa init`, invoked as the
  session user from agentd's composed container script — not from
  an operator-supplied shell wrapper.
- `.runa/` content — its schema, format, and structure — remains
  runa's concern. agentd does not serialize runa's file formats.

This architecture closes the permission collision (agentd sets up
writable ownership before invoking runa init) and removes the escape
hatch (the agent declaration becomes purely declarative; glue moves
into agentd's composition code, where it belongs) without any
component reaching into another's domain.

## Consequences

**agentd composes session runtime.** For every agentd-managed
session, agentd's container setup creates the session container, the
session user, the cloned repository, and the `.runa/` path — whether
as a symlink into audit storage or otherwise — with ownership the
session user can write to. agentd's composed container script then
invokes `runa init` as the session user with the methodology path
declared by the agent, materializes any operator-supplied invocation
input at the canonical workspace path, and invokes `runa run` with
the agent's command supplied as a CLI argument. None of this is
owned by the agent declaration; none of `.runa/` content schema is
owned by agentd.

**runa owns `.runa/` content.** `runa init` remains the
authoritative initializer for the `.runa/` tree —
`.runa/config.toml`, `.runa/state.toml`, `.runa/store/`,
`.runa/workspace/`, and anything future runa versions add. In
agentd-managed sessions, agentd invokes `runa init` rather than
writing runa's files directly. Runa's file formats, invariants, and
evolution remain runa's concern.

**Agent surface is declarative.** An agent declares the operator's
intent for a class of session. Fields include: name; base image;
methodology directory; repo; command; credentials; mounts; schedule.
The `command` field holds structured argv tokens, not a shell
program. Agentd composes the container runtime from the declared
fields. If the operator needs something the declarative surface
cannot express, the correct response is to extend the declarative
surface — not to smuggle imperative logic through an escape hatch.

**runa run accepts the agent command as a CLI argument.** In
agentd-managed sessions, the agent's command flows from agentd's
composed container script to `runa run` as a CLI override rather
than through persisted config. `runa run` gains a flag (e.g.
`--agent-command -- <argv>` or equivalent) whose argv tokens become
the agent subprocess invocation, taking precedence over any
`[agent].command` in `.runa/config.toml`. In agentd-managed sessions,
`.runa/config.toml` is produced without the `[agent]` section — the
agent declaration in agentd remains the single source of truth.
Standalone runa usage (where a developer invokes `runa run`
directly) continues to read `[agent]` from `.runa/config.toml` as
today. Tracked as a separate runa issue; gates the agentd-side
implementation.

**Invocation input is agentd's concern.** The
`.runa/workspace/<type>/<id>.json` materialized from operator
`--request` input is agentd's write — it enters the system via the
agentd CLI and is per-invocation, not part of session shape. This
is a clean boundary straddle: runa init creates the workspace
directory skeleton; agentd populates per-invocation files inside
it. Two writers, two distinct concerns, no format overlap.

**Breaking change to agent schema.** Existing agent declarations
that use `command = [...shell script...]` require migration.
Pre-1.0 latitude per ADR-0007's embrace of change; the right time
to make this movement is while the foundation is most movable.
Migration pattern: drop the shell wrapper; declare the command as
structured argv data; the methodology path moves out of shell
invocation into a declarative field; agentd's code handles the
composition.

**Component orthogonality as a general principle.** Each component
in the ecosystem owns the surface that bears its name. `.runa/`
belongs to runa. The agent declaration is the operator's declarative
surface. Session runtime composition — what it takes to turn
operator intent into a running container — is agentd's. When a
component starts writing another component's file formats,
serializing another component's structures, or expecting an
operator to stitch together concerns that should be infrastructure,
sovereignty has blurred. The corrective is to name each surface
cleanly and let each component own what its name implies.

**What this means for the builder agent.** When proposing changes
to the agent declaration surface, resist adding imperative fields;
the declarative constraint is load-bearing. When composing session
lifecycle work, compose in agentd's container-script code — do not
smuggle through the agent declaration or duplicate runa's
initialization logic. When reviewing existing architecture for
cleanliness, check whether a component is reaching into another
component's named surface; each such reach is a sovereignty
violation worth correcting.

**What this does not mean.** This is not a claim that agentd's
current audit-symlink design is final — that design is a Day One
snapshot, available for improvement as better realizations emerge.
This is not a restriction on runa's `init` command; `runa init`
remains valid both inside and outside agentd-managed sessions. The
commitment this ADR makes is about component orthogonality at
surfaces — each tool owning what its name names — not about any
single mechanism.
