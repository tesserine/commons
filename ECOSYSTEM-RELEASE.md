# Ecosystem Releases

Audience: the operator or agent publishing a Tesserine ecosystem release after
each lockstep repository has completed its per-repo release ceremony.

## Release Identity

A Tesserine ecosystem release is declared by a JSON manifest committed to
`commons`. Published manifests live under:

```text
releases/ecosystem/vX.Y.Z.json
```

The manifest is the convention-level source of truth for the release
composition. It declares the ecosystem version and the lockstep component
tags that compose that release:

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
to the manifest published at the `commons` tag, as required by ADR-0011.

## Verification

Verify a manifest with:

```sh
./scripts/verify-ecosystem-manifest releases/ecosystem/vX.Y.Z.json
```

The verifier checks:

- the manifest validates against the schema;
- the manifest filename is the version-derived canonical name
  `vX.Y.Z.json`;
- each lockstep repo appears exactly once;
- each component tag follows ADR-0012 and matches the manifest version;
- each GitHub tag exists;
- each non-`commons` GitHub tag points at the manifest-declared commit;
- the `commons` tag publishes content identical to the manifest being
  verified;
- each repo's release workflow succeeded for the named tag at the tagged
  commit;
- `base` builds from the same `runa` repository and release ref declared by
  the manifest;
- `ops/deployments/babbie.toml` matches the manifest's deployment subset by
  repository URL and ref.

Failures identify the component, tag, check, expected value, and actual value
where applicable. A failed manifest is not a partial ecosystem release.

## Integration Verification

Integration verification is the release-cycle gate between per-repo release
candidate ceremonies and ecosystem manifest publication. Each lockstep repo
first cuts its own `vX.Y.Z-rc.N` tag through its `RELEASING.md` procedure.
Only after those immutable release-candidate refs exist does the operator
deploy them together, run an agent session against the canonical fixture, and
decide whether the ecosystem can proceed to Phase 4 manifest production.

Integration verification always executes against cut RC tags
(`vX.Y.Z-rc.N`), never against unreleased `main`. The RC cuts produce the
immutable refs declared by the babbie deployment manifest; the verification
run deploys exactly those refs and tests the integrated stack.

The operator procedure is:

1. Cut matching RC tags across the six lockstep repos, following each repo's
   `RELEASING.md`.
2. Update `ops/deployments/babbie.toml` so babbie declares the new RC refs,
   and submit that manifest change through normal PR review.
3. Converge babbie on the host with `scripts/tesserine-rebuild-babbie`.
4. Run the integration test session against `tesserine/example-hello`:

   ```sh
   agentd run site-builder https://github.com/tesserine/example-hello --request 'add a `greet(name)` function'
   ```

5. Evaluate the agent session against the pass criteria below.
6. If the session passes, proceed to Phase 4 stable publication. If it fails,
   file substrate fix issues at the current milestone, cut the next RC, and
   retry the integration verification procedure.

Phase 4 stable publication is ordered by the verifier's release identity
requirements:

1. Update `ops/deployments/babbie.toml` so babbie declares the stable refs
   and deployment version, and submit that manifest change through normal PR
   review. Set `deployment.version = "X.Y.Z"`, set `agentd.ref` and
   `base.ref` to `vX.Y.Z`, set `agentd.image` to
   `localhost/agentd:vX.Y.Z`, set `base.image` to
   `localhost/tesserine/base:vX.Y.Z`, and set `runa.ref` and
   `methodologies.groundwork.ref` to `vX.Y.Z`. These stable refs are declared
   tag names; they do not need to exist before the deployment manifest update
   lands.
2. Cut stable tags across the five non-`commons` lockstep repos: `agentd`,
   `base`, `runa`, `groundwork`, and `ops`. The `ops` stable tag points at
   the commit containing the stable babbie deployment manifest.
3. Produce the ecosystem manifest declaring all six lockstep tag identities.
   Non-`commons` components declare their tag target commits. The `commons`
   component declares tag `vX.Y.Z`; its commit identity is the manifest's
   containing commit, per ADR-0011.
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
- [`ops/README.md`](https://github.com/tesserine/ops/blob/main/README.md) for
  babbie convergence and host layout;
- [`ops/deployments/README.md`](https://github.com/tesserine/ops/blob/main/deployments/README.md)
  for deployment manifest schema and ref policy;
- [`commons/RELEASE.md`](RELEASE.md) for the commons release ceremony.

This procedure follows
[ADR-0013](adr/0013-procedure-substrate-discipline.md): substrate gaps
surfaced during integration verification are filed at the substrate level,
not absorbed as local workarounds in the release session.
