# When to Use - Idempotency

## Use Cases
Concrete use cases with a bit of context.
-
-

## When to Use
Signals that suggest this is the right choice.
-
-

## When NOT to Use
Signals that suggest this is the wrong choice.
-
-

## Decision Tree
```mermaid
flowchart TD
  Q[Considering Idempotency?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Idempotency]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Idempotency is the right call.
-

