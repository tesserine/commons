# ADR-0009: Operator Metrics Convention

**Status:** Accepted
**Traces to:** Principle 3 (Grounding) - primary; Principle 7 (Verifiable Completion) - secondary

## Decision

Tesserine products that expose Prometheus-compatible runtime metrics use a
separate operator listener from their public API listener. The listener
defaults to loopback, may be overridden by product configuration, and is
protected by operator network placement rather than application-level scrape
authentication unless a product has a stronger stated requirement.

Metrics use Prometheus text exposition format version `0.0.4`. Metric names
follow `{product}_{subsystem}_{measure}_{unit}` when a unit exists, with
Prometheus counter names ending in `_total`. Labels are limited to bounded
enumerations. Unbounded identifiers, filesystem paths, user content, and
free-form text are forbidden as label values.

The convention does not bind products to one Rust metrics crate or facade.
Each product owns its instrumentation stack choice so long as the exposed
operator contract conforms to this ADR.

## Context

Oracy needs an operator-facing metrics surface for cleanup outcomes, worker
throughput, retained-audio capacity, and retry/failure rates. Those metrics are
not user API resources: they are operational telemetry for scraping systems and
deployment operators. Putting them on the public API listener would make the
operator/public boundary a routing convention; a separate listener makes the
boundary observable in deployment topology.

The naming and cardinality decisions are ecosystem-level because future
products will need the same answers. Product-local improvisation would create
drift: `oracy_*`, `agentd_*`, and `runa_*` metrics should feel like one family
when an operator queries them together.

## Consequences

**Separate operator surface.** Products expose metrics on an operator listener
distinct from any public API listener. A public listener must not serve
`/metrics` unless a later ADR explicitly changes the convention.

**Loopback default.** The default operator bind host or interface is loopback.
Operators may override it when the scraper runs outside the product's host or
container namespace. Products must reject configurations that make the public
and operator listeners the same socket endpoint: the same bind host or IP
address and port after configuration resolution. Binding both listeners to
loopback on different ports is valid.

**Network placement as access boundary.** Metrics are protected by deployment
topology: loopback binding, firewall policy, reverse-proxy policy, service mesh
policy, or equivalent controls. Application-level metrics auth is not required
by this convention. A product may add it only when that product's threat model
earns the extra surface.

**Exposition format.** The scrape endpoint returns Prometheus text exposition
format version `0.0.4`. Products may adopt OpenMetrics in the future only
through a convention update, because scrape format is an operator-visible
contract.

**Metric naming.** Names start with the product prefix, then subsystem, then
measure, then unit when the measure has one. Counters end in `_total`; byte
gauges end in `_bytes`; base units are preferred over derived units. Examples:
`oracy_transcription_worker_jobs_total`,
`oracy_retention_cleanup_artifacts_total`,
`oracy_retained_audio_bytes`.

**Cardinality policy.** Labels must be bounded enumerations with stable meaning.
Allowed dimensions include outcome, failure class, artifact type, engine name,
and similar finite product vocabularies. Forbidden dimensions include job IDs,
API key IDs, request IDs, idempotency keys, filesystem paths, user content, and
free-form error messages.

**Crate-choice latitude.** This ADR defines the exposed contract, not the
instrumentation substrate. A product may use a direct Prometheus client, a
metrics facade, OpenTelemetry internally with Prometheus export, or another
implementation if the scrape surface and cardinality policy conform.

**What this means for the builder agent.** When adding metrics to a Tesserine
product, design the operator listener and metric names as contract-visible
surface. Do not place metrics on the public API listener for convenience. Do
not add labels from convenient local variables unless their value space is
explicitly bounded.
