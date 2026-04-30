# Diagrams - SOLID

## The five principles at a glance

```mermaid
mindmap
  root((SOLID))
    SRP
      One reason to change
      Cohesion at class level
    OCP
      Open for extension
      Closed for modification
    LSP
      Subtype substitutability
      Behavioral contracts
    ISP
      Small client interfaces
      No "fat" abstractions
    DIP
      Depend on abstractions
      Inverts layering direction
```

## SRP refactor — before / after

```mermaid
flowchart LR
  subgraph Before["Before: one god class"]
    R[SalesReport<br/>calc + format + save]
  end
  subgraph After["After: three focused classes"]
    C[SalesCalculator]
    F[SalesHtmlFormatter]
    S[IReportSink<br/>FileReportSink, S3Sink, ...]
    O[SalesReportService] --> C
    O --> F
    O --> S
  end
  Before --> After
```

## Dependency direction (DIP)

The arrow points to **what depends on what**. Without DIP, high-level policy depends on low-level detail. With DIP, both depend on a stable abstraction owned by the high level.

```mermaid
flowchart TB
  subgraph Without["Without DIP"]
    HL1[High-level<br/>OrderService] --> LL1[Low-level<br/>PostgresDb]
  end
  subgraph With["With DIP"]
    HL2[High-level<br/>OrderService] --> ABS[IOrderRepository<br/>abstraction]
    LL2[Low-level<br/>PostgresOrderRepository] --> ABS
  end
```

The abstraction lives in the **same package as the consumer**, not with the implementation. That's what "inversion" means — the dependency direction at compile time is opposite to the runtime call direction.

## ISP — fat interface vs. segregated interfaces

```mermaid
flowchart LR
  subgraph Fat["Fat interface (bad)"]
    direction TB
    IF[IPayments<br/>charge<br/>refund<br/>chargeback<br/>capture<br/>void] -.implements.-> Stripe1[Stripe<br/>all 5]
    IF -.implements.-> Sepa1[SEPA<br/>charge only<br/>throws on others]
  end
  subgraph Segregated["Segregated (good)"]
    direction TB
    A1[IPaymentInitiator<br/>charge]
    A2[IRefundCapable<br/>refund]
    A3[IChargebackCapable<br/>chargeback]
    Stripe2[Stripe] -.implements.-> A1
    Stripe2 -.implements.-> A2
    Stripe2 -.implements.-> A3
    Sepa2[SEPA] -.implements.-> A1
  end
```

In the fat version, SEPA is forced to implement methods it doesn't support — leading to runtime exceptions. In the segregated version, the type system makes the capability gap explicit and impossible to misuse.

## Class diagram of the payment example

See [Example_Real](./Example_Real.md) for the code.

```mermaid
classDiagram
  class IPaymentInitiator {
    <<interface>>
    +string Key
    +ChargeAsync(req) PaymentResult
  }
  class IRefundCapable {
    <<interface>>
    +RefundAsync(txId, amount) RefundResult
  }
  class IRetryPolicy {
    <<interface>>
    +ExecuteAsync(op) T
  }
  class StripeProvider
  class PaypalProvider
  class SepaProvider
  class PaymentService

  StripeProvider ..|> IPaymentInitiator
  StripeProvider ..|> IRefundCapable
  PaypalProvider ..|> IPaymentInitiator
  PaypalProvider ..|> IRefundCapable
  SepaProvider   ..|> IPaymentInitiator

  PaymentService --> IPaymentInitiator
  PaymentService --> IRefundCapable
  PaymentService --> IRetryPolicy
```

Notice: `PaymentService` knows nothing about Stripe, PayPal, or SEPA. New provider = new class implementing the interface(s) it actually supports. That's OCP, ISP, and DIP working together.

## Visual Notes

- The mind map is a memory aid. Use it once, internalize it, then forget the map.
- The DIP diagram is the most important one — getting the dependency direction right is the foundation everything else builds on.
- The ISP diagram captures *why* "I'll just throw NotImplementedException" is an anti-pattern: the type system was already trying to tell you the abstraction was wrong.
