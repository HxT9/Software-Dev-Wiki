# When to Use - Circuit Breaker

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
  Q[Sto valutando Circuit Breaker?] --> Q1[Ho il problema X?]
  Q1 -->|Si| OK[Considera Circuit Breaker]
  Q1 -->|No| NO[Probabilmente non serve]
```

## Real Scenarios
- Scenario 1: contesto, vincoli, perchè Circuit Breaker è la scelta giusta.
-

