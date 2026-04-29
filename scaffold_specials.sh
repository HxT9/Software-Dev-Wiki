#!/usr/bin/env bash
# Crea i file speciali (README di categoria, ADR, Resources, Snippets, Real_World).

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)/dev-wiki"

write_if_missing() {
  local path="$1"
  shift
  if [[ -e "$path" ]]; then
    return 0
  fi
  printf '%s' "$*" > "$path"
}

category_readme() {
  local dir="$1"
  local title="$2"
  local subtitle="$3"
  write_if_missing "$ROOT/$dir/README.md" "# ${title}

${subtitle}

## Topic in questa sezione
$(cd "$ROOT/$dir" && for d in */; do
  d="${d%/}"
  if [[ "$d" != "Playground" ]]; then
    printf -- "- [%s](./%s/)\n" "$d" "$d"
  fi
done)

## Tags
"
}

# Categorie con descrizione
category_readme "01_Foundations" "01 Foundations" "Principi fondamentali del software design."
category_readme "02_Architecture" "02 Architecture" "Pattern architetturali per organizzare il codice a livello macro."
category_readme "03_Design_Patterns" "03 Design Patterns" "Pattern classici (GoF) e moderni, raggruppati per categoria."
category_readme "03_Design_Patterns/Creational" "Creational Patterns" "Pattern per la creazione di oggetti."
category_readme "03_Design_Patterns/Structural" "Structural Patterns" "Pattern per la composizione di classi e oggetti."
category_readme "03_Design_Patterns/Behavioral" "Behavioral Patterns" "Pattern per la comunicazione e la responsabilità tra oggetti."
category_readme "03_Design_Patterns/Concurrency" "Concurrency Patterns" "Pattern per coordinare lavoro tra thread/processi."
category_readme "03_Design_Patterns/Architectural" "Architectural Patterns" "Pattern di organizzazione applicativa (MVC, MVVM, Repository, ecc.)."
category_readme "04_Concurrency" "04 Concurrency" "Threading, async, modelli concorrenti e problemi tipici."
category_readme "05_Distributed_Systems" "05 Distributed Systems" "Pattern e teoremi per sistemi multi-nodo."
category_readme "06_Data_Storage" "06 Data Storage" "Persistenza: SQL, NoSQL, indici, transazioni, migrazioni."
category_readme "07_Networking" "07 Networking" "Protocolli, API design, sicurezza di trasporto."
category_readme "08_Security" "08 Security" "Sicurezza applicativa: OWASP, identity, secure coding."
category_readme "09_Testing" "09 Testing" "Strategie di test dal unit all'E2E."
category_readme "10_DevOps" "10 DevOps" "CI/CD, container, orchestrazione, deploy."
category_readme "11_Performance" "11 Performance" "Profiling, caching, bottleneck, load balancing."
category_readme "12_Observability" "12 Observability" "Log strutturato, metriche, tracing distribuito."
category_readme "13_Integration" "13 Integration" "Message broker, pattern di messaggistica, serializzazione."
category_readme "13_Integration/Message_Brokers" "Message Brokers" "Broker concreti: RabbitMQ, Kafka, NATS, Redis Streams, AWS SQS/SNS."
category_readme "13_Integration/Patterns" "Integration Patterns" "PubSub, Saga, Outbox, DLQ, Competing Consumers, Request/Reply."
category_readme "13_Integration/Serialization" "Serialization" "Formati: JSON, Protobuf, Avro, MessagePack."
category_readme "14_Languages" "14 Languages" "Approfondimenti per linguaggio."
category_readme "14_Languages/C" "C" "Memory model, pointer, undefined behavior, build system."
category_readme "14_Languages/Cpp" "C++" "RAII, templates, move semantics, STL, concorrenza."
category_readme "14_Languages/CSharp" "C#" "Async, GC, LINQ, Span<T>, source generators, internals."
category_readme "14_Languages/Python" "Python" "GIL, asyncio, type hints, dataclasses, packaging."
category_readme "14_Languages/Rust" "Rust" "Ownership, lifetimes, traits, async, macros, Cargo."
category_readme "14_Languages/TypeScript" "TypeScript" "Type system, generics, decorators, modules, compilation."
category_readme "14_Languages/Java" "Java" "JVM internals, GC, concurrency, streams, reactive, build."
category_readme "15_Algorithms_DataStructures" "15 Algorithms & Data Structures" "Pratico: quando usare cosa, trade-off reali."
category_readme "16_AntiPatterns" "16 Anti-Patterns" "Cose da riconoscere ed evitare."

