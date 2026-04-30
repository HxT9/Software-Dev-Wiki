#!/usr/bin/env bash
# Scaffold the standard files for each wiki topic.
# Idempotent by default. Set FORCE=1 to overwrite existing placeholders.
#
# Template: 9 files per topic (README + 7 sections + Playground/).
# - README.md            : hub with YAML frontmatter + overview/problem/key concepts/prerequisites + links
# - When_To_Use.md       : use cases, indicators, scenarios, decision tree
# - Tradeoffs.md         : pros/cons, flexible performance characteristics, alternatives
# - Example_Simple.md    : minimal example
# - Example_Real.md      : production-like example
# - Diagrams.md          : Mermaid/PlantUML/C4
# - Checklist.md         : implementation, code review, production readiness
# - Topic_AntiPatterns.md: anti-patterns *specific to this topic* (generic ones live in 16_AntiPatterns/)
# - Notes.md             : insights, edge cases, gotchas, open questions
# - Playground/          : runnable mini projects

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)/dev-wiki"
TODAY="$(date +%Y-%m-%d)"
FORCE="${FORCE:-0}"

write_file() {
  local path="$1"
  shift
  if [[ -e "$path" && "$FORCE" != "1" ]]; then
    return 0
  fi
  printf '%s\n' "$*" > "$path"
}

# Derive the top-level section (e.g., "01_Foundations") from the relative path.
derive_section() {
  local rel="$1"
  echo "$rel" | cut -d'/' -f1
}

# Auto-derive tags from the path (e.g., 14_Languages/Rust/Async => [languages, rust]).
derive_tags() {
  local rel="$1"
  local section
  section="$(derive_section "$rel")"
  local section_tag
  section_tag="$(echo "$section" | sed -E 's/^[0-9]+_//' | tr '[:upper:]' '[:lower:]')"
  local parts
  parts="$(echo "$rel" | tr '/' '\n' | tail -n +2 | head -n -1 | tr '[:upper:]' '[:lower:]' | sed 's/_/-/g')"
  local tags="$section_tag"
  while IFS= read -r p; do
    [[ -n "$p" ]] && tags="$tags, $p"
  done <<< "$parts"
  echo "$tags"
}

