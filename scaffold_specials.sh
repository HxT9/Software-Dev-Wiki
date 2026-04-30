#!/usr/bin/env bash
# Generate special files (category READMEs, ADR templates, Resources, Snippets, Real_World).
# Idempotent by default. Set FORCE=1 to overwrite existing files.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)/dev-wiki"
FORCE="${FORCE:-0}"

write_file() {
  local path="$1"
  shift
  if [[ -e "$path" && "$FORCE" != "1" ]]; then
    return 0
  fi
  printf '%s' "$*" > "$path"
}

category_readme() {
  local dir="$1"
  local title="$2"
  local subtitle="$3"
  write_file "$ROOT/$dir/README.md" "# ${title}

## Overview
${subtitle}

> *TODO*: expand this overview when the section is fleshed out — what unifies these topics, what mental model they share, what problems they all address.

## When to reach for what

> *TODO*: brief real-world scenarios mapping problem → topic. Example format:
> - *\"Symptom you observe in code\"* → \`[Topic_Name](./Topic_Name/)\`

## Topics in this section
$(cd "$ROOT/$dir" && for d in */; do
  d="${d%/}"
  if [[ "$d" != "Playground" ]]; then
    printf -- "- [%s](./%s/)\n" "$d" "$d"
  fi
done)

## Tags
"
}

# Categories with a description
category_readme "01_Foundations" "01 Foundations" "Fundamental software design principles."
category_readme "02_Architecture" "02 Architecture" "Architectural patterns to organize code at the macro level."
category_readme "03_Design_Patterns" "03 Design Patterns" "Classic (GoF) and modern patterns, grouped by category."
category_readme "03_Design_Patterns/Creational" "Creational Patterns" "Patterns for object creation."
category_readme "03_Design_Patterns/Structural" "Structural Patterns" "Patterns for class and object composition."
category_readme "03_Design_Patterns/Behavioral" "Behavioral Patterns" "Patterns for communication and responsibility between objects."
category_readme "03_Design_Patterns/Concurrency" "Concurrency Patterns" "Patterns for coordinating work across threads/processes."
category_readme "03_Design_Patterns/Architectural" "Architectural Patterns" "Application organization patterns (MVC, MVVM, Repository, etc.)."
category_readme "04_Concurrency" "04 Concurrency" "Threading, async, concurrent models, and typical pitfalls."
category_readme "05_Distributed_Systems" "05 Distributed Systems" "Patterns and theorems for multi-node systems."
category_readme "06_Data_Storage" "06 Data Storage" "Persistence: SQL, NoSQL, indexing, transactions, migrations."
category_readme "07_Networking" "07 Networking" "Protocols, API design, transport security."
category_readme "08_Security" "08 Security" "Application security: OWASP, identity, secure coding."
category_readme "09_Testing" "09 Testing" "Testing strategies from unit to E2E."
category_readme "10_DevOps" "10 DevOps" "CI/CD, containers, orchestration, deployment."
category_readme "11_Performance" "11 Performance" "Profiling, caching, bottlenecks, load balancing."
category_readme "12_Observability" "12 Observability" "Structured logging, metrics, distributed tracing."
category_readme "13_Integration" "13 Integration" "Message brokers, messaging patterns, serialization."
category_readme "13_Integration/Message_Brokers" "Message Brokers" "Concrete brokers: RabbitMQ, Kafka, NATS, Redis Streams, AWS SQS/SNS."
category_readme "13_Integration/Patterns" "Integration Patterns" "PubSub, Saga, Outbox, DLQ, Competing Consumers, Request/Reply."
category_readme "13_Integration/Serialization" "Serialization" "Formats: JSON, Protobuf, Avro, MessagePack."
category_readme "14_Languages" "14 Languages" "Per-language deep dives."
category_readme "14_Languages/C" "C" "Memory model, pointers, undefined behavior, build system."
category_readme "14_Languages/Cpp" "C++" "RAII, templates, move semantics, STL, concurrency."
category_readme "14_Languages/CSharp" "C#" "Async, GC, LINQ, Span<T>, source generators, internals."
category_readme "14_Languages/Python" "Python" "GIL, asyncio, type hints, dataclasses, packaging."
category_readme "14_Languages/Rust" "Rust" "Ownership, lifetimes, traits, async, macros, Cargo."
category_readme "14_Languages/TypeScript" "TypeScript" "Type system, generics, decorators, modules, compilation."
category_readme "14_Languages/Java" "Java" "JVM internals, GC, concurrency, streams, reactive, build."
category_readme "15_Algorithms_DataStructures" "15 Algorithms & Data Structures" "Practical: when to use what, real-world trade-offs."
category_readme "16_AntiPatterns" "16 Anti-Patterns" "Things to recognize and avoid."

