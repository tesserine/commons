# ADR-0018: Repository Merge and History Policy

**Status:** Accepted
**Traces to:** [Transmission](https://github.com/pentaxis93/principles/blob/main/principles/transmission.md) (primary), [Grounding](https://github.com/pentaxis93/principles/blob/main/principles/grounding.md), [Parsimony](https://github.com/pentaxis93/principles/blob/main/principles/parsimony.md)

## Decision

Every repository in the ecosystem carries one uniform merge and history policy,
configured in its forge settings:

- **Allowed merges: squash and rebase. Merge commits are disabled.** Both
  permitted methods produce a linear result; the merge commit — the only method
  that creates a branch topology on the default branch — is the one removed.
- **The default branch enforces linear history**, and force-pushes and branch
  deletion stay disabled. Linear history is a protection-layer guarantee, not a
  convention left to author discipline.
- **Merged head branches are deleted automatically.**
- **Squash commits default to the pull-request title and body**, not the
  concatenation of the branch's intermediate commit messages.

Within that frame the author chooses per pull request:

- **Squash** an iterative series — one logical change developed as a lead commit
  plus follow-up corrections ("feature + fixups"). The default branch receives a
  single coherent, individually-buildable commit; the branch's working commits
  remain on the pull request.
- **Rebase** a curated series — commits that are each independent and
  self-coherent, where the sequence is itself information worth keeping.

The two methods are not redundant: each is correct for a different *shape* of
pull request, and the policy is to match the method to the shape rather than to
mandate one method for every change.

## Context

The policy was reckoned after `commons`'s default branch was found collapsed to
a single parentless commit following a squash merge. Investigation showed no
history was actually lost — the full line survived on tags and the pull-request
branch, and was restored — but it exposed that the ecosystem had no uniform,
enforced position on history at all: merge methods varied per repository, most
allowed merge commits, and only a few default branches were protected.

The deeper reason to settle this is that for an ecosystem whose authority *is*
its recorded decisions, history is a transmission medium. A linear, legible
default branch where each commit is a meaningful, buildable state is what lets a
later reader — human or agent — bisect a regression, attribute a line, or revert
a change without first reverse-engineering a tangle of merge bubbles and
half-built intermediate commits.

The method choice was grounded in the actual shape of merged pull requests, not
in convention. A survey found commit *message* hygiene strong (conventional
commits throughout) but commit *granularity* iterative: "feature + N fixups"
series are common (e.g. a single feature pull request carrying one `feat` commit
and ten sequential `fix` commits). That evidence ruled out both single-method
absolutes. Rebase-only would replay those fixup commits — several of which do not
individually build — onto the default branch, defeating the very bisectability
linear history exists to provide. Squash-only would erase the structure of the
genuinely-atomic multi-commit pull requests that do exist. Allowing squash *or*
rebase under enforced linear history takes the benefit of each and the cost of
neither, while still removing the merge commit that started the confusion.

## Consequences

- The default branch of every repository is linear and free of merge bubbles;
  `git bisect`, `git blame`, and single-change reverts behave predictably across
  the ecosystem.
- A squash never flattens the default branch — it collapses only one pull
  request's own working commits. The safeguard against history loss of the kind
  that prompted this ADR is the force-push protection, not the merge method; the
  two are set together but are independent guarantees.
- Authors carry a per-pull-request judgment (squash the iterative, rebase the
  curated). The guidance above is the rule of thumb; neither method is a default
  to reach for without looking at the change's shape.
- Enforced linear history requires every pull request to be rebasable onto the
  base before it merges. A pull request that has fallen behind must be rebased,
  not merged-in. This friction is intended: it is the cost of a linear record.
- The policy is realized in each repository's forge settings, which are the live
  source of truth for the configuration; this ADR is the decision and its
  rationale, not a mirror of the settings. There is no automated drift check
  between the two today — a candidate for future tooling.
- Linear-history *enforcement* depends on a repository's visibility and plan
  supporting branch protection. The retired `ops` repository (private, on a plan
  without protection) conforms in its merge methods but cannot carry the
  protection rule until it is made public or moved to a supporting plan; until
  then its linear history rests on the merge-method configuration alone.
