# Dev Wiki

Wiki di software development per programmatori intermedio/avanzato.
Raccoglie spiegazioni teoriche, esempi pratici, trade-off e snippet riutilizzabili.

## Struttura

| Sezione | Contenuto |
|---|---|
| [00_Index](./00_Index/README.md) | Mappa, roadmap, tag |
| [01_Foundations](./01_Foundations/) | SOLID, DRY/KISS/YAGNI, coupling/cohesion, SoC |
| [02_Architecture](./02_Architecture/) | Layered, Clean, Microservices, CQRS, Event Sourcing |
| [03_Design_Patterns](./03_Design_Patterns/) | Creational, Structural, Behavioral |
| [04_Concurrency](./04_Concurrency/) | Threading, async, race conditions, actor model |
| [05_Distributed_Systems](./05_Distributed_Systems/) | CAP, consistency, idempotency, circuit breaker |
| [06_Data_Storage](./06_Data_Storage/) | Relational, NoSQL, indexing, transactions, migrations |
| [07_Networking](./07_Networking/) | HTTP, REST/RPC/GraphQL, WebSockets, TLS, API design |
| [08_Security](./08_Security/) | OWASP, AuthN/AuthZ, OAuth2, JWT, secure coding |
| [09_Testing](./09_Testing/) | Unit, integration, E2E, TDD, mocking |
| [10_DevOps](./10_DevOps/) | CI/CD, Docker, K8s, versioning, deployment |
| [11_Performance](./11_Performance/) | Profiling, caching, load balancing, bottleneck |
| [12_Observability](./12_Observability/) | Logging, metrics, tracing, monitoring |
| [13_Integration](./13_Integration/) | RabbitMQ, Kafka, PubSub, Saga, event streaming |
| [14_Languages](./14_Languages/) | C++, C#, Python deep dives |
| [15_Algorithms_DataStructures](./15_Algorithms_DataStructures/) | Pratico: quando usare cosa |
| [16_AntiPatterns](./16_AntiPatterns/) | God object, spaghetti, over-engineering |
| [17_Real_World](./17_Real_World/) | Case studies, postmortems, esempi reali |
| [18_Snippets](./18_Snippets/) | Snippet copia-incolla per linguaggio |
| [19_ADR](./19_ADR/) | Architecture Decision Records |
| [20_DDD](./20_DDD/) | Domain-Driven Design (strategic + tactical) |
| [21_Cloud_Native](./21_Cloud_Native/) | 12-factor, sidecar, ambassador, multi-tenancy, FinOps |
| [22_AI_ML_Integration](./22_AI_ML_Integration/) | RAG, embeddings, agent patterns, LLM API integration |
| [23_Resilience_Engineering](./23_Resilience_Engineering/) | Chaos, fault injection, backpressure, bulkhead |
| [24_Data_Engineering](./24_Data_Engineering/) | ETL/ELT, batch vs streaming, lake/warehouse/lakehouse |
| [25_Documentation](./25_Documentation/) | Docs as code, C4, code review, pairing |
| [26_Refactoring](./26_Refactoring/) | Catalogo refactoring, Strangler, Branch by Abstraction |
| [99_Resources](./99_Resources/) | Libri, articoli, tool, corsi, podcast, newsletter, community |

## Convenzioni
Vedi [00_Index/CONVENTIONS.md](./00_Index/CONVENTIONS.md) per le regole complete.

In sintesi:
- Inglese per nomi cartelle/file, `PascalCase_Snake_Case` coerente.
- Ogni topic foglia ha 9 file + Playground: `README.md` (hub con frontmatter YAML), `When_To_Use.md`, `Tradeoffs.md`, `Example_Simple.md`, `Example_Real.md`, `Diagrams.md`, `Checklist.md`, `Topic_AntiPatterns.md`, `Notes.md`.
- `README.md` è un hub leggero: niente duplicazione di contenuti che vivono negli altri file.
- Frontmatter YAML obbligatorio (`status`, `difficulty`, `tags`, `prerequisites`, `last_updated`).
- Anti-pattern *generici* → [16_AntiPatterns/](./16_AntiPatterns/). Anti-pattern *del topic* → `Topic_AntiPatterns.md`.
- Link interni sempre relativi.

## Quick start
1. Apri [00_Index/README.md](./00_Index/README.md) per la mappa.
2. Segui [00_Index/Roadmap.md](./00_Index/Roadmap.md) per un percorso di studio.
3. Cerca per tag in [00_Index/Tag_Index.md](./00_Index/Tag_Index.md).
