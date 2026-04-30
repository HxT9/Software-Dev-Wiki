# Wiki Conventions

Operational rules for writing and maintaining the wiki. Read this before adding or modifying topics.

---

## 1. Structure of a topic

The default layout is a **single Markdown file** named after the topic:

```
01_Foundations/
├── README.md              ← section README (intro + decision guide + topic list)
├── SOLID.md               ← single-file topic
└── DRY_KISS_YAGNI.md      ← single-file topic
```

For **complex topics** that need a Playground, multiple language samples, exported diagrams, or attachments, opt into the folder layout:

```
01_Foundations/
└── SOLID/
    ├── README.md          ← the topic content (with frontmatter)
    ├── Playground/        ← runnable code
    └── images/            ← screenshots, exported diagrams
```

The single-file layout is the default. Reach for the folder structure only when assets genuinely live alongside the prose, or when the file would exceed ~1000 lines.

### Section-level structure

Each top-level section folder (`01_Foundations/`, `02_Architecture/`, ...) contains a single `README.md` that is the section's **landing page**. It has three parts:

1. **Overview** — what unifies the topics in this section.
2. **When to reach for what** — a decision guide mapping symptoms to topics.
3. **Topics in this section** — written topics linked, proposed topics shown as `code` references.

### Topic proposal flow

Topics that aren't written yet **don't have a folder**. They live as line items in [PROPOSED_TOPICS.md](./PROPOSED_TOPICS.md) (master list) and as `code` references in section READMEs.

To create a new topic from the template:

```bash
python tools/wiki.py new 02_Architecture/CQRS               # single file
python tools/wiki.py new 02_Architecture/CQRS --folder      # folder with Playground/
```

The canonical template lives in [TOPIC_TEMPLATE.md](./TOPIC_TEMPLATE.md).

---

## 2. YAML frontmatter

### Required keys

```yaml
---
title: <Topic Name>
section: <NN_Section_Name>          # e.g., 02_Architecture
status: stub                        # stub | draft | wip | reviewed | stable
difficulty: intermediate            # beginner | intermediate | advanced
tags: [tag1, tag2]                  # lower-kebab-case, no spaces
last_updated: YYYY-MM-DD
---
```

### Optional keys

```yaml
prerequisites: [Other_Topic]        # other topic names
related: [Other_Topic]              # other topic names
reading_time_min: 10                # estimated minutes for full read
```

### Status workflow
- `stub`: skeleton only.
- `draft`: first pass written, content incomplete.
- `wip`: actively in progress.
- `reviewed`: complete and reviewed.
- `stable`: settled, don't touch without reason.

When a topic moves out of `stub`, also update its line in [PROPOSED_TOPICS.md](./PROPOSED_TOPICS.md) (⬜ → ✅).

### Tags
- Lowercase, kebab-case (`event-driven`, not `EventDriven`).
- The MkDocs Material *tags plugin* renders each tag in the frontmatter as a clickable chip at the top of the page that links to the [Tag_Index](./Tag_Index.md), where pages are grouped by tag.
- Do **not** write a `## Tags` section at the bottom of a file — the chips are the canonical display.
- Common tags are listed in [Tag_Index.md](./Tag_Index.md). Reuse before minting new ones.

### Prerequisites & Related
- `prerequisites`: what to read **before** to understand the topic.
- `related`: related or complementary topics.
- Use the exact folder name (e.g., `Bounded_Context`).

---

## 3. Section ordering inside a topic

Required content (every topic):
- Frontmatter (see above).
- `# <Title>` — H1 matching the topic name (with underscores → spaces).
- `## Overview` — one or two sentences.

Optional sections, in canonical order (so readers can scan consistently):

1. `## Problem`
2. `## Key Concepts`
3. `## Prerequisites`
4. `## When to Use`
5. `## When NOT to Use`
6. `## Trade-offs` — with sub-sections Benefits / Drawbacks / Performance Characteristics / Alternatives.
7. `## Simple Example` — minimal runnable code.
8. `## Real World Example` — production-leaning code.
9. `## Diagrams` — Mermaid preferred.
10. `## Checklist` — Implementation / Review / Production Readiness.
11. `## Topic Anti-Patterns` — misapplications specific to this topic.
12. `## Notes` — Insights / Edge Cases / Gotchas / Open Questions.
13. `## Related Topics`
14. `## References`

A topic with status `stub` may have just frontmatter + title + Overview. As status moves through `draft → wip → reviewed`, fill in the optional sections that earn their place.

### Notes per section

- **Examples**: always specify the language in the code fence (` ```python `, ` ```csharp `, etc.).
- **Diagrams**: prefer inline Mermaid (renders on GitHub, Obsidian, MkDocs). Use PlantUML or C4 model when Mermaid isn't enough.
- **Anti-patterns**: keep this section *topic-specific*. Generic anti-patterns (God Object, Spaghetti Code, Premature Optimization) live in [16_AntiPatterns/](../16_AntiPatterns/).
- **Performance Characteristics**: fill only the rows that apply. For algorithmic topics, `Big O (Time)`; for architecture, `Throughput` and `Latency`.

### Folder-style topics

When a topic uses the folder layout, the `README.md` carries everything described above. Sub-folders like `Playground/` and `images/` hold ancillary content. The Playground folder must include its own `README.md` with execution instructions.

---

## 4. Linking

- **Internal links**: always relative (e.g., `[Bounded Context](../20_DDD/Bounded_Context/)`).
- **Wiki-style links** (`[[Topic_Name]]`): allowed in placeholders, to be converted to relative links when real content is written.
- **External links**: always include a description, e.g. `[Article title](https://example.com/article) — author/site`.

---

## 5. Naming

- Folders and files: `PascalCase_Snake_Case` for topics (`Event_Sourcing`, `Modular_Monolith`).
- No spaces, no non-ASCII characters, no accents.
- Don't rename folders after a topic has been written: you'll break links.

---

## 6. Workflow to add a topic

1. Run `python tools/wiki.py new <Section>/<Topic_Name>` (or add `--folder` for the folder layout).
2. Edit the created file: set `tags`, write the Overview, set `status` to `draft` once content starts.
3. Update [PROPOSED_TOPICS.md](./PROPOSED_TOPICS.md) — flip ⬜ to ✅ for the new topic.
4. Add a link to the topic from the section's `README.md` (replace the `code` reference with a real link).
5. Update [Roadmap.md](./Roadmap.md) if the topic belongs to a study level.

The Tag_Index updates itself — the MkDocs Material *tags plugin* picks up `tags:` from frontmatter on each build.

---

## 7. Tooling

- `python tools/wiki.py status` — dashboard of topics by status.
- `python tools/wiki.py next [SECTION]` — pick a stub to write next.
- `python tools/wiki.py lint` — validate frontmatter on every topic.
- `python tools/wiki.py links` — find broken relative links.
- `python tools/wiki.py new <Section>/<Topic>` — create a topic from the template.
- `python tools/wiki.py touch <file>` — refresh `last_updated` to today (also runs as a git pre-commit hook).
- `bash tools/install_hooks.sh` — install the pre-commit hook (run once after cloning).

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
