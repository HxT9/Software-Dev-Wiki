# When to Use - Race Conditions

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
  Q[Considering Race Conditions?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Race Conditions]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Race Conditions is the right call.
-

