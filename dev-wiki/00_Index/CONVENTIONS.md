# Wiki Conventions

Convenzioni operative per scrivere e mantenere la wiki. Leggile prima di aggiungere o modificare topic.

---

## 1. Struttura di un topic

Ogni topic foglia ha **9 file + 1 cartella**:

```
Topic_Name/
├── README.md              ← hub: frontmatter + overview + link agli altri file
├── When_To_Use.md         ← casi d'uso, indicatori, decision tree
├── Tradeoffs.md           ← pro/contro, performance, alternative
├── Example_Simple.md      ← esempio minimale
├── Example_Real.md        ← esempio production-like
├── Diagrams.md            ← Mermaid / PlantUML / C4
├── Checklist.md           ← implementazione, review, production readiness
├── Topic_AntiPatterns.md  ← anti-pattern *specifici di questo topic*
├── Notes.md               ← insights, edge case, gotchas, open questions
└── Playground/            ← codice eseguibile e mini progetti
    └── README.md
```

### Regola anti-duplicazione

Ogni informazione vive **in un solo file**. Il `README.md` è un **hub leggero**: contiene frontmatter, overview, problem, key concepts, prerequisites e **link** alle sezioni dettagliate. Se trovi che stai scrivendo un trade-off nel README, fermati: va in `Tradeoffs.md`. Se stai scrivendo un esempio nel README, fermati: va in `Example_Simple.md`.

### Topic minimi vs completi

Per topic semplici puoi tenere riempiti solo `README.md` + `Notes.md` e lasciare gli altri file con il loro skeleton. Per topic complessi (es. `CQRS`, `Event_Sourcing`, `Kafka`) compila tutti e 9 i file.

---

## 2. Frontmatter YAML (obbligatorio in `README.md`)

```yaml
---
title: <Topic Name>
section: <NN_Section_Name>          # es: 02_Architecture
status: stub                        # stub | draft | wip | reviewed | stable
difficulty: intermediate            # beginner | intermediate | advanced
tags: [tag1, tag2]                  # lower-kebab-case
prerequisites: []                   # nomi di altri topic
related: []                         # nomi di altri topic
last_updated: YYYY-MM-DD
reading_time_min: 10                # stima minuti per lettura completa
---
```

### Status workflow
- `stub`: solo skeleton, nessun contenuto reale.
- `draft`: prima stesura in corso, contenuto incompleto.
- `wip`: in lavorazione attiva, struttura definita.
- `reviewed`: completo e revisionato.
- `stable`: non si tocca più senza motivo.

### Tags
- Tutti minuscoli, in kebab-case (`event-driven`, non `EventDriven`).
- Lo scaffolder genera tag automatici dal path (sezione + sottosezioni). Aggiungi tag tematici trasversali (es. `#performance`, `#security`).
- Ogni tag nuovo va aggiunto in [Tag_Index.md](./Tag_Index.md).

### Prerequisites & Related
- `prerequisites`: cosa va letto **prima** per capire il topic.
- `related`: topic correlati o complementari.
- Usa esattamente il nome cartella (es. `Bounded_Context`).

---

## 3. Convenzioni per file

### `README.md`
Sezioni obbligatorie: Overview, Problem, Key Concepts, Prerequisites, Approfondimenti (link agli altri file), Related Topics, References.
**Non duplicare** contenuti che vivono negli altri file. I link in "Approfondimenti" sono il punto di accesso.

### `When_To_Use.md`
Sezioni: Use Cases, When to Use, When NOT to Use, Decision Tree (Mermaid), Real Scenarios.
Il decision tree è opzionale ma fortemente consigliato per pattern architetturali.

### `Tradeoffs.md`
Sezioni: Benefits, Drawbacks, Performance Characteristics, Scalability, Maintainability, Operational Cost, Alternatives.
**Performance Characteristics**: riempi solo i campi rilevanti. Per un topic algoritmico avrà senso `Big O (Time)`; per un'architettura avrà senso `Throughput` e `Latency`. Rimuovi i campi che non si applicano.