# Nuove sezioni top-level (20-26)
category_readme "20_DDD" "20 Domain-Driven Design" "Pattern strategici e tattici per modellare il dominio."
category_readme "21_Cloud_Native" "21 Cloud Native" "12-factor, sidecar, ambassador, multi-tenancy, FinOps."
category_readme "22_AI_ML_Integration" "22 AI/ML Integration" "Integrare LLM e ML in sistemi software classici (RAG, agenti, tool calling)."
category_readme "23_Resilience_Engineering" "23 Resilience Engineering" "Chaos, fault injection, backpressure, bulkhead, graceful degradation."
category_readme "24_Data_Engineering" "24 Data Engineering" "Pipeline, batch vs streaming, data lake/warehouse/lakehouse."
category_readme "25_Documentation" "25 Documentation & Communication" "Documentation as code, C4, diagrammi, code review, pairing."
category_readme "26_Refactoring" "26 Refactoring" "Catalogo refactoring, Strangler Fig, Branch by Abstraction, Parallel Change."

# 17_Real_World
write_if_missing "$ROOT/17_Real_World/README.md" "# 17 Real World

Esempi reali, case study e postmortem.

## Sottosezioni
- [Case_Studies](./Case_Studies/) — analisi di scelte fatte in progetti reali
- [Architecture_Examples](./Architecture_Examples/) — architetture complete documentate
- [Postmortems](./Postmortems/) — incidenti, root cause, lezioni apprese
"

write_if_missing "$ROOT/17_Real_World/Case_Studies/README.md" "# Case Studies

Aggiungi un file per ogni case study seguendo il template.

## Template
Vedi [Case_Study_Template.md](./Case_Study_Template.md).
"

write_if_missing "$ROOT/17_Real_World/Case_Studies/Case_Study_Template.md" "# <Case Study Name>

## Context
Situazione reale.

## Problem
-

## Solution
-

## Architecture
-

## Outcome
-

## Lessons Learned
-

## Improvements
-
"

write_if_missing "$ROOT/17_Real_World/Architecture_Examples/README.md" "# Architecture Examples

Architetture complete con diagrammi, scelte tecniche e razionale.
"

write_if_missing "$ROOT/17_Real_World/Postmortems/README.md" "# Postmortems

Analisi di incidenti: timeline, root cause, impact, fix, action items.

## Template

