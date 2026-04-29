# When to Use - Idempotency

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
  Q[Sto valutando Idempotency?] --> Q1[Ho il problema X?]
  Q1 -->|Si| OK[Considera Idempotency]
  Q1 -->|No| NO[Probabilmente non serve]
```

## Real Scenarios
- Scenario 1: contesto, vincoli, perchè Idempotency è la scelta giusta.
-

