# ADR-0001 - Wiki Structure and Conventions

## Status
Accepted

## Date
2026-04-29

## Context

Serve una wiki centralizzata di software development per programmatori intermedio/avanzato che raccolga in un unico posto:
- spiegazioni teoriche chiare e mirate,
- esempi pratici (semplici + production-like),
- trade-off, anti-pattern, decisioni architetturali documentate,
- snippet riutilizzabili e mini progetti dimostrativi.

Vincoli e forze in gioco:
- **Scalabilità**: la wiki deve crescere a centinaia di topic senza diventare caos.
- **Coerenza**: ogni topic deve avere una struttura prevedibile per facilitare lettura e ricerca.
- **Manutenibilità**: il template deve evitare duplicazione di contenuti.
- **Automazione futura**: navigazione per tag, filtri per stato di scrittura, roadmap dinamica devono essere possibili senza riscrivere tutto.
- **Onboarding**: chi entra deve capire dove mettere cosa in 5 minuti.

## Decision

### Struttura top-level (28 sezioni)

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
├── 16_AntiPatterns/   ← anti-pattern *generici*
├── 17_Real_World/     ← case studies, postmortems
├── 18_Snippets/
├── 19_ADR/            ← decisioni architetturali (questo file ne è ADR-0001)
├── 20_DDD/
├── 21_Cloud_Native/
├── 22_AI_ML_Integration/
├── 23_Resilience_Engineering/
├── 24_Data_Engineering/
├── 25_Documentation/
├── 26_Refactoring/
└── 99_Resources/
```

### Template per topic foglia (9 file + Playground/)

```
Topic_Name/
├── README.md              ← hub: frontmatter YAML + overview + link
├── When_To_Use.md         ← casi d'uso, indicatori, decision tree (Mermaid)
├── Tradeoffs.md           ← pro/contro, performance characteristics, alternative
├── Example_Simple.md      ← esempio minimale eseguibile
├── Example_Real.md        ← esempio production-like
├── Diagrams.md            ← Mermaid / PlantUML / C4
├── Checklist.md           ← implementation, review, production readiness
├── Topic_AntiPatterns.md  ← anti-pattern *specifici di questo topic*
├── Notes.md               ← insights, edge cases, gotchas, open questions
└── Playground/            ← codice eseguibile
```

### Regole chiave

1. **Anti-duplicazione**: il `README.md` è un hub leggero. Ogni informazione vive in **un solo file**.
2. **Frontmatter YAML obbligatorio** in `README.md` (`title`, `section`, `status`, `difficulty`, `tags`, `prerequisites`, `related`, `last_updated`, `reading_time_min`).
3. **Tag auto-derivati dal path** + tag tematici trasversali manuali.
4. **Anti-pattern generici** in `16_AntiPatterns/`. **Anti-pattern del topic** in `Topic_AntiPatterns.md`.
5. **Topic minimi vs completi**: per topic semplici basta `README.md` + `Notes.md`; gli altri file restano scheletro.
6. **Diagrammi sempre in plain text** (Mermaid preferito), mai screenshot.
7. **Naming**: `PascalCase_Snake_Case`, inglese, niente accenti né spazi.
8. **Scaffolder idempotente**: `scaffold_topics.sh` non sovrascrive di default; `FORCE=1` per migrazioni.

Le regole operative complete sono in [`00_Index/CONVENTIONS.md`](../00_Index/CONVENTIONS.md).

## Consequences

### Positive
- Struttura prevedibile: chiunque trovi un topic sa già dove sono trade-off, esempi, antipattern.
- Frontmatter YAML abilita automazione futura (tag index dinamico, filtro per status, ecc.).
- 28 sezioni top-level con numerazione fissa danno ordine visivo immediato.
- Scaffolder + lista `TOPICS=()` rende l'aggiunta di nuovi topic una riga di codice.
- Migrazioni del template gestibili tramite `FORCE=1`.

### Negative
- 9 file per topic = molta scaffoldatura iniziale. 337 topic × 9 file = ~3000 file di skeleton. Onere visivo per chi naviga le cartelle prima che siano scritti.
- Frontmatter va mantenuto a mano: rischio drift se non c'è un linter.
- I link interni `[[Topic_Name]]` placeholder vanno convertiti in path relativi quando si scrive contenuto vero — facile dimenticarsene.

### Neutral
- La distinzione `Topic_AntiPatterns.md` vs `16_AntiPatterns/` richiede disciplina nel decidere dove va una cosa.
- L'aggiunta di sezioni 20-26 (DDD, Cloud Native, AI/ML, ecc.) è una scelta opinionated che si discosta dalle wiki tradizionali ma riflette le esigenze 2026.

## Alternatives considered

- **File unico per topic** (`Topic.md` con tutte le sezioni in un solo file): più snello, ma diventa ingestibile per topic complessi (CQRS, Event Sourcing, Kafka). Scartato.
- **Notion / Confluence / GitBook**: comodi per editing, ma lock-in, no version control granulare, no `grep`. Scartato a favore di Markdown su filesystem.
- **Categorie aggiuntive come sotto-sezioni** (es. DDD dentro 02_Architecture): perde visibilità. Scartato a favore di top-level dedicato.
- **Solo template a 7 file** (versione iniziale, senza Diagrams/Checklist): mancavano i diagrammi (cruciali per architettura) e la checklist di production readiness. Sostituito dal template a 9 file.
- **README.md con tutto in un file**: causava duplicazione massiccia con When_To_Use/Tradeoffs/Examples. Sostituito dall'approccio "README come hub".

## Notes

- Questo ADR sostituisce il documento `WIKI_PLAN.md` originale (rimosso dalla root del repo).
- Future modifiche strutturali (es. aggiunta di nuove sezioni top-level, cambio template) richiederanno un nuovo ADR che superseda parti di questo.
- Lo scaffolder è in `scaffold_topics.sh` e `scaffold_specials.sh` nella root del progetto.
