# ADR-0001 - Wiki Structure and Conventions

## Status
Accepted

## Date
2026-04-29

## Context

A centralized software development wiki is needed for intermediate/advanced programmers, gathering in one place:
- clear, focused theoretical explanations,
- practical examples (simple + production-like),
- documented trade-offs, anti-patterns, architectural decisions,
- reusable snippets and runnable mini projects.

Constraints and forces at play:
- **Scalability**: the wiki must grow to hundreds of topics without becoming chaotic.
- **Consistency**: each topic must follow a predictable structure to make reading and search easier.
- **Maintainability**: the template must avoid content duplication.
- **Future automation**: tag-based navigation, filters by writing status, dynamic roadmap must all be possible without rewriting everything.
- **Onboarding**: a newcomer should understand where everything goes within 5 minutes.

## Decision

### Top-level structure (28 sections)

```
dev-wiki/
├── 00_Index/         ← entry point: README, Roadmap, Tag_Index, CONVENTIONS
├── 01_Foundations/
├── 02_Architecture/
├── 03_Design_Patterns/
├── 04_Concurrency/
├── 05_Distributed_Systems/
├── 06_Data_Storage/
├── 07_Networking/
├── 08_Security/
├── 09_Testing/
├── 10_DevOps/
├── 11_Performance/
├── 12_Observability/
├── 13_Integration/
├── 14_Languages/      ← C, Cpp, CSharp, Python, Rust, TypeScript, Java
├── 15_Algorithms_DataStructures/
├── 16_AntiPatterns/   ← *generic* anti-patterns
├── 17_Real_World/     ← case studies, postmortems
├── 18_Snippets/
├── 19_ADR/            ← architectural decisions (this file is ADR-0001)
├── 20_DDD/
├── 21_Cloud_Native/
├── 22_AI_ML_Integration/
├── 23_Resilience_Engineering/
├── 24_Data_Engineering/
├── 25_Documentation/
├── 26_Refactoring/
└── 99_Resources/
```

### Per-topic template (9 files + Playground/)

```
Topic_Name/
├── README.md              ← hub: YAML frontmatter + overview + links
├── When_To_Use.md         ← use cases, indicators, decision tree (Mermaid)
├── Tradeoffs.md           ← pros/cons, performance characteristics, alternatives
├── Example_Simple.md      ← minimal runnable example
├── Example_Real.md        ← production-like example
├── Diagrams.md            ← Mermaid / PlantUML / C4
├── Checklist.md           ← implementation, review, production readiness
├── Topic_AntiPatterns.md  ← anti-patterns *specific to this topic*
├── Notes.md               ← insights, edge cases, gotchas, open questions
└── Playground/            ← runnable code
```

### Key rules

1. **Anti-duplication**: the `README.md` is a lightweight hub. Each piece of information lives in **one file only**.
2. **Mandatory YAML frontmatter** in `README.md` (`title`, `section`, `status`, `difficulty`, `tags`, `prerequisites`, `related`, `last_updated`, `reading_time_min`).
3. **Auto-derived path tags** + manually added cross-cutting thematic tags.
4. **Generic anti-patterns** go in `16_AntiPatterns/`. **Topic-specific anti-patterns** go in `Topic_AntiPatterns.md`.
5. **Minimal vs full topics**: simple topics need only `README.md` + `Notes.md`; the rest stays as skeleton.
6. **Diagrams always in plain text** (Mermaid preferred), never screenshots.
7. **Naming**: `PascalCase_Snake_Case`, English, no accents or spaces.
8. **Idempotent scaffolder**: `scaffold_topics.sh` doesn't overwrite by default; `FORCE=1` for migrations.

The full operational rules are in [`00_Index/CONVENTIONS.md`](../00_Index/CONVENTIONS.md).

## Consequences

### Positive
- Predictable structure: anyone landing on a topic immediately knows where trade-offs, examples, and anti-patterns are.
- YAML frontmatter enables future automation (dynamic tag index, filter by status, etc.).
- 28 top-level sections with fixed numbering provide instant visual order.
- Scaffolder + `TOPICS=()` list makes adding a new topic a one-line change.
- Template migrations are manageable via `FORCE=1`.

### Negative
- 9 files per topic = a lot of initial scaffolding. 337 topics × 9 files ≈ 3,000 skeleton files. Visual overhead when browsing folders before content is written.
- Frontmatter must be maintained by hand: drift risk without a linter.
- Placeholder wiki-style links `[[Topic_Name]]` need to be converted to relative paths when real content is written — easy to forget.

### Neutral
- The distinction `Topic_AntiPatterns.md` vs `16_AntiPatterns/` requires discipline when deciding where something belongs.
- Adding sections 20-26 (DDD, Cloud Native, AI/ML, etc.) is an opinionated choice that diverges from traditional wikis but reflects 2026 needs.

## Alternatives considered

- **Single file per topic** (`Topic.md` with all sections in one file): leaner, but unmanageable for complex topics (CQRS, Event Sourcing, Kafka). Rejected.
- **Notion / Confluence / GitBook**: convenient for editing, but lock-in, no granular version control, no `grep`. Rejected in favor of Markdown on the filesystem.
- **Additional categories as sub-sections** (e.g., DDD under 02_Architecture): loses visibility. Rejected in favor of a dedicated top-level section.
- **Initial 7-file template** (without Diagrams/Checklist): missing diagrams (crucial for architecture) and a production readiness checklist. Replaced by the 9-file template.
- **README.md with everything in one file**: caused massive duplication with When_To_Use/Tradeoffs/Examples. Replaced by the "README as hub" approach.

## Notes

- This ADR replaces the original `WIKI_PLAN.md` document (removed from the repo root).
- Future structural changes (e.g., new top-level sections, template change) will require a new ADR that supersedes parts of this one.
- The scaffolder lives in `scaffold_topics.sh` and `scaffold_specials.sh` at the project root.
