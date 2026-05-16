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

The lockstep set currently contains:

- `agentd`
- `base`
- `runa`
- `groundwork`
- `commons`
- `ops`

The manifest schema is
[`schemas/ecosystem-release-manifest.schema.json`](schemas/ecosystem-release-manifest.schema.json).
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
  the manifest;
- `ops/deployments/babbie.toml` matches the manifest's deployment subset by
  repository URL and component ref, while `deployment.version` matches the
  ecosystem version.

Failures identify the component, tag, check, expected value, and actual value
where applicable. A failed manifest is not a partial ecosystem release.

## Integration Verification

Integration verification is the release-cycle gate between per-component
release-candidate ceremonies and ecosystem manifest publication. Components
with release-candidate changes cut RC tags through their `RELEASING.md`
procedures. Components without changes keep the immutable release refs already
selected for the next manifest. `ops` cuts its RC tag after the babbie
deployment artifacts declare the actual component refs. The operator then
deploys those refs together, runs an agent session against the canonical
fixture, and decides whether the ecosystem can proceed to stable manifest
production.

Integration verification always executes against immutable refs, never
against unreleased `main`. Changed components normally use cut RC tags
(`vX.Y.Z-rc.N` for that component); unchanged components may use their prior
stable tags. The `ops` RC tag carries the deployment manifest and its literal
deployment artifacts. The verification run deploys exactly those refs and
tests the integrated stack.

The operator procedure is:

1. Cut RC tags for the changed non-`ops` components that need integration
   verification. Order among those repos does not matter; `ops` is cut after
   its deployment artifacts declare the RC substrate.
2. Update `ops` in a single PR so babbie declares and can install the selected
   component refs coherently. Set the refs in `ops/deployments/babbie.toml`,
   update the literal `Image=` line in `ops/agentd.container` to match
   `babbie.toml`'s `agentd.image`, and update the literal `base_image` field
   in `ops/agentd.toml` to match `babbie.toml`'s `base.image`. Submit that
   deployment-artifact change through normal PR review. The
   `scripts/tesserine-rebuild-babbie` `verify_literal_artifacts` check
   requires these checked-in files to be coherent before convergence.
3. Cut the `ops` RC tag at the commit containing the updated deployment
   artifacts.
4. Converge babbie on the host with `scripts/tesserine-rebuild-babbie`.
5. Run the integration test session against `tesserine/example-hello`:

   ```sh
   agentd run site-builder https://github.com/tesserine/example-hello --request 'add a `greet(name)` function'
   ```

6. Evaluate the agent session against the pass criteria below.
7. If the session passes, proceed to stable publication. If it fails,
   file substrate fix issues at the current milestone, cut the next RC, and
   retry the integration verification procedure.

Stable publication is ordered by the verifier's release identity requirements:

1. Compute the ecosystem version by ADR-0014 aggregate SemVer over component
   changes since the prior ecosystem release.
2. Cut stable tags only for components whose own changes require a new
   component release. Components without changes keep their prior stable tag
   and commit in the new manifest.
3. Update `ops` in a single PR so babbie declares and can install the stable
   refs coherently. Set `deployment.version` to the ecosystem version. Set
   each component `ref` and image tag to that component's selected stable tag,
   not to the ecosystem version by default. In the same PR, update the literal
   `Image=` line in `ops/agentd.container` to match `babbie.toml`'s
   `agentd.image`, and update the literal `base_image` field in
   `ops/agentd.toml` to match `babbie.toml`'s `base.image`. Submit that
   deployment-artifact change through normal PR review. The
   `scripts/tesserine-rebuild-babbie` `verify_literal_artifacts` check
   requires these checked-in files to be coherent before convergence.
4. Cut the `ops` stable tag at the commit containing the stable babbie
   deployment manifest.
5. Produce the ecosystem manifest declaring all six lockstep set identities.
   Non-`commons` components declare their tag target commits. The `commons`
   component declares its own component tag; its commit identity is the
   manifest's containing commit, per ADR-0011. The manifest filename and
   `version` field use the ecosystem version, which may differ from component
   tags.
6. Commit the manifest to `commons`.
7. Cut the `commons` stable tag at the manifest-containing commit, following
   [`commons/RELEASING.md`](RELEASING.md).
8. After the tag-triggered release workflows have completed, verify the
   manifest:

   ```sh
   ./scripts/verify-ecosystem-manifest releases/ecosystem/vX.Y.Z.json
   ```

9. Publish the verified ecosystem release.

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
- [`ops/README.md`](https://github.com/tesserine/ops/blob/main/README.md) for
  babbie convergence and host layout;
- [`ops/deployments/README.md`](https://github.com/tesserine/ops/blob/main/deployments/README.md)
  for deployment manifest schema and ref policy;
- [`commons/RELEASE.md`](RELEASE.md) for the commons release ceremony.

This procedure follows
[ADR-0013](adr/0013-procedure-substrate-discipline.md): substrate gaps
surfaced during integration verification are filed at the substrate level,
not absorbed as local workarounds in the release session.
