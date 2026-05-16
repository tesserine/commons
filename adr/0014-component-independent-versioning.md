# ADR-0014: Component-Independent SemVer and Curatorial Ecosystem Release Versioning

**Status:** Accepted
**Traces to:** Principle 1 (Sovereignty) — primary; Principle 7 (Verifiable
Completion) — secondary; Principle 3 (Grounding) — secondary

## Decision

[ADR-0011](0011-ecosystem-release-identity-and-ceremony.md) establishes the
commons release manifest as the canonical ecosystem release identity, the
atomic publication boundary, the all-or-nothing verification surface, the
home-repository identity model, and the deployment-manifest consumption rule.
Those provisions remain in force. This ADR supersedes one provision of
ADR-0011: the rule that every component inside the ecosystem release set must
tag the same version string.

Components inside the ecosystem release set version per their own SemVer as
features land. Per-component release ceremony continues to apply:
[ADR-0006](0006-release-discipline.md) for cargo-workspace repos,
[ADR-0010](0010-deployment-release-candidates.md) for image-bearing
deployment surfaces, [ADR-0012](0012-ecosystem-release-version-grammar.md) for
tag and version-of-record grammar.

The ecosystem release version is chosen by the release author based on
ecosystem-level shape — what the manifest binding represents to consumers as
an ecosystem release. The author considers operator-facing impact at the
ecosystem level, the substrate evolution since the prior ecosystem release,
and the manifest-level change shape. The ecosystem version follows the SemVer
grammar from [ADR-0012](0012-ecosystem-release-version-grammar.md) at the
ecosystem layer: major signals ecosystem-level breaking change in
operator-facing contracts, minor signals ecosystem-level new capability,
patch signals ecosystem-level bugfix or hardening. The ecosystem version is
not computed from component versions. A component-level minor or major
change does not by itself force the ecosystem version to that level; the
release author considers what the ecosystem release as a whole represents
and chooses accordingly.

The commons release manifest records each component's tag and commit
explicitly. Component tags need not match each other or the ecosystem release
version. A component that has not changed since the prior ecosystem release
appears in the new manifest with its prior tag and commit unchanged.

Stability composes asymmetrically. A stable ecosystem release `X.Y.Z`
composes only stable component tags: every manifest-declared component tag
matches the stable grammar from ADR-0012, `vMAJOR.MINOR.PATCH`, with no
`-rc.N` suffix. An RC ecosystem release `X.Y.Z-rc.N` may compose either
stable or RC component tags. Stable components that have not changed since the
prior ecosystem release retain their stable tags; components being staged
carry their own `-rc.N` tags per ADR-0010.

## Context

Tesserine has run ADR-0011's ecosystem release set in lockstep mode since
adoption: every repo in the release set tags `vX.Y.Z` together. That
convention paid for itself early. It kept release identity legible and avoided
the compatibility matrix that independent versioning introduces.

The tension surfaced during the v0.1.2 rollout when planning a new
interactive-install feature for groundwork. The feature is a new minor in
SemVer terms — proper component versioning wants groundwork at v0.2.0 — but
the rest of the ecosystem (agentd, runa, base, ops) has nothing comparable in
flight at this moment. Under lockstep, shipping the feature requires either
bumping every component to v0.2.0 (false signal: no minor change in those
components) or holding the feature back until other components have material
minor changes (artificial coupling, queue-stalling).

Established practice in the wider ecosystem distinguishes two patterns. The
first, *lockstep versioning*, bumps every component together regardless of
which components changed. The second, *release-train versioning with a Bill
of Materials (BOM)*, lets each component version per its own truth and uses a
manifest to name the curated, tested set that constitutes an ecosystem
release. Spring Cloud is the canonical reference for the BOM pattern; Maven,
Jackson, Symfony, and Linux distribution package management use variants of
the same shape. Modern monorepo guidance treats lockstep where components
have different change rates as a discouraged pattern.

ADR-0011 already adopted the BOM structural shape. The commons release
manifest is a Bill of Materials by another name: it records each component's
tag and commit, it is the canonical identity artifact, and verification is
all-or-nothing across its declared set. What ADR-0011 layered on top of that
structure was the uniform-tag rule. That rule was a convenience, not a
derivation. ADR-0011's deeper "release-boundary participation" criterion
requires manifest atomicity and verification coherence; it does not require
version-string uniformity. The uniformity rule was load-bearing for human
legibility at the time it was written, not for any structural property of
ecosystem release identity.

The grounding test (Principle 3) catches this directly. Lockstep was the
existing attempt; it is descriptive of how the ecosystem has been operated. It
is not normative — it is not what truthful release identity requires. Treating
the existing attempt as the requirement is the most common grounding failure.
The normative requirement is: ecosystem releases must be atomic, identifiable,
and verifiable; component versions must tell the truth about component
changes. Independent component SemVer with curatorial ecosystem versioning
is the shape that delivers both. Curatorial in this sense matches established
practice across the ecosystems cited above: Spring Cloud names BOMs with
chosen release names (Hoxton, 2020.0.0), Linux distributions choose distro
versions independent of package versions inside them, Maven BOMs use parent
project versions chosen by the project rather than aggregated from
dependencies. The pattern in the wild is: the ecosystem version names the
release; the manifest names the components; the two layers carry SemVer
independently.

