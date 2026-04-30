# Notes - SOLID

## Insights

- **SRP is the hardest to apply correctly** because "responsibility" is subjective. The pragmatic test: *who* asks for changes? If two stakeholders can independently demand edits to the same class, it has two responsibilities.
- **DIP is the engine of testability.** Once you internalize that high-level modules should depend on abstractions they own, unit tests stop being a fight.
- **OCP is what makes plugin architectures possible.** The IDE you're typing in, the browsers' devtools, your CI's executors — all built on OCP-style extension points.
- **LSP is checked by your tests, not your compiler.** The type system says `Square` is a `Rectangle`; only your tests say whether substitution actually preserves behavior.
- **ISP is the most underrated.** Splitting fat interfaces clarifies design intent more than people give it credit for.
- The principles are a **vocabulary for code review**, not a checklist for design. Saying "this violates LSP because Square's setters silently couple width and height" is more useful than vague "this feels wrong."
- SOLID is **language-influenced**. In Rust, `traits` give you ISP and DIP almost for free; LSP issues simply don't compile. In Go, structural typing changes the conversation about ISP entirely. Don't import a Java/C# mindset wholesale.

## Edge Cases

- **Sealed enums + switch.** When the variant set is closed and rarely changes, a `switch` on a sealed type is *clearer* than a polymorphic abstraction. OCP doesn't apply if the variants don't actually change.
- **Performance hot loops.** Virtual dispatch through interfaces costs cycles. In a 10M-iteration loop, that's measurable. Sealed types or generic specialization beat OCP here.
- **Single-implementation interfaces.** Sometimes legitimate: testability seam in a strongly-typed language without monkey patching. Just be honest about *why* the interface is there.
- **Mixin-style traits / partial classes.** Some languages encourage cross-cutting reuse via mechanisms that don't fit cleanly into "class with one responsibility." The principle still applies in spirit; the syntax differs.
- **Functional code.** Most of SOLID translates to functional design (pure functions = SRP at function level; HOFs = OCP via function composition; type classes / traits = DIP). The book examples are OOP-flavored but the ideas are broader.

## Gotchas

- **"Make everything an interface" is the most common over-application** and arguably the worst. Interfaces should serve a purpose: testing seam, multiple implementations, or a stable contract across module boundaries. None of those? Skip the interface.
- **Don't refactor toward SOLID without tests.** All five principles are about *changing code safely*; refactoring blindly without coverage trades clean structure for new bugs.
- **DI containers are not SOLID.** A DI container is a *tool* that helps wire SOLID code together. Using a container doesn't make code SOLID; not using one doesn't make code violate SOLID.
- **SRP doesn't mean "one method per class."** That's a misreading. SRP is about cohesion of *responsibility*, not method count.
- **Inheritance trees > 2 levels deep are usually wrong.** SOLID doesn't ban inheritance, but most codebases reach for composition and end up cleaner.
- **The abstraction must be stable.** DIP fails if your "abstraction" changes whenever the implementation does — then you're just renaming the concrete class.

## Open Questions

- *How strictly should SRP be applied at the package/module level vs. class level?* — likely depends on team size and module ownership boundaries.
- *Are there cases where breaking LSP intentionally is acceptable?* — `IList<T>.Add()` throwing `NotSupportedException` for read-only lists is the canonical "yes, but problematic" example. The wider community is split.
- *Is OCP still relevant given how easy refactor-and-deploy has become?* — some argue YAGNI now wins over OCP for variants you don't yet have. Reasonable position; don't ignore the trade-off.
- *How does SOLID translate to async-heavy code?* — generally fine; the principles are about structure, and async is orthogonal. But cancellation, retry, and backoff cross-cut classes in ways that test SRP boundaries.

## Where SOLID came from

- Originated as 5 of Robert Martin's design principles in the late 1990s.
- The acronym "SOLID" was coined by Michael Feathers around 2004.
- Predates the term "OOP design patterns" (GoF, 1994) being widely understood — SOLID was a synthesis of lessons from real OO codebases of the 80s/90s.
- Has been criticized as over-emphasized in some communities (notably mainstream functional and Go circles); the criticism is usually directed at over-application, not at the principles themselves.
