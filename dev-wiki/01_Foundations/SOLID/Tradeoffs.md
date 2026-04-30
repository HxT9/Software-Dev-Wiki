# Trade-offs - SOLID

## Benefits

- **Localized changes.** A new feature touches one new class instead of editing several existing ones (OCP).
- **Testability without heroics.** Dependencies behind interfaces (DIP) make swapping in fakes/stubs trivial; SRP keeps test setup small because each class has few collaborators.
- **Parallel development.** Clear contracts (ISP, DIP) let teams work against interfaces without blocking on each other's implementations.
- **Easier reasoning.** SRP keeps each class small enough to fit in your head. LSP keeps inheritance honest.
- **Refactor safety.** Cohesive small classes can be moved, renamed, or deleted with low blast radius.
- **Replaceability.** With DIP you can swap an implementation (DB, message broker, logger) without rewriting business logic.

## Drawbacks

- **More files, more types.** A SOLID-adherent module often has 3-5x the file count of a "just write the code" version. New readers face more navigation.
- **Indirection cost (cognitive).** Following a call chain through interfaces and DI containers is harder than reading a straight-line method.
- **Easy to over-engineer.** "Interface for everything" is a real trap. An interface with one implementation that will never have a second is pure noise.
- **Risk of premature abstraction.** OCP applied before you know the axes of change creates the wrong abstractions, which are worse than no abstraction.
- **Onboarding tax.** Junior devs hit a learning curve understanding why a controller calls an interface that's wired by a container to a class three layers away.
- **Ceremony cost.** DI containers, factories, and abstract base classes add boilerplate that pays off only at scale.

## Performance Characteristics

SOLID is largely **performance-neutral** in compiled languages with good optimizers. Specific notes:

- **Virtual dispatch overhead.** Method calls through interfaces use vtable/JIT-table lookups. In hot loops with millions of calls/sec, this is measurable; in 99% of business code, invisible.
- **Memory.** Each object instance carries a vtable pointer (~8 bytes). DI containers retain singletons; transients allocate per request.
- **JIT/compiler inlining.** Modern JITs (RyuJIT, HotSpot, V8) can devirtualize and inline through monomorphic interface calls — neutralizing most overhead in practice.
- **Allocation pressure.** Per-request DI scopes allocate small objects often; in GC languages this creates garbage. In C++/Rust, lifetimes are explicit so this is a non-issue.

For tight numerical/graphics loops or kernel-level code, prefer composition by value, sealed types, or generic specialization over interfaces. Everywhere else, don't optimize SOLID away preemptively.

## Scalability

SOLID scales with **team size and codebase size**, not with users:

- 1-2 devs, 10k LOC: SOLID is mostly overhead.
- 5-15 devs, 100k LOC: SOLID becomes load-bearing — boundaries enable parallel work.
- 50+ devs, 1M+ LOC: SOLID at module/service boundaries is essential; inside modules it becomes a matter of style.

## Maintainability

The strongest argument for SOLID is the maintenance phase:

- **Bug fixing**: defects localize to the responsible class instead of being smeared across modules.
- **Adding features**: new variants slot in via OCP; existing tests stay green.
- **Removing features**: cohesive modules can be deleted cleanly when a feature retires.
- **Reading code 6 months later**: small focused classes describe themselves through their structure.

## Operational Cost

- **Setup**: low — no infrastructure beyond what your language already provides. DI containers add some config.
- **Run-time**: minimal in 99% of cases (see Performance).
- **On-call burden**: indirectly improves it — easier-to-reason-about code means faster diagnosis at 3 AM.

## Alternatives

- **`DRY_KISS_YAGNI`** — for small, single-purpose code, KISS-first beats SOLID-first. Don't apply five principles where two suffice.
- **Procedural / transaction script.** For simple CRUD apps, a flat function-per-endpoint design is often clearer than ceremony around CRUD entities.
- **Functional core, imperative shell.** An alternative discipline that gets similar testability via pure functions instead of interfaces.
- **Data-oriented design** — for performance-critical systems, organize by data layout instead of object hierarchies (game engines, databases).
- **`Composition_over_Inheritance`** — a single principle that delivers most of SOLID's value without all the framework apparatus.
