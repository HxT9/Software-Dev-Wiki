# When to Use - Dead Letter Queue

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
  Q[Considering Dead Letter Queue?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Dead Letter Queue]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Dead Letter Queue is the right call.
-