### `Example_Simple.md`
Esempio minimale, isolato, eseguibile. Una sola idea per esempio.
Specifica il linguaggio nel code fence (` ```python `, ` ```rust `, ecc.).

### `Example_Real.md`
Esempio production-like: error handling, observability, configurazione, dipendenze realistiche. Linka `Diagrams.md` per la visualizzazione.

### `Diagrams.md`
Diagrammi Mermaid in linea (preferito perché renderizza su GitHub/Obsidian/VS Code). PlantUML solo se Mermaid non basta. C4 model per architetture (Context → Container → Component → Code).

### `Checklist.md`
Tre liste:
- **Implementation Checklist**: step concreti.
- **Review Checklist**: cosa controllare in code review.
- **Production Readiness**: logging, metriche, alerting, test, rollback, security.

### `Topic_AntiPatterns.md`
Anti-pattern **specifici del topic**. Per ogni anti-pattern: Description, Why it's bad, Example sbagliato, Better Approach, Example corretto.
Per anti-pattern **generici** (God Object, Spaghetti Code, Premature Optimization, ecc.) → [16_AntiPatterns/](../16_AntiPatterns/).

### `Notes.md`
Sezioni: Insights, Edge Cases, Gotchas, Open Questions.
È il "diario di bordo" del topic. Cose imparate sul campo, dubbi non risolti, edge case scoperti.

### `Playground/`
Mini progetti eseguibili. Ogni Playground ha un suo `README.md` con istruzioni di esecuzione. Linguaggio e stack a discrezione di chi scrive (preferenza: stessa stack del progetto reale dell'autore).

---

## 4. Linking

- **Link interni**: sempre relativi (es. `[Bounded Context](../20_DDD/Bounded_Context/)`).
- **Link wiki-style** (`[[Topic_Name]]`): consentiti nei placeholder, da convertire in link relativi quando si scrive contenuto vero.
- **Link esterni**: sempre con descrizione (`[titolo articolo](url) — autore/sito`).

---

## 5. Naming

- Cartelle e file: `PascalCase_Snake_Case` per i topic (`Event_Sourcing`, `Modular_Monolith`).
- Niente spazi, niente caratteri non-ASCII, niente accenti.
- Non rinominare cartelle dopo che il topic è stato scritto: rompi i link.

---

## 6. Workflow per aggiungere un topic

1. Aggiungi il path al `TOPICS=( ... )` in `scaffold_topics.sh`.
2. Lancia `bash scaffold_topics.sh` (idempotente, non sovrascrive).
3. Apri il `README.md` del nuovo topic e compila il frontmatter (status, tags, prerequisites).
4. Riempi gli altri file man mano che il topic matura.
5. Aggiorna `00_Index/Roadmap.md` se il topic appartiene a un livello di studio.
6. Aggiorna `00_Index/Tag_Index.md` se introduci un tag nuovo.

---

## 7. Workflow per migrare il template

Se il template cambia in futuro:
1. Aggiorna `scaffold_topics.sh` con la nuova versione del template.
2. Lancia `FORCE=1 bash scaffold_topics.sh` solo se i file esistenti sono ancora skeleton (status `stub`).
3. Se ci sono contenuti reali, scrivi una migrazione mirata che preservi il contenuto.

---

## 8. Anti-pattern della wiki stessa

Cose da NON fare:
- **Duplicare contenuti** tra README e file dedicati.
- **Lasciare frontmatter incompleto** (status, tags, last_updated).
- **Scrivere senza prerequisites** se il topic ne richiede.
- **Esempi senza linguaggio** specificato nel code fence.
- **Diagrammi via screenshot**: sempre Mermaid/PlantUML in plain text.
- **Antipattern generici** in `Topic_AntiPatterns.md`: vanno in `16_AntiPatterns/`.
- **Rinominare cartelle** senza aggiornare i link.
