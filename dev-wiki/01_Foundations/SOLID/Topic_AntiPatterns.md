# Topic Anti-Patterns - SOLID

> Anti-patterns *specific to SOLID*.
> For generic anti-patterns (God Object, Spaghetti Code, etc.) see [16_AntiPatterns](../../16_AntiPatterns/).

## Interface for everything

**Description**
Creating an interface for every class "just in case" we'll need a second implementation. The interface has exactly one implementer, will never have a second, and forces every test or caller to chase one extra layer of indirection.

**Why it's bad**
- Adds files, types, and import statements with zero benefit.
- Makes navigation worse (Go to Definition lands on the interface, not the code).
- Hides simple value classes behind a façade that suggests polymorphism that doesn't exist.
- Violates YAGNI in the name of SOLID — the wrong kind of religious adherence.

**Bad Example**

```csharp
// One implementation, will never have another.
public interface IUser
{
    string Name { get; }
    int    Age  { get; }
}

public class User : IUser
{
    public string Name { get; init; }
    public int    Age  { get; init; }
}
```

**Better Approach**
Use the concrete type. Add the interface *when* the second implementation arrives (or when a test needs to fake the dependency — that's a real reason).

**Good Example**

```csharp
public sealed record User(string Name, int Age);
```

---

## "I made it SOLID" by sprinkling interfaces

**Description**
A refactor adds `IFoo` for every class but the underlying coupling and responsibilities are unchanged. The system is now wider (more types) and exactly as tangled, but the team feels accomplished because there are interfaces.

**Why it's bad**
SOLID isn't about syntax (interfaces, DI). It's about *structure* — what depends on what, and what changes for what reason. Adding an interface in front of an unchanged class doesn't fix coupling.

**Bad Example**

```csharp
// God class, just with an interface in front.
public interface IOrderService { /* 30 methods */ }

public class OrderService : IOrderService
{
    public void Validate(Order o) { /* ... */ }
    public void CalculateTax(Order o) { /* ... */ }
    public void ApplyDiscount(Order o) { /* ... */ }
    public void ChargeCustomer(Order o) { /* ... */ }
    public void SendConfirmationEmail(Order o) { /* ... */ }
    public void UpdateInventory(Order o) { /* ... */ }
    // ...
}
```

**Better Approach**
Split by responsibility *first*, then introduce abstractions where you actually need them. The interface count is a side effect, not the goal.

---

## Wrong-direction DIP (cosmetic abstraction)

**Description**
DIP says "depend on abstractions, not concretions" — but the abstraction must be **owned by the high-level module** and must express **its** vocabulary. A common failure: introducing an interface that mirrors the low-level module's API exactly. The dependency direction is unchanged; you've just renamed `PostgresClient` to `IPostgresClient`.

**Why it's bad**
- Doesn't actually invert the dependency. The high level still depends on a low-level shape.
- If you swap the underlying tech (Postgres → Mongo), the interface itself has to change — the whole point was to avoid that.

**Bad Example**

```csharp
// "I added an interface" — but it leaks postgres concepts.
public interface IPostgresClient
{
    NpgsqlCommand CreateCommand(string sql);
    NpgsqlDataReader ExecuteReader(NpgsqlCommand cmd);
}
```

**Better Approach**
Frame the abstraction in the high-level module's language: orders, queries, transactions — not connections, commands, readers.

**Good Example**

```csharp
public interface IOrderRepository
{
    Task<Order?> FindByIdAsync(OrderId id, CancellationToken ct);
    Task SaveAsync(Order order, CancellationToken ct);
}
```

---

## SRP taken to atomic level (one method per class)

**Description**
"One reason to change" misread as "one method." Every class has a single `Execute()` method; every operation becomes a "Handler" or "UseCase" class. The codebase has 400 single-method classes and finding anything is impossible.

**Why it's bad**
- Cohesion suffers — methods that work on the same data are now in different files.
- Navigation cost explodes; reading the flow of a feature requires opening 12 classes.
- Real responsibilities split arbitrarily; nothing is *more* SRP-correct, just more fragmented.

**Better Approach**
SRP is about a *responsibility* — a coherent area of behavior, not a single line of code. A class with 5-7 methods that all manipulate the same state is fine.

---

## LSP violation via inheritance ("Square is-a Rectangle")

**Description**
Modeling subtype relationships purely on shared *fields* instead of shared *behavior*. The classic: `Square extends Rectangle`. A `Rectangle` setter for width and height are independent; for `Square` they aren't — assigning width must also change height. Code that operates on `Rectangle` and assumes width/height are independent breaks for `Square`.

**Why it's bad**
- The compiler accepts the substitution but the contract is silently violated.
- Bugs surface far from the cause, in code that doesn't know `Square` exists.
- The reflex fix ("override the setters") doesn't restore the contract — it just changes how the violation manifests.

**Better Approach**
- Composition: a `Shape` has a `BoundingBox`, with constraints applied independently.
- Or two unrelated types — `Square` and `Rectangle` are different things in code, even if math says one is a special case of the other.

---

## ISP via marker interfaces and capability inquiry

**Description**
Adding empty marker interfaces (`IRefundable`, `IDeletable`, ...) that consumers check at runtime via `is`/`as` to decide what to do.

**Why it's bad**
- Defeats the type system's ability to enforce capabilities at compile time.
- Spreads capability-check logic across consumers instead of locating it once.
- Often hides a missing parameter — the *call* should be made via the right interface, not via a runtime cast.

**Better Approach**
Pass the right interface in. If a method needs refund capability, accept `IRefundable`, not "an `IPayment` you check at runtime."

---

## Related Smells

- **Shotgun surgery** (a single change requires edits in many places): often signals broken SRP or OCP.
- **Feature envy** (a method uses another class's data more than its own): often signals a missing class or a misplaced responsibility — SRP at field-level.
- **Refused bequest** (subclass overrides most of the parent or throws on inherited methods): LSP smell — composition is probably the right answer.
- **Cyclic dependencies between modules**: usually a DIP violation — the abstraction is in the wrong place.
- **Test setup with 5+ mocks**: SRP and ISP failing simultaneously.
