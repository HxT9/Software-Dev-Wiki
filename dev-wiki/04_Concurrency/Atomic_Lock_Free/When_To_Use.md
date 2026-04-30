# When to Use - Atomic Lock Free

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
  Q[Considering Atomic Lock Free?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Atomic Lock Free]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Atomic Lock Free is the right call.
-