# New top-level sections (20-26)
category_readme "20_DDD" "20 Domain-Driven Design" "Strategic and tactical patterns for domain modeling."
category_readme "21_Cloud_Native" "21 Cloud Native" "12-factor, sidecar, ambassador, multi-tenancy, FinOps."
category_readme "22_AI_ML_Integration" "22 AI/ML Integration" "Integrating LLMs and ML into traditional software systems (RAG, agents, tool calling)."
category_readme "23_Resilience_Engineering" "23 Resilience Engineering" "Chaos, fault injection, backpressure, bulkhead, graceful degradation."
category_readme "24_Data_Engineering" "24 Data Engineering" "Pipelines, batch vs streaming, data lake/warehouse/lakehouse."
category_readme "25_Documentation" "25 Documentation & Communication" "Documentation as code, C4, diagrams, code review, pairing."
category_readme "26_Refactoring" "26 Refactoring" "Refactoring catalog, Strangler Fig, Branch by Abstraction, Parallel Change."

# 17_Real_World
write_file "$ROOT/17_Real_World/README.md" "# 17 Real World

Real-world examples, case studies, and postmortems.

## Subsections
- [Case_Studies](./Case_Studies/) — analysis of decisions made in real projects
- [Architecture_Examples](./Architecture_Examples/) — fully documented architectures
- [Postmortems](./Postmortems/) — incidents, root cause, lessons learned
"

write_file "$ROOT/17_Real_World/Case_Studies/README.md" "# Case Studies

Add a file for each case study following the template.

## Template
See [Case_Study_Template.md](./Case_Study_Template.md).
"

write_file "$ROOT/17_Real_World/Case_Studies/Case_Study_Template.md" "# <Case Study Name>

## Context
The real-world situation.

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

write_file "$ROOT/17_Real_World/Architecture_Examples/README.md" "# Architecture Examples

Complete architectures with diagrams, technical choices, and rationale.
"

write_file "$ROOT/17_Real_World/Postmortems/README.md" "# Postmortems

Incident analysis: timeline, root cause, impact, fix, action items.

## Template

