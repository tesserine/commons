# Tesserine Design System

The Tesserine design system: the closed set of design tokens, the type
scale, and the section grammar that Tesserine rendering surfaces consume.
This directory is the system's single home — everything the system is lives
under `design/`, and no design value is authoritative anywhere else.

The system is a Tesserine-owned asset, broader than any one consumer. It
instantiates the **design-as-substrate discipline**, whose authority is
[`concepts/design-as-substrate.md`](../concepts/design-as-substrate.md);
this directory carries the citation and the local instance — its own
governing fact, members, and assays — and readers who need the discipline
itself follow that citation. [`SOURCE-OF-TRUTH.md`](../SOURCE-OF-TRUTH.md)
names this home canonical.

## Layout

| Path | What it is |
| --- | --- |
| [`design/v1/SYSTEM.md`](v1/SYSTEM.md) | The versioned system prose: the governing fact, each family's derivation from it, and the selection guidance a consumer works from |
| [`design/v1/tokens.json`](v1/tokens.json) | The token set: colors, spaces, strokes, measure, weights, faces |
| [`design/v1/type-scale.json`](v1/type-scale.json) | The type scale: one base, one ratio, six steps |
| [`design/v1/section-grammar.json`](v1/section-grammar.json) | The section grammar: the forms a surface composes from |
| [`design/v1/schema/`](v1/schema/) | Structural guards for the three member files (internal to this home) |
| [`design/v1/example/`](v1/example/) | The worked consumption example: a specimen surface drawing every design value from the members, with its generated stylesheet and member map |

Two assays hold the system to its claims:
[`scripts/test-design-substrate`](../scripts/test-design-substrate) (the
home exists, members enumerate, one version identifier agrees everywhere)
and [`scripts/test-design-closure`](../scripts/test-design-closure) (every
design value the example uses is a declared member; a seeded off-substrate
value fails).

## What the set closes over

The system is a closed set. Its membership boundary — the value families
inside the set — is:

- **Color** — every color a surface uses, for ground, text, rules, states,
  and citations (`color.*`).
- **Space** — every spatial interval: margins, padding, gaps (`space.*`).
- **Stroke** — every rule width (`stroke.*`).
- **Measure** — the reading column's line length (`measure.*`).
- **Weight** — every font weight (`weight.*`).
- **Face** — every font family (`font.*`).
- **Text size and leading** — every font size and line height, as steps of
  the type scale (`type.*`).
- **Section structure** — every top-level part of a surface and its order,
  as forms of the section grammar (`section.*`).

**On-substrate** means: for a consuming surface, every value it uses in
these families is a declared member — every color a `color.*` token, every
size a `type.*` step, every section a `section.*` form, and so on. A value
in these families that is not a member is off-substrate, and a surface
using one does not conform to the system. Values outside these families
(e.g. an image's own content) are outside the set and outside its claims.

Members enumerate mechanically from the three member files; there is no
member that is not in those files. Consumers select members using the
guidance in [`design/v1/SYSTEM.md`](v1/SYSTEM.md) § Selecting from the
System.

## How a consumer cites the system

The current major is `design/v1/`. Full semver is the conformance target;
the version identifier lives in the `SYSTEM.md` header and in every member
file, and the substrate assay holds them in agreement.

Two reference forms exist, per the repository's canonical-reference
discipline ([ADR-0005](../adr/0005-system-conventions.md)):

- **Navigation (mutable).**
  `https://raw.githubusercontent.com/tesserine/commons/main/design/v1/tokens.json`
  — for humans browsing the current version. Not a conformance target:
  `main` moves.
- **Conformance (immutable).** A commit-SHA or release-tag URL plus the
  full semver. A conformance claim against a moving target is not a
  conformance claim.

A consumer that vendors a member file records provenance with the
`x-tesserine-canonical` block, exactly as vendored canonicals elsewhere in
the ecosystem do:

```json
"x-tesserine-canonical": {
  "url": "https://raw.githubusercontent.com/tesserine/commons/<commit-sha>/design/v1/tokens.json",
  "version": "1.0.0"
}
```

replacing `<commit-sha>` with a real immutable identifier. A consumer that
consumes by reference rather than vendoring states the same pair — immutable
URL form plus full semver — wherever it declares what it renders against.

## Versioning

The major version maps to the directory: `design/v1/` never receives a
breaking edit once shipped; a break is a new `design/v2/` beside it, and old
majors remain reachable forever. Minor and patch releases evolve content in
place — additive members, clarified prose — without breaking a conforming
consumer. This is the [ADR-0005](../adr/0005-system-conventions.md)
versioning convention, consulted rather than reinvented.

## Consumers

Rendering surfaces consume the system by citation; nothing re-derives or
hand-copies its values. The first consumers are the Gazette projection and
design contracts ([tesserine/gazette#10](https://github.com/tesserine/gazette/issues/10),
[#13](https://github.com/tesserine/gazette/issues/13),
[#14](https://github.com/tesserine/gazette/issues/14)); the floors and
constraints a consuming surface adds on top of this substrate are those
consumers' own business, per the discipline's governance.
