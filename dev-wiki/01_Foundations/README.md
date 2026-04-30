# 01 Foundations

## Overview

Software design principles are the bedrock of maintainable systems. They aren't rules — they're **tensions to balance**. SOLID, DRY, KISS, YAGNI, Coupling/Cohesion, and the rest emerge from real pain felt in real codebases over decades.

The goal of this section isn't to memorize acronyms. It's to recognize the **problem each principle addresses**, so that when you see the symptom in your code you reach for the right tool. A senior engineer doesn't apply SOLID because the textbook says so — they apply SRP because a class has grown three responsibilities and the test file is a nightmare.

These principles also **conflict with each other**. KISS pushes against premature abstraction; SOLID often *adds* indirection. DRY taken too far creates wrong abstractions; YAGNI taken too literally produces fragile code. Mastery is knowing when to lean which way.

## When to reach for what

Map the symptom you observe in code (or in your team's behavior) to the principle that addresses it.

| Symptom | Reach for |
|---|---|
| Adding a feature breaks unrelated tests | [SOLID/OCP](./SOLID/), [Coupling_Cohesion](./Coupling_Cohesion/) |
| Same bug fixed in three places | [DRY_KISS_YAGNI](./DRY_KISS_YAGNI/) (the DRY part) |
| Class is 800 lines and does five things | [SOLID/SRP](./SOLID/), [Separation_of_Concerns](./Separation_of_Concerns/) |
| Code is verbose, full of edge cases for cases that don't exist | [DRY_KISS_YAGNI](./DRY_KISS_YAGNI/) (KISS + YAGNI) |
| Built a flexible framework, used it once | [DRY_KISS_YAGNI](./DRY_KISS_YAGNI/) (YAGNI) |
| Hard to write a unit test without mocking five things | [Coupling_Cohesion](./Coupling_Cohesion/), [SOLID/DIP](./SOLID/) |
| Subclass inherits a method that crashes for that subtype | [SOLID/LSP](./SOLID/), [Composition_over_Inheritance](./Composition_over_Inheritance/) |
| Interface forces clients to depend on methods they don't use | [SOLID/ISP](./SOLID/) |
| Class reaches deep into another's internals (`a.getB().getC().doX()`) | [Law_of_Demeter](./Law_of_Demeter/), [Encapsulation](./Encapsulation/) |
| Bug surfaces far from its real cause | [Fail_Fast](./Fail_Fast/) |
| API name says one thing, method does another | [Naming_Conventions](./Naming_Conventions/), [Principle_of_Least_Astonishment](./Principle_of_Least_Astonishment/) |
| Code's getting messier release after release | [Code_Smells](./Code_Smells/) → [Refactoring_Techniques](./Refactoring_Techniques/) |
| Module's internals leak into clients | [Encapsulation](./Encapsulation/), [Coupling_Cohesion](./Coupling_Cohesion/) |

## Topics in this section

- [SOLID](./SOLID/) — five OOP principles (SRP, OCP, LSP, ISP, DIP) for code that bends without breaking.
- [DRY_KISS_YAGNI](./DRY_KISS_YAGNI/) — three rules that pull each other into balance: don't repeat, keep simple, don't anticipate.
- [Coupling_Cohesion](./Coupling_Cohesion/) — the most important pair of design metrics. Low coupling, high cohesion.
- [Separation_of_Concerns](./Separation_of_Concerns/) — different responsibilities live in different modules. Cuts complexity at the seams.
- [Law_of_Demeter](./Law_of_Demeter/) — only talk to your direct neighbors. Avoid train-wreck calls.
- [Composition_over_Inheritance](./Composition_over_Inheritance/) — favor "has-a" over "is-a". Inheritance binds you tightly to what you extend.
- [Fail_Fast](./Fail_Fast/) — surface errors at the first opportunity. Don't paper over invariants.
- [Principle_of_Least_Astonishment](./Principle_of_Least_Astonishment/) — code should behave the way a reasonable reader expects.
- [Encapsulation](./Encapsulation/) — hide internals, expose behavior. The first line of defense against coupling.
- [Code_Smells](./Code_Smells/) — early warning signs that something's off. Catalog of red flags.
- [Refactoring_Techniques](./Refactoring_Techniques/) — how to clean up *safely*, in small reversible steps.
- [Naming_Conventions](./Naming_Conventions/) — names are the most-read part of code. Get them right.

## Tags

`#foundations` `#principles` `#design` `#oop` `#refactoring`
