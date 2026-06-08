# Ecosystem Releases

Audience: the operator or agent publishing a Tesserine ecosystem release after
the participating lockstep set components have completed their needed
per-component release ceremonies.

## Release Identity

A Tesserine ecosystem release is declared by a JSON manifest committed to
`commons`. Published manifests live under:

```text
releases/ecosystem/vX.Y.Z.json
```

The manifest is the convention-level source of truth for the release
composition. It declares the ecosystem version and the component tags that
compose that release. Component tags follow each component's own SemVer and
need not match each other or the ecosystem version. Components that have not
changed since the prior ecosystem release keep their prior tag and commit.

The current release set for new manifests contains:

- `agentd`
- `base`
- `runa`
- `groundwork`
- `commons`

The manifest schema is
[`schemas/ecosystem-release-manifest.schema.json`](schemas/ecosystem-release-manifest.schema.json).
`schema_version: 1` is retained for already-published six-component
historical manifests. New host-agnostic manifests use `schema_version: 2` and
the current five-component release set above.
Non-`commons` components declare the exact commit their tag must point at.
For `commons`, the verifier confirms the local manifest content is identical
to the manifest published at the `commons` component tag, as required by
ADR-0011.

## Verification

Verify a manifest with:

```sh
./scripts/verify-ecosystem-manifest releases/ecosystem/vX.Y.Z.json
```

The verifier checks:

- the manifest validates against the schema;
- the manifest filename is the version-derived canonical name
  `vX.Y.Z.json`;
- each lockstep set member appears exactly once;
- each component tag follows ADR-0012;
- each GitHub tag exists;
- each non-`commons` GitHub tag points at the manifest-declared commit;
- the `commons` tag publishes content identical to the manifest being
  verified;
- each repo's release workflow succeeded for the named tag at the tagged
  commit;
- `base` builds from the same `runa` repository and release ref declared by
  the manifest.

Failures identify the component, tag, check, expected value, and actual value
where applicable. A failed manifest is not a partial ecosystem release.

## Integration Verification

Integration verification is the release-cycle gate between per-component
release-candidate ceremonies and ecosystem manifest publication. Components
with release-candidate changes cut RC tags through their `RELEASING.md`
procedures. Components without changes keep the immutable release refs already
selected for the next manifest. The operator then deploys those refs together
on a host they control, runs an agent session against the canonical fixture,
and decides whether the ecosystem can proceed to stable manifest production.

Integration verification always executes against immutable refs, never
against unreleased `main`. Changed components normally use cut RC tags
(`vX.Y.Z-rc.N` for that component); unchanged components may use their prior
stable tags. The verification run deploys exactly those manifest refs and
tests the integrated stack. Host-specific deployment manifests, convergence
commands, filesystem paths, and runtime identities belong to the operator's
own host operations, not to the ecosystem release manifest.

The operator procedure is:

1. Cut RC tags for the changed components that need integration verification.
   Order among those repos does not matter unless a component's own
   `RELEASING.md` defines a dependency.
2. On an operator-controlled verification host, deploy the selected component
   refs as an integrated stack using that host's own operations repository and
   deployment procedure.
3. Run the integration test session against `tesserine/example-hello`:

   ```sh
   agentd run site-builder https://github.com/tesserine/example-hello --request 'add a `greet(name)` function'
   ```

4. Evaluate the agent session against the pass criteria below.
5. If the session passes, proceed to stable publication. If it fails,
   file substrate fix issues at the current milestone, cut the next RC, and
   retry the integration verification procedure.

Stable publication is ordered by the verifier's release identity requirements:

1. Choose the ecosystem version per [ADR-0014](adr/0014-component-independent-versioning.md):
   the release author reads ecosystem-level shape (operator-facing impact,
   substrate evolution, manifest-level change shape since the prior ecosystem
   release) and chooses major, minor, or patch at the ecosystem layer
   following the SemVer grammar of [ADR-0012](adr/0012-ecosystem-release-version-grammar.md).
   Component versions are not aggregated to derive the ecosystem version.
2. Cut stable tags only for components whose own changes require a new
   component release. Components without changes keep their prior stable tag
   and commit in the new manifest.
3. Produce the ecosystem manifest declaring the current release set identities.
   Non-`commons` components declare their tag target commits. The `commons`
   component declares its own component tag; its commit identity is the
   manifest's containing commit, per ADR-0011. The manifest filename and
   `version` field use the ecosystem version, which may differ from component
   tags.
4. Commit the manifest to `commons`.
5. Cut the `commons` stable tag at the manifest-containing commit, following
   [`commons/RELEASING.md`](RELEASING.md).
6. After the tag-triggered release workflows have completed, verify the
   manifest:

   ```sh
   ./scripts/verify-ecosystem-manifest releases/ecosystem/vX.Y.Z.json
   ```

7. Publish the verified ecosystem release.

The canonical integration fixture is
[`tesserine/example-hello`](https://github.com/tesserine/example-hello). Its
README names the canonical request: add a `greet(name)` function.

The agent session passes only when:

- the session reaches a terminal success state, rather than stopping blocked
  mid-protocol;
- the session progresses past every artifact-producing protocol's deliver
  step without schema-validation failures from envelope or identity-in-body
  mismatches;
- the agent delivers artifacts through the MCP tools, with no direct writes
  to `.runa/workspace/`.

The supporting procedure documents are:

- per-repo `RELEASING.md` files for RC and stable tag cuts;
- each workload's deployment documentation for host-agnostic runtime
  requirements;
- [`commons/RELEASE.md`](RELEASE.md) for the commons release ceremony.

This procedure follows
[ADR-0013](adr/0013-procedure-substrate-discipline.md): substrate gaps
surfaced during integration verification are filed at the substrate level,
not absorbed as local workarounds in the release session.
