# When to Use - Bulkhead

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
  Q[Considering Bulkhead?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Bulkhead]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Bulkhead is the right call.
-

