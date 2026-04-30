# Checklist - SOLID

## Implementation Checklist

When designing or refactoring a class/module, walk through these:

### SRP — Single Responsibility
- [ ] Can I describe what this class does in one sentence without using "and"?
- [ ] Are all the methods talking to the same set of fields? (Cohesion check.)
- [ ] If a stakeholder asked for a change, would only this class change?
- [ ] Could I delete the class and the responsibility would be cleanly gone, with no leftover behavior?

### OCP — Open/Closed
- [ ] If a new variant is added, do I have to modify existing code, or can I add a new class?
- [ ] Are extension points placed at the right axes of change (the ones I actually expect to vary)?
- [ ] Am I avoiding speculation? OCP for axes that *might* vary in the future is YAGNI.

### LSP — Liskov Substitution
- [ ] Can a caller swap any subtype for the base type without changing behavior?
- [ ] Do subtypes preserve invariants the base type promises (return values, exceptions thrown, side effects)?
- [ ] Are preconditions weakened (or unchanged) and postconditions strengthened (or unchanged) in subtypes?
- [ ] Does the inheritance reflect "is-a" behaviorally, or just "shares-data-with"?

### ISP — Interface Segregation
- [ ] Does each implementer use *every* method on the interface, or are some unused?
- [ ] Would splitting the interface let consumers depend on only what they need?
- [ ] Are there `NotImplementedException` / `throw new NotSupportedException()` in implementers? That's ISP failing.

### DIP — Dependency Inversion
- [ ] Does the high-level class depend on a concrete low-level type, or on an abstraction?
- [ ] Does the abstraction live with the consumer (high-level), not the implementation?
- [ ] Are concrete types wired only at the composition root (DI container, `Program.cs`, `main`)?

## Review Checklist

Things to flag in a pull-request review:

- [ ] **Class is over ~300 lines or has > ~7 public methods.** Probably violates SRP. Ask the author what stakeholders drive changes.
- [ ] **`switch` on a type or string** in business logic. Often a missed OCP opportunity — extract a polymorphic abstraction.
- [ ] **`if (x is StripeProvider)`** or similar. Same — the abstraction leaked.
- [ ] **`throw new NotSupportedException()`** in an implementer. ISP smell.
- [ ] **High-level module imports a concrete from a low-level module.** DIP violation. The dependency direction should be inverted.
- [ ] **Subclass overrides every method of its parent.** Inheritance is wrong here — prefer composition.
- [ ] **`base.Method()` calls in overrides that *change* the result.** Likely LSP violation.
- [ ] **Test setup creates 5+ collaborators just to instantiate the SUT.** SRP failing — the SUT has too many responsibilities.
- [ ] **An interface has only one implementation that will never have a second.** Premature DIP — drop the interface or be honest that it's there for testing only.
- [ ] **DI registrations growing without bound.** Sign that the system is fragmenting into too-small classes; SRP can be over-applied.

## Production Readiness

SOLID is a *design* concern, but it shows up in production posture:

- [ ] **Tests exist and run fast.** A SOLID-correct module should be unit-testable in milliseconds.
- [ ] **Boundaries match deployment units.** Module/service boundaries should align with classes that genuinely have different reasons to change.
- [ ] **Provider/adapter classes have integration tests.** SOLID isolates business logic from I/O — but you still need to verify the I/O code talks to the real thing.
- [ ] **No reflection-based dispatch in hot paths.** DI containers and dynamic resolution are fine in setup; not on the request path.
- [ ] **Logging tags identify which implementation handled the request.** When `IPaymentProvider` failed, knowing it was Stripe vs PayPal saves 10 minutes at 3 AM.
- [ ] **Feature-flag / gradual rollout possible at the abstraction seam.** New `IPaymentProvider` implementation? Roll it out at 1% via flag, observe, ramp.
- [ ] **Failure modes documented per implementation.** Each adapter has its own quirks (timeouts, error codes, rate limits). Don't pretend they're identical.