scaffold_topic() {
  local rel="$1"
  local dir="$ROOT/$rel"
  local title
  title="$(basename "$rel" | tr '_' ' ')"
  local section
  section="$(derive_section "$rel")"
  local tags
  tags="$(derive_tags "$rel")"

  # Build a "../" string with the right depth to reach back to dev-wiki/.
  # Depth = number of path segments in $rel (e.g. "A/B/C" -> 3 -> "../../../").
  local depth
  depth=$(($(echo "$rel" | tr '/' '\n' | wc -l)))
  local up_to_wiki=""
  local i
  for (( i=0; i<depth; i++ )); do
    up_to_wiki="../${up_to_wiki}"
  done

  mkdir -p "$dir"

  # Migration: remove old AntiPatterns.md (renamed to Topic_AntiPatterns.md).
  if [[ "$FORCE" == "1" && -e "$dir/AntiPatterns.md" ]]; then
    rm -f "$dir/AntiPatterns.md"
  fi

  write_file "$dir/README.md" "---
title: ${title}
section: ${section}
status: stub
difficulty: intermediate
tags: [${tags}]
prerequisites: []
related: []
last_updated: ${TODAY}
reading_time_min: 10
---

# ${title}

## Overview
One or two sentences explaining what this topic is and why it exists.

## Problem
What concrete problem does it solve?
-

## Key Concepts
Key concepts (define each briefly; link to a glossary or to other topics when useful).
-

## Prerequisites
What's helpful to know before reading this topic.
- [[OtherTopic]]

## Deep Dives
- [When to Use](./When_To_Use.md) — use cases, indicators, decision tree
- [Trade-offs](./Tradeoffs.md) — pros, cons, performance, alternatives
- [Simple Example](./Example_Simple.md) — minimal example
- [Real World Example](./Example_Real.md) — production-like example
- [Diagrams](./Diagrams.md) — Mermaid / PlantUML / C4 diagrams
- [Checklist](./Checklist.md) — implementation, review, production readiness
- [Topic Anti-Patterns](./Topic_AntiPatterns.md) — anti-patterns *specific to this topic*
- [Notes](./Notes.md) — insights, edge cases, gotchas
- [Playground](./Playground/) — runnable code

## Related Topics
- [[OtherTopic]]

## References
-
"

  write_file "$dir/When_To_Use.md" "# When to Use - ${title}

## Use Cases
Concrete use cases with a bit of context.
-
-

## When to Use
Signals that suggest this is the right choice.
-
-

## When NOT to Use
Signals that suggest this is the wrong choice.
-
-

## Decision Tree
\`\`\`mermaid
flowchart TD
  Q[Considering ${title}?] --> Q1[Do I have problem X?]
  Q1 -->|Yes| OK[Consider ${title}]
  Q1 -->|No| NO[Probably not needed]
\`\`\`

## Real Scenarios
- Scenario 1: context, constraints, why ${title} is the right call.
-
"

  write_file "$dir/Tradeoffs.md" "# Trade-offs - ${title}

## Benefits
-
-

## Drawbacks
-
-

## Performance Characteristics
> Fill in only the fields relevant to this topic. Remove the ones that don't apply.
- **Throughput**:
- **Latency**:
- **Memory footprint**:
- **Big O (Time)**:
- **Big O (Space)**:
- **Network overhead**:
- **Storage overhead**:

## Scalability
-

## Maintainability
-

## Operational Cost
- Setup:
- Run-time:
- On-call burden:

## Alternatives
- [[Alternative1]] — when to prefer it
- [[Alternative2]] — when to prefer it
"

  write_file "$dir/Example_Simple.md" "# Simple Example - ${title}

## Goal
One-line statement of the example's goal.

## Explanation
Step-by-step explanation.

## Code

\`\`\`
# Minimal, isolated, runnable code
\`\`\`

## Key Takeaways
-
-
"

  write_file "$dir/Example_Real.md" "# Real World Example - ${title}

## Context
Realistic scenario (domain, constraints, scale).

## Requirements
-
-

## Architecture
Brief overview of the components involved. See [Diagrams](./Diagrams.md) for the diagram.

## Flow
Sequence of steps in the main flow.

## Code

\`\`\`
# Production-leaning code (error handling, observability, etc.)
\`\`\`

## Notes
-

## Improvements
- What you would add to push this all the way to production.
"

  write_file "$dir/Diagrams.md" "# Diagrams - ${title}

## Concept Map
\`\`\`mermaid
graph LR
  A[Concept 1] --> B[Concept 2]
  A --> C[Concept 3]
\`\`\`

## Sequence
\`\`\`mermaid
sequenceDiagram
  participant A as Component A
  participant B as Component B
  A->>B: Request
  B-->>A: Response
\`\`\`

## Architecture (C4 / blocks)
> Add a C4 diagram (Context/Container/Component) or architectural blocks if relevant.

\`\`\`mermaid
flowchart LR
  Client --> Service
  Service --> DB[(Database)]
\`\`\`

## Visual Notes
-
"

  write_file "$dir/Checklist.md" "# Checklist - ${title}

## Implementation Checklist
Concrete steps to implement ${title} correctly.
- [ ] Step 1
- [ ] Step 2
- [ ] Step 3

## Review Checklist
What to look for during code review when this topic is involved.
- [ ] Item 1
- [ ] Item 2

## Production Readiness
- [ ] Structured logging (who, what, why)
- [ ] Metrics / SLIs defined
- [ ] Alerting on known failure modes
- [ ] Tests (unit, integration, e2e where applicable)
- [ ] Failure modes documented
- [ ] Rollback plan
- [ ] Performance baseline measured
- [ ] Security review (if applicable)
"

  write_file "$dir/Topic_AntiPatterns.md" "# Topic Anti-Patterns - ${title}

> Anti-patterns *specific to ${title}*.
> For generic anti-patterns (God Object, Spaghetti Code, etc.) see [16_AntiPatterns](${up_to_wiki}16_AntiPatterns/).

## <Anti-Pattern Name>

**Description**
What people do that they shouldn't.

**Why it's bad**
-

**Bad Example**

\`\`\`
# bad code
\`\`\`

**Better Approach**
-

**Good Example**

\`\`\`
# good code
\`\`\`

---

## Related Smells
Smells that often precede a misuse of ${title}.
-
"

  write_file "$dir/Notes.md" "# Notes - ${title}

## Insights
Things learned in the field.
-

## Edge Cases
-

## Gotchas
-

## Open Questions
-
"

  mkdir -p "$dir/Playground"
  write_file "$dir/Playground/README.md" "# Playground - ${title}

Runnable mini projects and example code for ${title}.

## How to run
Commands and prerequisites to execute the examples.

## Experiments
- Experiment 1: hypothesis -> result.
"
}

# List of every leaf topic that should receive the standard template.
TOPICS=(
  # 01_Foundations
  "01_Foundations/SOLID"
  "01_Foundations/DRY_KISS_YAGNI"
  "01_Foundations/Coupling_Cohesion"
  "01_Foundations/Separation_of_Concerns"
  "01_Foundations/Law_of_Demeter"
  "01_Foundations/Composition_over_Inheritance"
  "01_Foundations/Fail_Fast"
  "01_Foundations/Principle_of_Least_Astonishment"
  "01_Foundations/Encapsulation"
  "01_Foundations/Code_Smells"
  "01_Foundations/Refactoring_Techniques"
  "01_Foundations/Naming_Conventions"

  # 02_Architecture
  "02_Architecture/Layered_Architecture"
  "02_Architecture/Clean_Architecture"
  "02_Architecture/Microservices"
  "02_Architecture/Monolith"
  "02_Architecture/Event_Driven"
  "02_Architecture/CQRS"
  "02_Architecture/Event_Sourcing"
  "02_Architecture/Hexagonal_Architecture"
  "02_Architecture/Onion_Architecture"
  "02_Architecture/Modular_Monolith"
  "02_Architecture/BFF"
  "02_Architecture/Strangler_Fig"
  "02_Architecture/API_Gateway"
  "02_Architecture/Serverless"
  "02_Architecture/Plugin_Architecture"

  # 03_Design_Patterns
  "03_Design_Patterns/Creational/Singleton"
  "03_Design_Patterns/Creational/Factory"
  "03_Design_Patterns/Creational/Builder"
  "03_Design_Patterns/Creational/Prototype"
  "03_Design_Patterns/Creational/Abstract_Factory"
  "03_Design_Patterns/Creational/Object_Pool"
  "03_Design_Patterns/Structural/Adapter"
  "03_Design_Patterns/Structural/Decorator"
  "03_Design_Patterns/Structural/Facade"
  "03_Design_Patterns/Structural/Composite"
  "03_Design_Patterns/Structural/Proxy"
  "03_Design_Patterns/Structural/Bridge"
  "03_Design_Patterns/Structural/Flyweight"
  "03_Design_Patterns/Behavioral/Observer"
  "03_Design_Patterns/Behavioral/Strategy"
  "03_Design_Patterns/Behavioral/Command"
  "03_Design_Patterns/Behavioral/State"
  "03_Design_Patterns/Behavioral/Iterator"
  "03_Design_Patterns/Behavioral/Visitor"
  "03_Design_Patterns/Behavioral/Mediator"
  "03_Design_Patterns/Behavioral/Template_Method"
  "03_Design_Patterns/Behavioral/Chain_of_Responsibility"
  "03_Design_Patterns/Behavioral/Memento"
  "03_Design_Patterns/Behavioral/Specification"
  "03_Design_Patterns/Behavioral/Null_Object"
  "03_Design_Patterns/Concurrency/Producer_Consumer"
  "03_Design_Patterns/Concurrency/Thread_Pool"
  "03_Design_Patterns/Concurrency/Monitor"
  "03_Design_Patterns/Concurrency/Active_Object"
  "03_Design_Patterns/Architectural/MVC"
  "03_Design_Patterns/Architectural/MVP"
  "03_Design_Patterns/Architectural/MVVM"
  "03_Design_Patterns/Architectural/Repository"
  "03_Design_Patterns/Architectural/Unit_of_Work"

  # 04_Concurrency
  "04_Concurrency/Threading"
  "04_Concurrency/Async_Await"
  "04_Concurrency/Race_Conditions"
  "04_Concurrency/Deadlocks"
  "04_Concurrency/Actor_Model"
  "04_Concurrency/Reactive_Programming"
  "04_Concurrency/Locks_Synchronization"
  "04_Concurrency/Atomic_Lock_Free"
  "04_Concurrency/Memory_Models"
  "04_Concurrency/Coroutines"
  "04_Concurrency/CSP"
  "04_Concurrency/Livelock_Starvation"
  "04_Concurrency/Concurrency_vs_Parallelism"

  # 05_Distributed_Systems
  "05_Distributed_Systems/CAP_Theorem"
  "05_Distributed_Systems/Consistency_Models"
  "05_Distributed_Systems/Idempotency"
  "05_Distributed_Systems/Retry_Patterns"
  "05_Distributed_Systems/Circuit_Breaker"
  "05_Distributed_Systems/Distributed_Transactions"
  "05_Distributed_Systems/PACELC"
  "05_Distributed_Systems/Consensus_Algorithms"
  "05_Distributed_Systems/Leader_Election"
  "05_Distributed_Systems/Distributed_Locks"
  "05_Distributed_Systems/Vector_Clocks"
  "05_Distributed_Systems/Two_Phase_Commit"
  "05_Distributed_Systems/Service_Discovery"
  "05_Distributed_Systems/Sharding"
  "05_Distributed_Systems/Replication"
  "05_Distributed_Systems/Quorum"
  "05_Distributed_Systems/Gossip_Protocols"

  # 06_Data_Storage
  "06_Data_Storage/Relational"
  "06_Data_Storage/NoSQL"
  "06_Data_Storage/Indexing"
  "06_Data_Storage/Transactions"
  "06_Data_Storage/ORM_vs_Raw"
  "06_Data_Storage/Schema_Migrations"
  "06_Data_Storage/Connection_Pooling"
  "06_Data_Storage/Normalization"
  "06_Data_Storage/ACID_vs_BASE"
  "06_Data_Storage/Database_Internals"
  "06_Data_Storage/N_Plus_One"
  "06_Data_Storage/CDC"
  "06_Data_Storage/TimeSeries_DB"
  "06_Data_Storage/Graph_DB"
  "06_Data_Storage/Vector_DB"
  "06_Data_Storage/Search_Engines"

  # 07_Networking
  "07_Networking/HTTP_Deep_Dive"
  "07_Networking/REST_vs_RPC"
  "07_Networking/GraphQL"
  "07_Networking/WebSockets"
  "07_Networking/TLS_SSL"
  "07_Networking/API_Design"
  "07_Networking/gRPC"
  "07_Networking/HTTP2_HTTP3"
  "07_Networking/TCP_vs_UDP"
  "07_Networking/DNS"
  "07_Networking/Server_Sent_Events"
  "07_Networking/WebRTC"
  "07_Networking/mTLS"
  "07_Networking/CORS"
  "07_Networking/CDN"
  "07_Networking/Reverse_Proxy"
  "07_Networking/Webhooks"
  "07_Networking/Rate_Limiting"

  # 08_Security
  "08_Security/OWASP"
  "08_Security/Authentication"
  "08_Security/Authorization"
  "08_Security/OAuth2"
  "08_Security/JWT"
  "08_Security/Secure_Coding"
  "08_Security/OpenID_Connect"
  "08_Security/SAML"
  "08_Security/CSRF"
  "08_Security/XSS"
  "08_Security/SQL_Injection"
  "08_Security/Cryptography"
  "08_Security/Password_Hashing"
  "08_Security/Secret_Management"
  "08_Security/Zero_Trust"
  "08_Security/RBAC_ABAC_ReBAC"
  "08_Security/Container_Security"
  "08_Security/Supply_Chain_Security"
  "08_Security/SAST_DAST"

  # 09_Testing
  "09_Testing/Unit_Testing"
  "09_Testing/Integration_Testing"
  "09_Testing/E2E_Testing"
  "09_Testing/TDD"
  "09_Testing/Mocking"
  "09_Testing/BDD"
  "09_Testing/Property_Based_Testing"
  "09_Testing/Mutation_Testing"
  "09_Testing/Snapshot_Testing"
  "09_Testing/Contract_Testing"
  "09_Testing/Performance_Testing"
  "09_Testing/Chaos_Testing"
  "09_Testing/Test_Doubles"
  "09_Testing/Test_Pyramid"

  # 10_DevOps
  "10_DevOps/CI_CD"
  "10_DevOps/Docker"
  "10_DevOps/Kubernetes"
  "10_DevOps/Versioning"
  "10_DevOps/Deployment_Strategies"
  "10_DevOps/Infrastructure_as_Code"
  "10_DevOps/Configuration_Management"
  "10_DevOps/GitOps"
  "10_DevOps/Service_Mesh"
  "10_DevOps/Helm"
  "10_DevOps/Feature_Flags"
  "10_DevOps/Trunk_Based_Development"
  "10_DevOps/Monorepo_vs_Polyrepo"
  "10_DevOps/Pre_Commit_Hooks"
  "10_DevOps/Build_Systems"

  # 11_Performance
  "11_Performance/Profiling"
  "11_Performance/Caching"
  "11_Performance/Load_Balancing"
  "11_Performance/Bottleneck_Analysis"
  "11_Performance/Big_O_Applied"
  "11_Performance/Memory_Leaks"
  "11_Performance/CPU_vs_IO_Bound"
  "11_Performance/Lazy_Loading"
  "11_Performance/Pagination"
  "11_Performance/Batch_Processing"
  "11_Performance/Compression"

  # 12_Observability
  "12_Observability/Logging"
  "12_Observability/Metrics"
  "12_Observability/Tracing"
  "12_Observability/Monitoring"
  "12_Observability/Alerting"
  "12_Observability/SLI_SLO_SLA"
  "12_Observability/OpenTelemetry"
  "12_Observability/APM"
  "12_Observability/Error_Tracking"
  "12_Observability/Log_Aggregation"
  "12_Observability/Dashboard_Design"
  "12_Observability/Incident_Response"
  "12_Observability/On_Call"

  # 13_Integration
  "13_Integration/Message_Brokers/RabbitMQ"
  "13_Integration/Message_Brokers/Kafka"
  "13_Integration/Message_Brokers/NATS"
  "13_Integration/Message_Brokers/Redis_Streams"
  "13_Integration/Message_Brokers/AWS_SQS_SNS"
  "13_Integration/Patterns/PubSub"
  "13_Integration/Patterns/Saga"
  "13_Integration/Patterns/Event_Streaming"
  "13_Integration/Patterns/Outbox_Inbox"
  "13_Integration/Patterns/Dead_Letter_Queue"
  "13_Integration/Patterns/Competing_Consumers"
  "13_Integration/Patterns/Request_Reply"
  "13_Integration/Patterns/Schema_Registry"
  "13_Integration/Serialization/JSON"
  "13_Integration/Serialization/Protobuf"
  "13_Integration/Serialization/Avro"
  "13_Integration/Serialization/MessagePack"

  # 14_Languages - C
  "14_Languages/C/Memory_Management"
  "14_Languages/C/Pointers"
  "14_Languages/C/Undefined_Behavior"
  "14_Languages/C/Build_System"
  "14_Languages/C/Standard_Library"

  # 14_Languages - Cpp
  "14_Languages/Cpp/Memory_Management"
  "14_Languages/Cpp/Concurrency"
  "14_Languages/Cpp/Templates"
  "14_Languages/Cpp/RAII"
  "14_Languages/Cpp/Move_Semantics"
  "14_Languages/Cpp/STL"

  # 14_Languages - CSharp
  "14_Languages/CSharp/Async"
  "14_Languages/CSharp/Internals"
  "14_Languages/CSharp/GC"
  "14_Languages/CSharp/LINQ"
  "14_Languages/CSharp/Span_T"
  "14_Languages/CSharp/Source_Generators"

  # 14_Languages - Python
  "14_Languages/Python/GIL"
  "14_Languages/Python/Asyncio"
  "14_Languages/Python/Type_Hints"
  "14_Languages/Python/Dataclasses"
  "14_Languages/Python/Packaging"

  # 14_Languages - Rust
  "14_Languages/Rust/Ownership_Borrowing"
  "14_Languages/Rust/Lifetimes"
  "14_Languages/Rust/Traits"
  "14_Languages/Rust/Async"
  "14_Languages/Rust/Macros"
  "14_Languages/Rust/Cargo"

  # 14_Languages - TypeScript
  "14_Languages/TypeScript/Type_System"
  "14_Languages/TypeScript/Generics"
  "14_Languages/TypeScript/Type_Inference"
  "14_Languages/TypeScript/Decorators"
  "14_Languages/TypeScript/Modules"
  "14_Languages/TypeScript/Compilation"

  # 14_Languages - Java
  "14_Languages/Java/JVM_Internals"
  "14_Languages/Java/GC"
  "14_Languages/Java/Concurrency"
  "14_Languages/Java/Streams_Lambdas"
  "14_Languages/Java/Reactive"
  "14_Languages/Java/Build_Tools"

  # 15_Algorithms_DataStructures
  "15_Algorithms_DataStructures/Data_Structures"
  "15_Algorithms_DataStructures/Sorting"
  "15_Algorithms_DataStructures/Searching"
  "15_Algorithms_DataStructures/Practical_Use_Cases"
  "15_Algorithms_DataStructures/Graph_Algorithms"
  "15_Algorithms_DataStructures/Dynamic_Programming"
  "15_Algorithms_DataStructures/Greedy"
  "15_Algorithms_DataStructures/Divide_and_Conquer"
  "15_Algorithms_DataStructures/Hash_Tables"
  "15_Algorithms_DataStructures/Trees"
  "15_Algorithms_DataStructures/Heaps"
  "15_Algorithms_DataStructures/Probabilistic_Data_Structures"
  "15_Algorithms_DataStructures/Skip_Lists"
  "15_Algorithms_DataStructures/String_Algorithms"
  "15_Algorithms_DataStructures/Big_O_Complexity"

  # 16_AntiPatterns
  "16_AntiPatterns/God_Object"
  "16_AntiPatterns/Spaghetti_Code"
  "16_AntiPatterns/Premature_Optimization"
  "16_AntiPatterns/Over_Engineering"
  "16_AntiPatterns/Magic_Numbers"
  "16_AntiPatterns/Copy_Paste_Programming"
  "16_AntiPatterns/Cargo_Cult"
  "16_AntiPatterns/Big_Ball_of_Mud"
  "16_AntiPatterns/Golden_Hammer"
  "16_AntiPatterns/Shotgun_Surgery"
  "16_AntiPatterns/Feature_Envy"
  "16_AntiPatterns/Long_Method"
  "16_AntiPatterns/Primitive_Obsession"
  "16_AntiPatterns/Anemic_Domain_Model"
  "16_AntiPatterns/Service_Locator"
  "16_AntiPatterns/Reinventing_the_Wheel"
  "16_AntiPatterns/Dependency_Hell"

  # 20_DDD
  "20_DDD/Bounded_Context"
  "20_DDD/Aggregates"
  "20_DDD/Value_Objects"
  "20_DDD/Entities"
  "20_DDD/Domain_Events"
  "20_DDD/Ubiquitous_Language"
  "20_DDD/Strategic_Design"
  "20_DDD/Tactical_Design"
  "20_DDD/Anti_Corruption_Layer"

  # 21_Cloud_Native
  "21_Cloud_Native/Twelve_Factor_App"
  "21_Cloud_Native/Sidecar"
  "21_Cloud_Native/Ambassador"
  "21_Cloud_Native/Edge_Computing"
  "21_Cloud_Native/Multi_Tenancy"
  "21_Cloud_Native/FinOps"

  # 22_AI_ML_Integration
  "22_AI_ML_Integration/Embeddings"
  "22_AI_ML_Integration/RAG"
  "22_AI_ML_Integration/Prompt_Engineering"
  "22_AI_ML_Integration/Agent_Patterns"
  "22_AI_ML_Integration/Tool_Calling"
  "22_AI_ML_Integration/LLM_API_Integration"
  "22_AI_ML_Integration/Model_Evaluation"
  "22_AI_ML_Integration/Vector_Search"
  "22_AI_ML_Integration/Streaming_Responses"
  "22_AI_ML_Integration/Cost_Latency_Optimization"

  # 23_Resilience_Engineering
  "23_Resilience_Engineering/Chaos_Engineering"
  "23_Resilience_Engineering/Fault_Injection"
  "23_Resilience_Engineering/Graceful_Degradation"
  "23_Resilience_Engineering/Backpressure"
  "23_Resilience_Engineering/Bulkhead"
  "23_Resilience_Engineering/Load_Shedding"
  "23_Resilience_Engineering/Game_Days"

  # 24_Data_Engineering
  "24_Data_Engineering/ETL_ELT"
  "24_Data_Engineering/Batch_vs_Streaming"
  "24_Data_Engineering/Data_Lake_Warehouse_Lakehouse"
  "24_Data_Engineering/Data_Quality"
  "24_Data_Engineering/Data_Pipelines"
  "24_Data_Engineering/Apache_Spark_Basics"
  "24_Data_Engineering/dbt"
  "24_Data_Engineering/Workflow_Orchestrators"

  # 25_Documentation
  "25_Documentation/Documentation_as_Code"
  "25_Documentation/C4_Model"
  "25_Documentation/PlantUML"
  "25_Documentation/Mermaid"
  "25_Documentation/Technical_Writing"
  "25_Documentation/Code_Review"
  "25_Documentation/Pair_Programming"
  "25_Documentation/Mentoring"

  # 26_Refactoring
  "26_Refactoring/Refactoring_Catalog"
  "26_Refactoring/Branch_by_Abstraction"
  "26_Refactoring/Parallel_Change"
)

for t in "${TOPICS[@]}"; do
  scaffold_topic "$t"
done

echo "Scaffolded ${#TOPICS[@]} topic folders. (FORCE=${FORCE})"
