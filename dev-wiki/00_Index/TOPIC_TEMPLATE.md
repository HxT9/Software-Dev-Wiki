# Topic Template

Canonical template for any topic in this wiki.

**How to use:**

1. Easy way: `python tools/wiki.py new <NN_Section>/<Topic_Name>` — creates the file from this template, with frontmatter pre-filled.
2. Manual: copy this file to `<NN_Section>/<Topic_Name>.md` and replace placeholders.

For **complex topics** that need a Playground, multiple language samples, or large diagrams, use a folder structure instead:

```
<NN_Section>/<Topic_Name>/
├── README.md          ← the topic content (this template)
├── Playground/        ← runnable code
└── images/            ← screenshots, exported diagrams
```

The default is a single file. Reach for the folder structure only when a single file would exceed ~1000 lines or when assets genuinely live alongside the prose.

---

## Required sections

Every topic file **must** include:

- **YAML frontmatter** with the required keys (see below) — including `tags:` as a YAML list. The MkDocs Material *tags plugin* turns each entry into a clickable chip at the top of the page that links to the [Tag_Index](./Tag_Index.md).
- `# <Title>` — H1 matching the file/folder name (with underscores → spaces).
- `## Overview` — one or two sentences. The shortest possible "what is this and why does it exist".

That's the bare minimum. A topic with status `stub` or `draft` may have just these.

**Note**: do not write a `## Tags` section at the bottom — the chips at the top, rendered from the frontmatter, are the canonical tag display.

## Optional sections

Add any of these as the topic matures. Order is canonical — keep the same order so readers can scan consistently across topics.

1. `## Problem` — what concrete issue this addresses.
2. `## Key Concepts` — definitions, brief.
3. `## Prerequisites` — what to read first.
4. `## When to Use`
5. `## When NOT to Use`
6. `## Trade-offs` — benefits, drawbacks, performance characteristics, alternatives.
7. `## Simple Example` — minimal runnable example.
8. `## Real World Example` — production-leaning code.
9. `## Diagrams` — Mermaid preferred.
10. `## Checklist` — implementation, review, production readiness.
11. `## Topic Anti-Patterns` — misapplications specific to this topic. (Generic anti-patterns live in [16_AntiPatterns/](../16_AntiPatterns/).)
12. `## Notes` — insights, edge cases, gotchas, open questions.
13. `## Related Topics`
14. `## References` — links to books, articles, talks.

(There is no `## Tags` section at the bottom: the tags plugin renders chips at the top from the frontmatter.)

---

## Required frontmatter

```yaml
---
title: <Topic Name>
section: <NN_Section_Name>          # e.g., 01_Foundations
status: stub                        # stub | draft | wip | reviewed | stable
difficulty: intermediate            # beginner | intermediate | advanced
tags: []                            # lower-kebab-case, no spaces
last_updated: YYYY-MM-DD
---
```

## Optional frontmatter

```yaml
prerequisites: []                   # other topic names (folder names)
related: []                         # other topic names
reading_time_min: 10
```

---

## Skeleton — copy from here

Below is the skeleton you can copy and prune. Remove sections you're not filling.

```markdown
---
title: <Topic Name>
section: <NN_Section_Name>
status: stub
difficulty: intermediate
tags: []
last_updated: YYYY-MM-DD
---

# <Topic Name>

## Overview

One or two sentences explaining what this topic is and why it exists.

## Problem

What concrete issue this addresses.

## Key Concepts

- ...
- ...

## Prerequisites

- [[OtherTopic]]

## When to Use

- ...

## When NOT to Use

- ...

## Trade-offs

### Benefits
- ...

### Drawbacks
- ...

### Performance Characteristics
> Fill in only fields that apply.
- Throughput / Latency / Memory / Big O / Network overhead / Storage overhead

### Alternatives
- ...

## Simple Example

```python
# Minimal, runnable code
```

## Real World Example

```python
# Production-leaning code
```

## Diagrams

```mermaid
graph LR
  A --> B
```

## Checklist

### Implementation
- [ ] ...

### Review
- [ ] ...

### Production Readiness
- [ ] Logging / metrics / alerting / tests / failure modes / rollback

## Topic Anti-Patterns

### <Anti-Pattern Name>
**Description.** ...
**Why it's bad.** ...
**Better approach.** ...

## Notes

### Insights
- ...

### Edge Cases
- ...

### Gotchas
- ...

### Open Questions
- ...

## Related Topics

- [[OtherTopic]]

## References

- [Reference title](https://example.com) — author/site.
```

---

## Status workflow

- **stub** — frontmatter + title + overview placeholder. Listed in [PROPOSED_TOPICS.md](./PROPOSED_TOPICS.md).
- **draft** — first pass written, content incomplete.
- **wip** — actively in progress.
- **reviewed** — complete and reviewed.
- **stable** — settled, no need to revisit without a reason.

When a topic's status flips to `draft` or higher, also update its line in [PROPOSED_TOPICS.md](./PROPOSED_TOPICS.md) — change ⬜ to ✅.
