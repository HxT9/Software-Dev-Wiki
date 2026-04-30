# Wiki Conventions

Operational rules for writing and maintaining the wiki. Read this before adding or modifying topics.

---

## 1. Structure of a topic

Each leaf topic has **9 files + 1 folder**:

```
Topic_Name/
├── README.md              ← hub: frontmatter + overview + links to other files
├── When_To_Use.md         ← use cases, indicators, decision tree
├── Tradeoffs.md           ← pros/cons, performance, alternatives
├── Example_Simple.md      ← minimal example
├── Example_Real.md        ← production-like example
├── Diagrams.md            ← Mermaid / PlantUML / C4
├── Checklist.md           ← implementation, review, production readiness
├── Topic_AntiPatterns.md  ← anti-patterns *specific to this topic*
├── Notes.md               ← insights, edge cases, gotchas, open questions
└── Playground/            ← runnable code and mini projects
    └── README.md
```

### Anti-duplication rule

Each piece of information lives **in a single file**. The `README.md` is a **lightweight hub**: it contains frontmatter, overview, problem, key concepts, prerequisites, and **links** to detailed sections. If you find yourself writing a trade-off in the README, stop: it goes in `Tradeoffs.md`. If you're writing an example in the README, stop: it goes in `Example_Simple.md`.

### Minimal vs full topics

For simple topics you can fill only `README.md` + `Notes.md` and leave the rest as skeleton. For complex topics (e.g., `CQRS`, `Event_Sourcing`, `Kafka`) fill all 9 files.

---

## 2. YAML frontmatter (mandatory in `README.md`)

```yaml
---
title: <Topic Name>
section: <NN_Section_Name>          # e.g., 02_Architecture
status: stub                        # stub | draft | wip | reviewed | stable
difficulty: intermediate            # beginner | intermediate | advanced
tags: [tag1, tag2]                  # lower-kebab-case
prerequisites: []                   # other topic names
related: []                         # other topic names
last_updated: YYYY-MM-DD
reading_time_min: 10                # estimated minutes for full read
---
```

### Status workflow
- `stub`: only skeleton, no real content yet.
- `draft`: first pass underway, content incomplete.
- `wip`: actively in progress, structure defined.
- `reviewed`: complete and reviewed.
- `stable`: don't touch without good reason.

### Tags
- Lowercase, kebab-case (`event-driven`, not `EventDriven`).
- The scaffolder generates automatic tags from the path (section + subsections). Add cross-cutting thematic tags (e.g., `#performance`, `#security`).
- Each new tag must be added to [Tag_Index.md](./Tag_Index.md).

### Prerequisites & Related
- `prerequisites`: what to read **before** to understand the topic.
- `related`: related or complementary topics.
- Use the exact folder name (e.g., `Bounded_Context`).

---

## 3. Per-file conventions

### `README.md`
Mandatory sections: Overview, Problem, Key Concepts, Prerequisites, Deep Dives (links to other files), Related Topics, References.
**Do not duplicate** content that lives in other files. The links in "Deep Dives" are the entry points.

### `When_To_Use.md`
Sections: Use Cases, When to Use, When NOT to Use, Decision Tree (Mermaid), Real Scenarios.
The decision tree is optional but strongly recommended for architectural patterns.

### `Tradeoffs.md`
Sections: Benefits, Drawbacks, Performance Characteristics, Scalability, Maintainability, Operational Cost, Alternatives.
**Performance Characteristics**: fill in only the relevant fields. For an algorithmic topic, `Big O (Time)` will make sense; for an architecture topic, `Throughput` and `Latency` will. Remove the fields that don't apply.

### `Example_Simple.md`
Minimal, isolated, runnable example. One idea per example.
Specify the language in the code fence (` ```python `, ` ```rust `, etc.).

### `Example_Real.md`
Production-leaning example: error handling, observability, configuration, realistic dependencies. Link to `Diagrams.md` for the visualization.

### `Diagrams.md`
Inline Mermaid diagrams (preferred — renders on GitHub, Obsidian, VS Code). PlantUML only if Mermaid isn't enough. C4 model for architectures (Context → Container → Component → Code).

### `Checklist.md`
Three lists:
- **Implementation Checklist**: concrete steps.
- **Review Checklist**: what to look for in code review.
- **Production Readiness**: logging, metrics, alerting, tests, rollback, security.

### `Topic_AntiPatterns.md`
Anti-patterns **specific to this topic**. For each: Description, Why it's bad, Bad Example, Better Approach, Good Example.
For **generic** anti-patterns (God Object, Spaghetti Code, Premature Optimization, etc.) → [16_AntiPatterns/](../16_AntiPatterns/).

### `Notes.md`
Sections: Insights, Edge Cases, Gotchas, Open Questions.
This is the topic's "field journal". Things learned in practice, unresolved doubts, edge cases discovered.

### `Playground/`
Runnable mini projects. Each Playground has its own `README.md` with execution instructions. Language and stack at the author's discretion (preference: same stack as the author's real project).

---

## 4. Linking

- **Internal links**: always relative (e.g., `[Bounded Context](../20_DDD/Bounded_Context/)`).
- **Wiki-style links** (`[[Topic_Name]]`): allowed in placeholders, to be converted to relative links when real content is written.
- **External links**: always with description (`[article title](url) — author/site`).

---

## 5. Naming

- Folders and files: `PascalCase_Snake_Case` for topics (`Event_Sourcing`, `Modular_Monolith`).
- No spaces, no non-ASCII characters, no accents.
- Don't rename folders after a topic has been written: you'll break links.

---

## 6. Workflow to add a topic

1. Add the path to `TOPICS=( ... )` in `scaffold_topics.sh`.
2. Run `bash scaffold_topics.sh` (idempotent, doesn't overwrite).
3. Open the new topic's `README.md` and fill the frontmatter (status, tags, prerequisites).
4. Fill in the other files as the topic matures.
5. Update `00_Index/Roadmap.md` if the topic belongs to a study level.
6. Update `00_Index/Tag_Index.md` if you introduce a new tag.

---

## 7. Workflow to migrate the template

If the template changes in the future:
1. Update `scaffold_topics.sh` with the new template version.
2. Run `FORCE=1 bash scaffold_topics.sh` only if existing files are still skeletons (status `stub`).
3. If real content exists, write a targeted migration that preserves the content.

---

## 8. Anti-patterns of the wiki itself

Things NOT to do:
- **Duplicate content** between README and dedicated files.
- **Leave frontmatter incomplete** (status, tags, last_updated).
- **Write without prerequisites** if the topic requires them.
- **Code examples without language** specified in the code fence.
- **Diagrams via screenshots**: always Mermaid/PlantUML in plain text.
- **Generic anti-patterns** in `Topic_AntiPatterns.md`: those go in `16_AntiPatterns/`.
- **Rename folders** without updating links.
