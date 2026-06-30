# Schemas

Machine-checkable realizations of commons' canonical artifact specs. The
governing pattern is [ADR-0005](../adr/0005-system-conventions.md): a
canonical is a *pair* — a prose authority at repo root plus a versioned
JSON Schema here. The prose is authoritative; when prose and schema
disagree, the schema is the defect.

## Index

| Schema | Canonical prose | Versioning | Downstream vendors |
| --- | --- | --- | --- |
| [`intent/v1/intent.schema.json`](intent/v1/intent.schema.json) | [`INTENT.md`](../INTENT.md) | ADR-0005 layout: major version in the directory (`v1/`), full semver (currently `1.0.0`) in prose header and schema description | `groundwork` ([`schemas/intent.schema.json`](https://github.com/tesserine/groundwork/blob/main/schemas/intent.schema.json), provenance-marked, coherence-tested) |
| [`forge-capability/v1/forge-capability.schema.json`](forge-capability/v1/forge-capability.schema.json) | [`FORGE-CAPABILITY.md`](../FORGE-CAPABILITY.md) | ADR-0005 layout: major version in the directory (`v1/`), full semver (currently `1.0.0`) in prose header and schema description | none yet — downstream connector, runa, and methodology slices of the connector epic will vendor with provenance |
| [`ecosystem-release-manifest.schema.json`](ecosystem-release-manifest.schema.json) | [`ECOSYSTEM-RELEASE.md`](../ECOSYSTEM-RELEASE.md) | internal `schema_version` field: `1` (historical six-component manifests), `2` (current five-component release set); flat placement predates ADR-0005 and is grandfathered | none — consumed in-repo by [`scripts/verify-ecosystem-manifest`](../scripts/verify-ecosystem-manifest) |

## Versioning rule

Per ADR-0005: the major version is the URL-stability boundary
(`schemas/<artifact>/vN/` never receives breaking edits once shipped);
minor and patch edits are additive or clarifying only; any break against a
conforming consumer requires a new major directory.

## Vendoring rule

Consumers that need a runtime copy embed it in their own `schemas/`
directory with provenance metadata recording, at minimum:

- the canonical's **immutable URL** (commit-SHA or release-tag form —
  never a `main`-branch URL), and
- the **full semver** of the canonical version the copy conforms to.

Conformance means content parity on the material fields (`type`,
`required`, `additionalProperties`, per-property constraints); top-level
`description` may add consumer-side context. Drift is a review-time
governance failure, not a runtime failure. Runtime consumers read from the
active methodology, never from commons.

## Worked provenance example

groundwork's vendored intent schema carries an `x-tesserine-canonical`
block:

```json
"x-tesserine-canonical": {
  "version": "1.0.0",
  "schema_url": "https://raw.githubusercontent.com/tesserine/commons/main/schemas/intent/v1/intent.schema.json",
  "prose_url": "https://raw.githubusercontent.com/tesserine/commons/main/INTENT.md"
}
```

and a coherence test
([`tests/test_intent_schema_vendoring.py`](https://github.com/tesserine/groundwork/blob/main/tests/test_intent_schema_vendoring.py))
that fails when the vendored copy drifts from its declared canonical. New
vendored copies imitate both halves: provenance block + drift test.

## Adding a schema

1. Test against ADR-0005's canonicalization criteria (system-level, not
   methodology-private).
2. Author the pair: prose at repo root, schema under
   `schemas/<artifact>/v1/`.
3. Add a row to the index above and, if it introduces a new concept, to
   [`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md).