## Consequences

**Per-component release discipline applies unchanged.** Cargo workspaces
continue under ADR-0006: `cargo release <level>` bumps the workspace version
per its own SemVer, commits, tags, pushes. Image-bearing surfaces continue
under ADR-0010. Tag grammar continues under ADR-0012. The per-component
discipline is the substrate; this ADR governs only how those per-component
releases compose into an ecosystem release.

**Ecosystem release version is chosen, not aggregated.** The release author
chooses the ecosystem version based on ecosystem-level shape, following
SemVer at the ecosystem layer. A component shipping a minor does not force
the ecosystem release to be a minor; a component shipping a major does not
force the ecosystem release to be a major. The signal carried by per-component
SemVer is about that component, not about the ecosystem. The release author
reads ecosystem-level shape and chooses ecosystem-level version accordingly.
This is the curatorial pattern that BOM-based ecosystems use in the wild;
aggregating component versions into an ecosystem version conflates per-component
signals with ecosystem-level signals that are not the same thing.

**Commons release manifest records independent tags.** Each component entry
carries its own tag and commit. The home-repository identity rules from
ADR-0011 remain unchanged: external components carry explicit commit fields,
the commons commit is derived from the manifest's containing commit.
Manifest schema work to admit non-uniform tag strings (if any is required) is
in scope for the manifest-schema phase ADR-0011 already names.

**Component release cadence decouples from ecosystem release cadence.** A
component can ship a release without an ecosystem release following
immediately. The next ecosystem release picks up whatever components have
moved since the prior ecosystem release. Components that have not moved
appear in the new ecosystem manifest with their prior tag and commit unchanged
— their inclusion in the release set is unchanged, only their version string
is unchanged because their substance is unchanged.

**Release set membership criteria remain.** ADR-0011's criterion for joining
the lockstep set — release-boundary participation, truthful declaration,
deployment, or verification — still defines who is in the ecosystem release
set. This ADR changes how members version, not who is a member. "Lockstep
set" remains the operational term for "the set of repositories that compose
an ecosystem release," even though its members no longer move in lockstep on
version strings.

**Deployment manifests reference one ecosystem release.** When a deployment
manifest represents a release deployment, its component pins must match a
single ecosystem release manifest's component set. Mixing component refs from
multiple ecosystem releases produces a deployment that is not a release
deployment under ADR-0011's all-or-nothing rule. Deployment manifests may
still use non-release refs allowed by ADR-0010 for integration or local
testing; that latitude is unchanged.

**Consumer pinning narrows to one version.** A consumer who only cares about
ecosystem identity pins one value: the ecosystem release version. The
manifest performs the resolution to component-level versions. Component-level
versions remain visible in the manifest for consumers who need finer
granularity, but they are not required reading for consumers of the
ecosystem-level surface.

**ADR-0011 is amended, not retired.** Every provision of ADR-0011 other than
the uniform-version rule remains in force: the commons release manifest as
canonical identity, manifest publication as atomic boundary, all-or-nothing
verification, home-repository identity, deployment-manifest consumption,
release surfaces having a version of record, lockstep-set membership criteria,
and the move-forward rule for invalid published releases. This ADR replaces
only the uniform-version provision.

**Per-component SemVer is sovereign.** Each component repo decides its own
version-string trajectory based on its own changes. Cross-component
coordination happens at the ecosystem release manifest, not in per-component
release decisions. A component author does not consult other components'
versions when bumping their own.

**Atomic release is preserved.** Independent versioning does not give up
release atomicity. The atomic boundary remains manifest publication. What was
previously atomic — every component tagging the same string at the same time
— is replaced by what was always actually atomic: the manifest commit that
binds the component set into a verified release.

**What this means for the builder agent.**

- When asked to release a component, version per the component's own changes
  since its last component release. Do not align with other components. Do
  not consult other components' versions.
- When asked to cut an ecosystem release, choose the ecosystem version based
  on ecosystem-level shape since the prior ecosystem release: what changed at
  the manifest level, what operator-facing impact the release carries, how
  the substrate has evolved. Do not aggregate component versions to derive
  the ecosystem version. Write the commons manifest with each component's
  actual current tag and commit, follow ADR-0011's atomic publication and
  all-or-nothing verification.
- When asked which version of component A goes with which version of
  component B, consult the relevant ecosystem release manifest. Do not infer
  compatibility from string matching across components.
- When reviewing a deployment manifest that represents a release deployment,
  verify it pins to one ecosystem release manifest's component set, not a
  mixture.

**What this does not mean.** This ADR does not require components to release
more frequently. A component with no changes between ecosystem releases
simply appears in the next ecosystem manifest with its prior tag — its
version string does not increment. It also does not introduce per-component
compatibility ranges or feature flags; the manifest names exact tags and
commits, as ADR-0011 specifies. It does not change tag grammar (ADR-0012
still applies, at both per-component and ecosystem levels), per-repo release
ceremony (ADR-0006, ADR-0010 still apply), or release-candidate sequencing
(ADR-0010 still applies). It does not affect projects outside the ecosystem
release set; independent-release projects were already independent under
ADR-0011 and remain so.
