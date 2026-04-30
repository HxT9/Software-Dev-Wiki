# Real World Example - SOLID

## Context

A payment processing module for an e-commerce backend. Today it integrates **Stripe**; in three months marketing wants **PayPal**; in six months ops wants to add **bank transfer (SEPA)** for European B2B customers. The module is unit-tested and runs in a service that handles tens of requests per second per instance.

This is a good fit for SOLID because:

- New providers are coming — you know the axis of change (OCP).
- Multiple stakeholders drive changes (finance for fees, fraud team for risk checks, infra for retries) — SRP matters.
- The module is tested — DIP makes mocking the provider trivial.
- Different providers expose different capabilities (Stripe supports refunds, SEPA doesn't) — ISP is real.

## Requirements

- Charge a customer for an order, returning a transaction ID and status.
- Issue refunds for completed transactions (only providers that support refunds).
- Capture observability: log each attempt, emit a metric, record the chosen provider.
- Retry transient failures with exponential backoff.
- Make it impossible to call refund on a provider that doesn't support it (compile-time, not runtime).

## Architecture

Five collaborators, one orchestrator. See [Diagrams](./Diagrams.md) for the class diagram.

- `IPaymentInitiator` — segregated interface, all providers implement it (ISP, DIP).
- `IRefundCapable` — separate interface, only providers that support refunds implement it (ISP).
- `StripeProvider`, `PaypalProvider`, `SepaProvider` — concrete providers (OCP: adding a fourth touches no existing class).
- `PaymentService` — orchestrator. Knows nothing about Stripe or PayPal; depends on the abstractions (DIP).
- `IRetryPolicy` — separate concern (SRP); injected by the host.

The orchestrator has a single responsibility: coordinate a payment attempt with logging, metrics, and retries. Provider details live elsewhere.

## Flow

1. Caller invokes `PaymentService.Charge(order, providerKey)`.
2. Service resolves the provider from the registry by key.
3. Service wraps the provider call in the retry policy.
4. Each attempt logs at info, increments a metric, records latency.
5. On terminal success, returns `Success(transactionId)`.
6. On terminal failure, returns `Failure(reason)` — never throws across the boundary.

## Code

```csharp
// --- Abstractions (DIP, ISP) ---

public interface IPaymentInitiator
{
    string Key { get; }                                   // "stripe", "paypal", "sepa"
    Task<PaymentResult> ChargeAsync(ChargeRequest req, CancellationToken ct);
}

public interface IRefundCapable
{
    Task<RefundResult> RefundAsync(string transactionId, decimal amount, CancellationToken ct);
}

public delegate Task<T> RetryableOp<T>(CancellationToken ct);

public interface IRetryPolicy
{
    Task<T> ExecuteAsync<T>(RetryableOp<T> op, CancellationToken ct);
}

// --- Concrete providers (OCP) ---

public sealed class StripeProvider : IPaymentInitiator, IRefundCapable
{
    public string Key => "stripe";
    private readonly StripeClient _client;
    private readonly ILogger<StripeProvider> _log;

    public StripeProvider(StripeClient client, ILogger<StripeProvider> log)
        => (_client, _log) = (client, log);

    public async Task<PaymentResult> ChargeAsync(ChargeRequest req, CancellationToken ct)
    {
        var resp = await _client.Charges.CreateAsync(req.ToStripe(), ct);
        return resp.Status == "succeeded"
            ? PaymentResult.Success(resp.Id)
            : PaymentResult.Failure(resp.FailureReason);
    }

    public async Task<RefundResult> RefundAsync(string txId, decimal amount, CancellationToken ct)
    {
        var resp = await _client.Refunds.CreateAsync(new() { ChargeId = txId, Amount = (long)(amount * 100) }, ct);
        return RefundResult.Success(resp.Id);
    }
}

public sealed class SepaProvider : IPaymentInitiator   // intentionally NOT IRefundCapable
{
    public string Key => "sepa";
    // ... implementation: SEPA refunds aren't supported in this product, so no IRefundCapable.
}

// --- Orchestrator (SRP) ---

public sealed class PaymentService
{
    private readonly IReadOnlyDictionary<string, IPaymentInitiator> _initiators;
    private readonly IReadOnlyDictionary<string, IRefundCapable>    _refunders;
    private readonly IRetryPolicy _retry;
    private readonly ILogger<PaymentService> _log;
    private readonly IMetrics _metrics;

    public PaymentService(
        IEnumerable<IPaymentInitiator> initiators,
        IEnumerable<IRefundCapable> refunders,
        IRetryPolicy retry,
        ILogger<PaymentService> log,
        IMetrics metrics)
    {
        _initiators = initiators.ToDictionary(i => i.Key);
        _refunders  = refunders.OfType<IPaymentInitiator>()
                               .Zip(refunders, (i, r) => (i.Key, r))
                               .ToDictionary(t => t.Key, t => t.r);
        _retry   = retry;
        _log     = log;
        _metrics = metrics;
    }

    public async Task<PaymentResult> ChargeAsync(ChargeRequest req, string providerKey, CancellationToken ct)
    {
        if (!_initiators.TryGetValue(providerKey, out var provider))
            return PaymentResult.Failure($"unknown provider '{providerKey}'");

        using var _scope = _log.BeginScope(new Dictionary<string, object> { ["provider"] = providerKey });
        var sw = Stopwatch.StartNew();
        try
        {
            var result = await _retry.ExecuteAsync(t => provider.ChargeAsync(req, t), ct);
            _metrics.RecordPaymentLatency(providerKey, sw.Elapsed);
            _metrics.IncrementPaymentOutcome(providerKey, result.IsSuccess ? "success" : "failure");
            return result;
        }
        catch (Exception ex)
        {
            _log.LogError(ex, "Charge failed for provider {Provider}", providerKey);
            _metrics.IncrementPaymentOutcome(providerKey, "exception");
            return PaymentResult.Failure(ex.Message);
        }
    }

    public Task<RefundResult> RefundAsync(string providerKey, string txId, decimal amount, CancellationToken ct)
    {
        // Compile-time guarantee: only providers in _refunders can be refunded.
        // If the caller picks a non-refundable provider, they get a clear error, not a silent runtime failure.
        if (!_refunders.TryGetValue(providerKey, out var refunder))
            return Task.FromResult(RefundResult.Failure($"provider '{providerKey}' does not support refunds"));

        return _retry.ExecuteAsync(t => refunder.RefundAsync(txId, amount, t), ct);
    }
}
```

How each principle shows up:

- **SRP**: `PaymentService` orchestrates only. Logging, metrics, retry, and provider details each live elsewhere.
- **OCP**: adding a fourth provider means writing one new class implementing `IPaymentInitiator` and registering it. Zero changes to `PaymentService`.
- **LSP**: every implementer of `IPaymentInitiator` returns a `PaymentResult` with the same semantics. No subtype throws where the contract says return.
- **ISP**: `IRefundCapable` is separate. SEPA's class doesn't implement it, so no caller can ever ask SEPA to refund — checked at compile time. No "throw NotSupportedException" anti-pattern.
- **DIP**: `PaymentService` depends only on `IPaymentInitiator`, `IRefundCapable`, `IRetryPolicy`, `IMetrics`, `ILogger`. The Stripe SDK only appears in `StripeProvider`. The host wires concretes via DI at startup.

## Notes

- `PaymentResult` is a result type (`Success` / `Failure`) instead of throwing for business failures. Throwing is reserved for bugs and infrastructure issues.
- The retry policy is a single seam, not scattered `try/catch` per provider. SRP at the cross-cutting level too.
- `IRetryPolicy` would typically be backed by Polly or a similar library. The interface keeps the orchestrator independent.
- `ChargeRequest.ToStripe()` is an extension that maps the domain request to the provider's SDK model — adapter pattern at the edge keeps domain types clean.

## Improvements

- **Idempotency keys.** Pass a client-supplied idempotency key into `ChargeAsync` and propagate to the provider — see `Idempotency (05_Distributed_Systems)`.
- **Circuit breaker.** Wrap each provider in a circuit breaker so a 30-second Stripe outage doesn't drag the rest of the system down.
- **Outbox pattern.** Persist payment intent before calling the provider; reconcile asynchronously. Avoids "charged but not recorded" failures.
- **Metrics tags.** Cardinality-safe tags (provider, outcome, currency) — avoid customer ID.
- **Distributed tracing.** Open spans around each provider call so end-to-end latency is visible per-provider in tools like Jaeger/Tempo.
- **Feature flag** to fall back from a new provider to the previous one if error rates spike during rollout.
