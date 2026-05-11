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
The `commons` commit is derived from the commit that contains the manifest, as
required by ADR-0011.

## Verification

Verify a manifest with:

```sh
./scripts/verify-ecosystem-manifest releases/ecosystem/vX.Y.Z.json
```

The verifier checks:

- the manifest validates against the schema;
- each lockstep repo appears exactly once;
- each component tag follows ADR-0012 and matches the manifest version;
- each GitHub tag exists and points at the expected commit;
- each repo's release workflow succeeded for the tagged commit;
- `base` builds from the same `runa` release ref declared by the manifest;
- `ops/deployments/babbie.toml` matches the manifest's deployment subset.

Failures identify the component, tag, check, expected value, and actual value
where applicable. A failed manifest is not a partial ecosystem release.

## v0.1.2 Handoff

Phase 3 provides the schema and verifier substrate. The first real stable
manifest, `releases/ecosystem/v0.1.2.json`, is produced during Phase 4 after
the exact `v0.1.2` tag commits exist across all lockstep repositories.
