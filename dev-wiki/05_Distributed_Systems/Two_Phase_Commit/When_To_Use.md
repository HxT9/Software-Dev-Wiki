# When to Use - Two Phase Commit

## Use Cases
Casi d'uso concreti con un minimo di contesto.
-
-

## When to Use
Segnali che indicano che è la scelta giusta.
-
-

## When NOT to Use
Segnali che indicano che è la scelta sbagliata.
-
-

## Decision Tree
```mermaid
flowchart TD
  Q[Sto valutando Two Phase Commit?] --> Q1[Ho il problema X?]
  Q1 -->|Si| OK[Considera Two Phase Commit]
  Q1 -->|No| NO[Probabilmente non serve]
```

## Real Scenarios
- Scenario 1: contesto, vincoli, perchè Two Phase Commit è la scelta giusta.
-

