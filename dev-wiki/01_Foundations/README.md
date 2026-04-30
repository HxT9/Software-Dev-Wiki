# 01 Foundations

## Overview

Software design principles are the bedrock of maintainable systems. They aren't rules — they're **tensions to balance**. SOLID, DRY, KISS, YAGNI, Coupling/Cohesion, and the rest emerge from real pain felt in real codebases over decades.

The goal of this section isn't to memorize acronyms. It's to recognize the **problem each principle addresses**, so that when you see the symptom in your code you reach for the right tool. A senior engineer doesn't apply SOLID because the textbook says so — they apply SRP because a class has grown three responsibilities and the test file is a nightmare.

These principles also **conflict with each other**. KISS pushes against premature abstraction; SOLID often *adds* indirection. DRY taken too far creates wrong abstractions; YAGNI taken too literally produces fragile code. Mastery is knowing when to lean which way.

## When to reach for what

Map the symptom you observe in code (or in your team's behavior) to the principle that addresses it.

Topics in **bold** are written; the others are proposed.

| Symptom | Reach for |
|---|---|
| Adding a feature breaks unrelated tests | **[SOLID](./SOLID.md)** (OCP), **[Coupling_Cohesion](./Coupling_Cohesion.md)** |
| Same bug fixed in three places | **[DRY_KISS_YAGNI](./DRY_KISS_YAGNI.md)** (DRY) |
| Class is 800 lines and does five things | **[SOLID](./SOLID.md)** (SRP), **[Separation_of_Concerns](./Separation_of_Concerns.md)** |
| Code is verbose, full of edge cases for cases that don't exist | **[DRY_KISS_YAGNI](./DRY_KISS_YAGNI.md)** (KISS + YAGNI) |
| Built a flexible framework, used it once | **[DRY_KISS_YAGNI](./DRY_KISS_YAGNI.md)** (YAGNI) |
| Hard to write a unit test without mocking five things | **[Coupling_Cohesion](./Coupling_Cohesion.md)**, **[SOLID](./SOLID.md)** (DIP) |
| Subclass inherits a method that crashes for that subtype | **[SOLID](./SOLID.md)** (LSP), **[Composition_over_Inheritance](./Composition_over_Inheritance.md)** |
| Interface forces clients to depend on methods they don't use | **[SOLID](./SOLID.md)** (ISP) |
| Class reaches deep into another's internals (`a.getB().getC().doX()`) | **[Law_of_Demeter](./Law_of_Demeter.md)**, **[Encapsulation](./Encapsulation.md)** |
| Bug surfaces far from its real cause | **[Fail_Fast](./Fail_Fast.md)** |
| API name says one thing, method does another | **[Naming_Conventions](./Naming_Conventions.md)**, **[Principle_of_Least_Astonishment](./Principle_of_Least_Astonishment.md)** |
| Code's getting messier release after release | **[Code_Smells](./Code_Smells.md)** → **[Refactoring_Techniques](./Refactoring_Techniques.md)** |
| Module's internals leak into clients | **[Encapsulation](./Encapsulation.md)**, **[Coupling_Cohesion](./Coupling_Cohesion.md)** |

## Topics in this section

✅ written, ⬜ proposed (see [PROPOSED_TOPICS](../00_Index/PROPOSED_TOPICS.md)).

- ✅ [SOLID](./SOLID.md) — five OOP principles (SRP, OCP, LSP, ISP, DIP) for code that bends without breaking.
- ✅ [DRY_KISS_YAGNI](./DRY_KISS_YAGNI.md) — three rules that pull each other into balance: don't repeat, keep simple, don't anticipate.
- ✅ [Coupling_Cohesion](./Coupling_Cohesion.md) — the most important pair of design metrics. Low coupling, high cohesion.
- ✅ [Separation_of_Concerns](./Separation_of_Concerns.md) — different responsibilities live in different modules. Cuts complexity at the seams.
- ✅ [Law_of_Demeter](./Law_of_Demeter.md) — only talk to your direct neighbors. Avoid train-wreck calls.
- ✅ [Composition_over_Inheritance](./Composition_over_Inheritance.md) — favor "has-a" over "is-a". Inheritance binds you tightly to what you extend.
- ✅ [Fail_Fast](./Fail_Fast.md) — surface errors at the first opportunity. Don't paper over invariants.
- ✅ [Principle_of_Least_Astonishment](./Principle_of_Least_Astonishment.md) — code should behave the way a reasonable reader expects.
- ✅ [Encapsulation](./Encapsulation.md) — hide internals, expose behavior. The first line of defense against coupling.
- ✅ [Code_Smells](./Code_Smells.md) — early warning signs that something's off. Catalog of red flags.
- ✅ [Refactoring_Techniques](./Refactoring_Techniques.md) — how to clean up *safely*, in small reversible steps.
- ✅ [Naming_Conventions](./Naming_Conventions.md) — names are the most-read part of code. Get them right.