\`\`\`markdown
# Postmortem - <Incident Title>

## Date
YYYY-MM-DD

## Summary
Cosa è successo in 2-3 righe.

## Timeline
- HH:MM — evento
- HH:MM — evento

## Root Cause
-

## Impact
- Utenti coinvolti:
- Durata:
- Servizi degradati:

## Resolution
Cosa è stato fatto per risolvere.

## Lessons Learned
-

## Action Items
- [ ] item 1
- [ ] item 2
\`\`\`
"

# 18_Snippets
write_if_missing "$ROOT/18_Snippets/README.md" "# 18 Snippets

Snippet riutilizzabili pronti copia-incolla, organizzati per linguaggio/contesto.

## Sezioni
- [C](./C/)
- [Cpp](./Cpp/)
- [CSharp](./CSharp/)
- [Python](./Python/)
- [TypeScript](./TypeScript/)
- [SQL](./SQL/)
- [Bash](./Bash/)
- [PowerShell](./PowerShell/)
- [YAML](./YAML/) — Dockerfile, k8s, CI configs
- [Regex](./Regex/) — espressioni regolari riutilizzabili
- [Git](./Git/) — alias, hook, comandi utili

## Template snippet

\`\`\`markdown
# <Snippet Name>

## Description
Breve descrizione.

## Code

    # snippet riutilizzabile
    def helper():
        return True

## Usage
Quando usarlo.

## Notes
-
\`\`\`
"

mkdir -p "$ROOT/18_Snippets/C"
for lang in C Cpp CSharp Python TypeScript SQL Bash PowerShell YAML Regex Git; do
  mkdir -p "$ROOT/18_Snippets/$lang"
  write_if_missing "$ROOT/18_Snippets/$lang/README.md" "# Snippets - ${lang}

Snippet riutilizzabili in ${lang}.
Aggiungi un file \`.md\` per ogni snippet seguendo il template in [../README.md](../README.md).
"
done

# 19_ADR
write_if_missing "$ROOT/19_ADR/README.md" "# 19 Architecture Decision Records

Documenta decisioni architetturali con contesto, decisione e conseguenze.

## Convenzioni
- Naming: \`NNNN_Short_Title.md\` (es: \`0001_Use_RabbitMQ.md\`).
- Numerazione progressiva, mai riutilizzata.
- Stato: \`Proposed\`, \`Accepted\`, \`Rejected\`, \`Superseded by ADR-XXXX\`.
- Una decisione per file, mai accorpare.

## Template
Vedi [TEMPLATE.md](./TEMPLATE.md).

## ADR esistenti
_(nessuno ancora)_
"

write_if_missing "$ROOT/19_ADR/TEMPLATE.md" "# ADR-XXXX - <Title>

## Status
Proposed / Accepted / Rejected / Superseded by ADR-XXXX

## Date
YYYY-MM-DD

## Context
Descrizione del problema, vincoli, forze in gioco.

## Decision
Decisione presa.

## Consequences

### Positive
-

### Negative
-

### Neutral
-

## Alternatives considered
- **Alternativa A**: motivo per cui scartata.
- **Alternativa B**: motivo per cui scartata.

## Notes
-
"

# 99_Resources
write_if_missing "$ROOT/99_Resources/README.md" "# 99 Resources

Risorse esterne organizzate per tipo.

- [Books](./Books.md)
- [Articles](./Articles.md)
- [Tools](./Tools.md)
- [Courses](./Courses.md)
- [Podcasts](./Podcasts.md)
- [Newsletters](./Newsletters.md)
- [Conferences](./Conferences.md)
- [YouTube_Channels](./YouTube_Channels.md)
- [Communities](./Communities.md)
"

write_if_missing "$ROOT/99_Resources/Books.md" "# Books

Lista di libri di riferimento, raggruppati per area.

## Foundations
- _<Titolo>_ — <Autore>. Note: ...

## Architecture
-

## Distributed Systems
-

## Performance
-

## Security
-

## Testing
-

## Languages
-
"

write_if_missing "$ROOT/99_Resources/Articles.md" "# Articles

Articoli, blog post, paper di rilievo.

## Format
- [Titolo](url) — autore/sito. Tag: \`#area\`. Note: 1-2 righe.
"

write_if_missing "$ROOT/99_Resources/Tools.md" "# Tools

Tool utili raggruppati per area.

## Profiling
-

## Observability
-

## CI/CD
-

## Containerizzazione
-

## Database
-

## Security
-

## Editor & IDE
-
"

write_if_missing "$ROOT/99_Resources/Courses.md" "# Courses

Corsi (free / paid) per area.

## Format
- [Titolo](url) — piattaforma. Livello: beginner/intermediate/advanced. Tag: \`#area\`.
"

write_if_missing "$ROOT/99_Resources/Podcasts.md" "# Podcasts

Podcast di software development e affini.

## Format
- [Nome](url) — host. Tag: \`#area\`. Note: di cosa parla.

## Generalisti
-

## Architecture / Backend
-

## DevOps / SRE
-

## Security
-

## AI / ML
-
"

write_if_missing "$ROOT/99_Resources/Newsletters.md" "# Newsletters

Newsletter tecniche da seguire.

## Format
- [Nome](url) — autore. Frequenza: settimanale/mensile. Tag: \`#area\`.

## Backend & Architecture
-

## Frontend
-

## DevOps & SRE
-

## Security
-

## Languages
-

## AI / ML
-
"

write_if_missing "$ROOT/99_Resources/Conferences.md" "# Conferences

Conferenze rilevanti, in-person e online.

## Format
- [Nome](url) — frequenza/luogo. Tag: \`#area\`. Note: cosa la rende interessante.

## Generaliste
-

## Architecture & Backend
-

## DevOps & Cloud
-

## Security
-

## Languages
-

## AI / ML
-
"

write_if_missing "$ROOT/99_Resources/YouTube_Channels.md" "# YouTube Channels

Canali YouTube tecnici da seguire.

## Format
- [Nome canale](url) — tag: \`#area\`. Note: di cosa parla.

## Architecture & System Design
-

## Performance & Low-Level
-

## DevOps & Cloud
-

## Security
-

## Languages
-

## AI / ML
-
"

write_if_missing "$ROOT/99_Resources/Communities.md" "# Communities

Community di sviluppatori (Discord, Slack, Reddit, forum).

## Format
- [Nome](url) — piattaforma. Tag: \`#area\`. Note: come entrare, cosa aspettarsi.

## Reddit
-

## Discord / Slack
-

## Forum
-

## Stack Exchange
-
"

echo "Special files scaffolded."
