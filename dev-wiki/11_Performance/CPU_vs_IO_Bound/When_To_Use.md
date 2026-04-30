# When to Use - CPU vs IO Bound

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
  Q[Considering CPU vs IO Bound?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider CPU vs IO Bound]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why CPU vs IO Bound is the right call.
-

