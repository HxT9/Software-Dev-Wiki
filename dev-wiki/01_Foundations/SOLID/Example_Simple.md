# Simple Example - SOLID

## Goal

Show **SRP** (Single Responsibility Principle) in action with a tiny, focused refactor that doubles as the gateway drug to the other four principles.

## Explanation

The classic SRP smell: a single class does **calculation**, **formatting**, and **persistence**. Each of those will change for different reasons, driven by different stakeholders:

- *Calculation* changes when business rules change (driven by product/finance).
- *Formatting* changes when presentation requirements change (driven by UX/marketing).
- *Persistence* changes when storage tech changes (driven by infra/ops).

Three "reasons to change" living inside one class is the textbook SRP violation. The refactor splits into three classes, each owning one concern. Bonus: testing each becomes trivial.

## Code

### Before — one class, three responsibilities

```csharp
public class SalesReport
{
    public decimal CalculateTotal(IEnumerable<Sale> sales)
    {
        return sales.Sum(s => s.Amount * (1 - s.DiscountRate));
    }

    public string FormatAsHtml(decimal total)
    {
        return $"<h1>Sales report</h1><p>Total: <b>{total:C}</b></p>";
    }

    public void SaveToFile(string content, string path)
    {
        File.WriteAllText(path, content);
    }

    public void GenerateAndSave(IEnumerable<Sale> sales, string path)
    {
        var total = CalculateTotal(sales);
        var html  = FormatAsHtml(total);
        SaveToFile(html, path);
    }
}
```

What's wrong:

- A change to discount rules forces redeployment of code that also handles HTML and file I/O.
- A unit test for the calculation has to construct an instance that knows about the file system.
- Switching to PDF output, or to S3 instead of disk, means editing this class — possibly breaking the calculation tests in the process.

### After — three small classes, each with one reason to change

```csharp
public class SalesCalculator
{
    public decimal Total(IEnumerable<Sale> sales)
        => sales.Sum(s => s.Amount * (1 - s.DiscountRate));
}

public class SalesHtmlFormatter
{
    public string Format(decimal total)
        => $"<h1>Sales report</h1><p>Total: <b>{total:C}</b></p>";
}

public interface IReportSink
{
    void Write(string content);
}

public class FileReportSink : IReportSink
{
    private readonly string _path;
    public FileReportSink(string path) => _path = path;
    public void Write(string content) => File.WriteAllText(_path, content);
}

public class SalesReportService
{
    private readonly SalesCalculator   _calc;
    private readonly SalesHtmlFormatter _fmt;
    private readonly IReportSink        _sink;

    public SalesReportService(SalesCalculator calc, SalesHtmlFormatter fmt, IReportSink sink)
        => (_calc, _fmt, _sink) = (calc, fmt, sink);

    public void Generate(IEnumerable<Sale> sales)
    {
        var total = _calc.Total(sales);
        var html  = _fmt.Format(total);
        _sink.Write(html);
    }
}
```

The refactor incidentally introduces **DIP** (`SalesReportService` depends on `IReportSink`, an abstraction) and sets up **OCP** (a new sink — S3, email, stdout — plugs in without changing `SalesReportService`).

## Key Takeaways

- "Reason to change" is the SRP test. If two stakeholders drive changes to the same class, it has too many responsibilities.
- The refactor is small. Three classes of ~5 lines each are not "more complex" than one class of 25 lines — they're easier to read, test, and change.
- SRP often pulls DIP and OCP along for free. Apply one, and seams for the others appear naturally.
- The test for `SalesCalculator` no longer touches the file system, no longer mocks anything, runs in microseconds. That's the payoff.
