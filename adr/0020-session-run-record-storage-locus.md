# ADR-0020: Session Run-Record Storage Locus and Ownership

**Status:** Accepted
**Traces to:** [Sovereignty](https://github.com/pentaxis93/principles/blob/main/principles/sovereignty.md) (primary), [Single Home](https://github.com/pentaxis93/principles/blob/main/principles/single-home.md), [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md)
**Relates to:** [ADR-0008](0008-clean-session-ownership.md) (decides the audit-storage axis ADR-0008 left as a Day-One snapshot), [ADR-0016](0016-connector-layer-architecture-and-forge-capability.md) / [ADR-0017](0017-forge-work-unit-identity-model.md) (the model-is-source, provider-is-projection pattern this decision echoes), and the deployment-artifact-locality family ([commons#19](https://github.com/tesserine/commons/issues/19))

## Decision

Session run-records — the per-stage transcript event streams runa writes
(`agent_input`, `tool_call`, `agent_stderr`, …) and the audit records assembled
from them — are **owned by the project (subscriber) whose work produced them**,
not by the executor that ran the session. Their single authoritative locus is
keyed by **project / deployment identity** — the identity runa already writes
under. The executor **hosts and projects** that store; it does not own it.

Three commitments make this realizable and unambiguous:

- **Ownership is the project's; hosting is the executor's.** The owner of a
  run-record is the project/deployment it belongs to. That owner holds the
  WHAT — the run-records are the project's, and the project can reach them. The
  executor holds the HOW — how it physically hosts, serves, and retains the
  store on the machine where the session ran. Physical custody does not confer
  ownership: an executor that hosts a subscriber's run-data is a projection of
  the project-keyed model, not its source (the ADR-0016/0017 pattern applied to
  run-records).

- **The locus is project-keyed, and it is the single home.** The authoritative
  path shape is the project-keyed nested form runa already emits:

  ```
  <store_root>/deployments/<deployment>/work-units/<work_unit>/runs/<run_id>/events.jsonl
  ```

  The near-term `<store_root>` is a **project-owned locus the subscriber can
  reach**, not the executor-keyed per-agent / per-session audit directory the
  project cannot access. The record's internal keying is unchanged — it is
  already project-centric in runa; what changes is the ownership root the tree
  hangs from. This locus is the single home of a session's run-records; every
  reader (live observation, audit-record finalize, a later replicated form)
  derives from it or consults it, and no second editable copy is kept.

- **agentd owns and injects a deterministic session run identity.** So that
  every stage of a session writes under one deterministic project-keyed path the
  executor knows, agentd sets the deployment and per-run identity it composes
  (`RUNA_TRANSCRIPT_DEPLOYMENT`, and a `RUNA_TRANSCRIPT_RUN_ID` per protocol
  stage — or an equivalent stable identity contract agreed with runa), and reads
  and seals from that nested path for **both** the live tailer and the
  finalize / manifest. This is the agentd↔runa transcript path-contract this
  decision fixes at the level of the contract; the code that realizes it is a
  separate unit (Consequences, below).

The **near-term realization is a directory relocation** of the existing
(non-COB) store to the project-owned locus, plus agentd reading runa's actual
project-keyed path. The COB / Radicle-replicated form of run-records — records
as signed objects replicated to the subscriber's own node — is **explicitly
deferred** to the Radicle substrate era, after the M1 integration test
([commons#50](https://github.com/tesserine/commons/issues/50)). This ADR decides
*ownership and locus*; it does not decide the replicated object form.

## Context

Today, run-records are stored in the **executor's** audit store: a per-agent,
per-session directory on the agentd host (under
`…/audit/<agent>/<session>/agentd/transcript/…`), bind-mounted into the session.
The project owns none of it and cannot reach it. Yet runa already keys the
records themselves by a **project/deployment identity**
(`deployments/<deployment>/work-units/<work_unit>/runs/<run_id>/events.jsonl`).
The logical model is project-centric; only the physical store is
executor-centric. That gap is the whole of the problem: the source of truth for
*who a run-record belongs to* already exists in runa's keying, and the physical
store drifted from it.

Held against the WeForge subscriber model as a sovereignty limit-test,
executor-ownership is unacceptable. A provider that owns a subscriber's run-data
which the subscriber cannot reach denies the subscriber ownership of their own
data — the exact sovereignty violation the ecosystem exists to refuse when it
runs managed agentic labor against subscriber repositories. The ecosystem needs
a decided, sovereignty-grounded answer to *where run-records live and who owns
them*, recorded **before** any implementation relocates directories, so that the
impending agentd read-path repair does not silently ratify executor-ownership by
inertia.

The concrete failure that surfaced this is documented on
[agentd#122](https://github.com/tesserine/agentd/issues/122). agentd tails and
seals a flat `<transcript_dir>/events.jsonl` while runa writes the nested
per-run path above. Against a live rootless-Podman session the flat file was
0 bytes and the sealed record's coverage read `no_events`, while the nested
`deployments/…/runs/<run_id>/events.jsonl` tree held the real, rich events
(`schema_version: 2`) across two protocol stages. agentd sets
`RUNA_TRANSCRIPT_DIR` correctly (the directory is right) but sets neither the
run-id nor the deployment, so runa mints per-process run-ids agentd cannot
predict and agentd reads the wrong file. Two symptoms share one root: live
observation surfaces nothing, and sealed audit records come out empty for real
sessions — a correctness failure of agentd's core purpose. The path-contract fix
is real and imminent; deciding the *locus and ownership* first is what keeps that
fix from encoding the executor-centric store as settled.

This decision does not repeal ADR-0008. ADR-0008 decided **component
orthogonality** — agentd composes the session runtime, runa owns `.runa/`
content, neither absorbs the other — and explicitly left agentd's audit-symlink
storage design as "a Day One snapshot, available for improvement as better
realizations emerge." ADR-0020 decides that open axis: runa still keys the
records by project identity (its content concern), agentd still composes the
physical hosting and mount (its runtime concern), and now the **ownership** of
the resulting run-records is decided — the project's — with a project-keyed locus
that realizes it. Orthogonality holds; the ownership ADR-0008 left provisional is
now settled.

It also sits alongside, without duplicating, the deployment-artifact-locality
family ([commons#19](https://github.com/tesserine/commons/issues/19)):
run-records are one instance of the general intuition that a deployment's
artifacts are local to — owned by — the deployment they belong to. commons#19
states that family principle; this ADR decides the run-record case.

## Consequences

**The store's ownership root moves from executor-keyed to project-keyed.** The
project can reach its own run-records; the per-agent / per-session executor
directory stops being the ownership root. The record's project-keyed internal
tree (`deployments/<deployment>/work-units/<work_unit>/runs/<run_id>/`) is
unchanged — it was already correct — so the relocation is of the root the tree
hangs from, not of the keying within it.

**agentd injects a deterministic run/deployment identity and reads runa's actual
nested path.** This repairs both agentd#122's live observation and the
empty-audit-record finalize bug together — they are two symptoms of the one
path-contract mismatch. That implementation (the directory move + the agentd
read-path and finalize/manifest fix, including reconciling the v2 event schema
with the sealed manifest) is a **separate work unit, gated on this decision**;
it is out of scope here.

**The executor still physically hosts and serves the store.** The session runs
on the executor's host and the records are produced there; "hosts and projects,
does not own" is the sovereignty framing that physical custody does not confer
ownership. When the ecosystem serves subscribers, the store must be reachable by
the subscriber that owns it — a service obligation this ownership decision
establishes and the implementation must honor.

**The COB / Radicle-replicated form is a later evolution of the same model, not
a different decision.** Deferring it (to after commons#50) forecloses nothing:
signed-COB run-records replicated to a subscriber's node are the same
project-owned model expressed on the Radicle substrate. This ADR keeps the
ownership axis decided so that the replicated form, when it comes, is an
implementation of a settled ownership model rather than a re-litigation of it.

**Honest signal.** An executor-keyed store *modeled* executor-ownership as
acceptable — the surface taught a shape the ecosystem rejects. A project-keyed,
subscriber-reachable store tells the truth about who owns the data. Deciding this
before the read-path fix lands is what keeps the store's surface honest.

**What this does not mean.** This is not the implementation, and it does not fix
agentd#122's read path itself — both follow once the locus is decided. It does
not decide the COB / Radicle object form. It does not restate ADR-0008's
orthogonality or commons#19's locality principle; it decides the run-record
ownership those leave open. And it is not a claim that the near-term directory
layout is final — it is the Day-One realization of a decided ownership model,
available for the Radicle-era evolution named above.
