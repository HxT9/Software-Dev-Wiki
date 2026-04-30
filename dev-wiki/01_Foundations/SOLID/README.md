---
title: SOLID
section: 01_Foundations
status: reviewed
difficulty: intermediate
tags: [foundations, principles, oop, design]
prerequisites: [Encapsulation, Coupling_Cohesion]
related: [DRY_KISS_YAGNI, Separation_of_Concerns, Composition_over_Inheritance]
last_updated: 2026-04-30
reading_time_min: 12
---

# SOLID

## Overview

Five OOP design principles popularized by Robert C. Martin (Uncle Bob). Each addresses a specific failure mode that shows up as object-oriented codebases grow: god classes, rigid inheritance, untestable modules, brittle changes that ripple unpredictably.

The acronym is a mnemonic, not an ordering. The principles are interdependent — applying one well usually pulls the others along.

## Problem

OOP gives you classes, inheritance, polymorphism, and interfaces. Without discipline, those tools produce:

- Classes with five reasons to change, where every bug fix risks breaking something unrelated.
- Inheritance trees that calcify, where adding a feature means modifying ten existing classes.
- Modules so coupled that you can't unit-test one without standing up half the system.
- Subclasses that quietly violate their parent's contract, surfacing weird bugs later.
- Fat interfaces that force every consumer to depend on methods they never call.

SOLID gives you five lenses to spot these failure modes and guide refactors away from them.

## Key Concepts

The five principles, each in one sentence:

- **SRP — Single Responsibility Principle.** *A class should have one reason to change.* "Reason" maps to a stakeholder or a category of change (business rule vs. presentation vs. persistence).
- **OCP — Open/Closed Principle.** *Open for extension, closed for modification.* You add a new behavior by adding a new class, not by editing existing ones.
- **LSP — Liskov Substitution Principle.** *Subtypes must be substitutable for their base types* without breaking callers' expectations. Inheritance implies a behavioral contract, not just shared methods.
- **ISP — Interface Segregation Principle.** *Many small client-specific interfaces beat one fat general-purpose interface.* Don't force a consumer to depend on methods it doesn't use.
- **DIP — Dependency Inversion Principle.** *High-level modules and low-level modules both depend on abstractions.* Abstractions don't depend on details. This inverts the natural dependency direction in layered architectures.

The first three (SRP, OCP, LSP) are about **what a class is and how it grows**. The last two (ISP, DIP) are about **how classes relate to each other**.

## Prerequisites

What you should already understand:

- OOP basics: classes, methods, inheritance, polymorphism, interfaces.
- `Encapsulation` — hiding internals behind a stable surface.
- `Coupling_Cohesion` — SOLID is partly a recipe for low coupling and high cohesion.
- Basic unit testing: SOLID's payoff shows up most clearly when you try to write tests.

## Deep Dives

- [When to Use](./When_To_Use.md) — use cases, indicators, decision tree.
- [Trade-offs](./Tradeoffs.md) — what SOLID buys you and what it costs.
- [Simple Example](./Example_Simple.md) — a minimal SRP refactor.
- [Real World Example](./Example_Real.md) — a payment service applying all five.
- [Diagrams](./Diagrams.md) — class diagrams and dependency direction.
- [Checklist](./Checklist.md) — review and self-check items per principle.
- [Topic Anti-Patterns](./Topic_AntiPatterns.md) — common ways SOLID is misapplied.
- [Notes](./Notes.md) — insights, edge cases, gotchas.
- [Playground](./Playground/) — runnable code.

## Related Topics

- `DRY_KISS_YAGNI` — counterweight to over-applied SOLID.
- `Separation_of_Concerns` — broader principle that SRP specializes.
- `Composition_over_Inheritance` — practical strategy that helps satisfy LSP and OCP.
- `Coupling_Cohesion` — the metrics SOLID tries to optimize for.
- `Repository pattern (03_Design_Patterns/Architectural)` — DIP made concrete.
- `Strategy pattern (03_Design_Patterns/Behavioral)` — OCP made concrete.

## References

- Robert C. Martin, *Agile Software Development: Principles, Patterns, and Practices* (2002) — the original SOLID exposition.
- Robert C. Martin, *Clean Architecture* (2017) — SOLID applied at architecture scale.
- [SOLID — Wikipedia](https://en.wikipedia.org/wiki/SOLID).
- Sandi Metz, *Practical Object-Oriented Design in Ruby* — pragmatic counterpoint that questions some classical applications.
