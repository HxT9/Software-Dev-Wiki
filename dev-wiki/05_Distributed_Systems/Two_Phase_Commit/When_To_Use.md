# When to Use - Two Phase Commit

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
  Q[Considering Two Phase Commit?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider Two Phase Commit]
  Q1 -->|No| NO[Probably not needed]
```

## Real Scenarios
- Scenario 1: context, constraints, why Two Phase Commit is the right call.
-