\`\`\`markdown
# Postmortem - <Incident Title>

## Date
YYYY-MM-DD

## Summary
What happened, in 2-3 lines.

## Timeline
- HH:MM — event
- HH:MM — event

## Root Cause
-

## Impact
- Users affected:
- Duration:
- Degraded services:

## Resolution
What was done to resolve it.

## Lessons Learned
-

## Action Items
- [ ] item 1
- [ ] item 2
\`\`\`
"

# 18_Snippets
write_file "$ROOT/18_Snippets/README.md" "# 18 Snippets

Reusable copy-paste snippets, organized by language/context.

## Sections

- [C](./C/)
- [Cpp](./Cpp/)
- [CSharp](./CSharp/)
- [Python](./Python/)
- [TypeScript](./TypeScript/)
- [SQL](./SQL/)
- [Bash](./Bash/)
- [PowerShell](./PowerShell/)
- [YAML](./YAML/) — Dockerfile, k8s, CI configs
- [Regex](./Regex/) — reusable regular expressions
- [Git](./Git/) — aliases, hooks, useful commands

## Snippet structure

For each snippet create a \`.md\` file with these sections:

- **Title** (H1 heading) — name of the snippet.
- **Description** — brief description (1-2 lines).
- **Code** — code block in the appropriate language (use a fence with a language tag, e.g. \` \`\`\`python \`).
- **Usage** — when to use it, context, prerequisites.
- **Notes** — caveats, variants, related alternatives.
"

for lang in C Cpp CSharp Python TypeScript SQL Bash PowerShell YAML Regex Git; do
  mkdir -p "$ROOT/18_Snippets/$lang"
  write_file "$ROOT/18_Snippets/$lang/README.md" "# Snippets - ${lang}

Reusable snippets in ${lang}.
Add a \`.md\` file for each snippet following the template described in [../](../).
"
done

# 19_ADR
write_file "$ROOT/19_ADR/README.md" "# 19 Architecture Decision Records

Document architectural decisions with context, decision, and consequences.

## Conventions
- Naming: \`NNNN_Short_Title.md\` (e.g., \`0001_Use_RabbitMQ.md\`).
- Sequential numbering, never reused.
- Status: \`Proposed\`, \`Accepted\`, \`Rejected\`, \`Superseded by ADR-XXXX\`.
- One decision per file, never combined.

## Template
See [TEMPLATE.md](./TEMPLATE.md).

## Existing ADRs
- [ADR-0001 — Wiki Structure and Conventions](./0001_Wiki_Structure_and_Conventions.md) — top-level structure, topic template, operational rules
"

write_file "$ROOT/19_ADR/TEMPLATE.md" "# ADR-XXXX - <Title>

## Status
Proposed / Accepted / Rejected / Superseded by ADR-XXXX

## Date
YYYY-MM-DD

## Context
Description of the problem, constraints, forces at play.

## Decision
The decision taken.

## Consequences

### Positive
-

### Negative
-

### Neutral
-

## Alternatives considered
- **Alternative A**: reason it was rejected.
- **Alternative B**: reason it was rejected.

## Notes
-
"

# 99_Resources
write_file "$ROOT/99_Resources/README.md" "# 99 Resources

External resources organized by type.

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

write_file "$ROOT/99_Resources/Books.md" "# Books

List of reference books, grouped by area.

## Foundations
- _<Title>_ — <Author>. Notes: ...

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

write_file "$ROOT/99_Resources/Articles.md" "# Articles

Articles, blog posts, and notable papers.

## Format
- [Title](https://example.com) — author/site. Tag: \`#area\`. Notes: 1-2 lines.
"

write_file "$ROOT/99_Resources/Tools.md" "# Tools

Useful tools grouped by area.

## Profiling
-

## Observability
-

## CI/CD
-

## Containerization
-

## Database
-

## Security
-

## Editor & IDE
-
"

write_file "$ROOT/99_Resources/Courses.md" "# Courses

Courses (free / paid) by area.

## Format
- [Title](https://example.com) — platform. Level: beginner/intermediate/advanced. Tag: \`#area\`.
"

write_file "$ROOT/99_Resources/Podcasts.md" "# Podcasts

Software development and adjacent podcasts.

## Format
- [Name](https://example.com) — host. Tag: \`#area\`. Notes: what it's about.

## General
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

write_file "$ROOT/99_Resources/Newsletters.md" "# Newsletters

Technical newsletters worth following.

## Format
- [Name](https://example.com) — author. Frequency: weekly/monthly. Tag: \`#area\`.

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

write_file "$ROOT/99_Resources/Conferences.md" "# Conferences

Notable conferences, in-person and online.

## Format
- [Name](https://example.com) — frequency/location. Tag: \`#area\`. Notes: why it's interesting.

## General
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

write_file "$ROOT/99_Resources/YouTube_Channels.md" "# YouTube Channels

Technical YouTube channels worth following.

## Format
- [Channel name](https://example.com) — tag: \`#area\`. Notes: what it covers.

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

write_file "$ROOT/99_Resources/Communities.md" "# Communities

Developer communities (Discord, Slack, Reddit, forums).

## Format
- [Name](https://example.com) — platform. Tag: \`#area\`. Notes: how to join, what to expect.

## Reddit
-

## Discord / Slack
-

## Forums
-

## Stack Exchange
-
"

echo "Special files scaffolded. (FORCE=${FORCE})"
