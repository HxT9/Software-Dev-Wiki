# Proposed Topics

Master list of every topic proposed for this wiki.

- ✅ written and at least at `draft` status — has a real file in the section.
- ⬜ proposed, not yet written.

A topic moves from ⬜ to ✅ when its file is created and the status frontmatter is `draft` or higher. To create a new topic from the template, run:

```bash
python tools/wiki.py new <NN_Section>/<Topic_Name>
```

See [TOPIC_TEMPLATE.md](./TOPIC_TEMPLATE.md) for the canonical structure.

---

## 01 Foundations

- ✅ [SOLID](../01_Foundations/SOLID/) — five OOP principles (SRP, OCP, LSP, ISP, DIP)
- ⬜ DRY_KISS_YAGNI — three rules that pull each other into balance
- ⬜ Coupling_Cohesion — the most important pair of design metrics
- ⬜ Separation_of_Concerns — different responsibilities, different modules
- ⬜ Law_of_Demeter — only talk to your direct neighbors
- ⬜ Composition_over_Inheritance — favor "has-a" over "is-a"
- ⬜ Fail_Fast — surface errors at the first opportunity
- ⬜ Principle_of_Least_Astonishment — code should match a reader's expectations
- ⬜ Encapsulation — hide internals, expose behavior
- ⬜ Code_Smells — early warning signs of bad design
- ⬜ Refactoring_Techniques — how to clean up safely
- ⬜ Naming_Conventions — names are the most-read part of code

## 02 Architecture

- ⬜ Layered_Architecture
- ⬜ Clean_Architecture
- ⬜ Microservices
- ⬜ Monolith
- ⬜ Event_Driven
- ⬜ CQRS
- ⬜ Event_Sourcing
- ⬜ Hexagonal_Architecture
- ⬜ Onion_Architecture
- ⬜ Modular_Monolith
- ⬜ BFF (Backend For Frontend)
- ⬜ Strangler_Fig
- ⬜ API_Gateway
- ⬜ Serverless
- ⬜ Plugin_Architecture

## 03 Design Patterns

### Creational
- ⬜ Singleton
- ⬜ Factory
- ⬜ Builder
- ⬜ Prototype
- ⬜ Abstract_Factory
- ⬜ Object_Pool

### Structural
- ⬜ Adapter
- ⬜ Decorator
- ⬜ Facade
- ⬜ Composite
- ⬜ Proxy
- ⬜ Bridge
- ⬜ Flyweight

### Behavioral
- ⬜ Observer
- ⬜ Strategy
- ⬜ Command
- ⬜ State
- ⬜ Iterator
- ⬜ Visitor
- ⬜ Mediator
- ⬜ Template_Method
- ⬜ Chain_of_Responsibility
- ⬜ Memento
- ⬜ Specification
- ⬜ Null_Object

### Concurrency
- ⬜ Producer_Consumer
- ⬜ Thread_Pool
- ⬜ Monitor
- ⬜ Active_Object

### Architectural
- ⬜ MVC
- ⬜ MVP
- ⬜ MVVM
- ⬜ Repository
- ⬜ Unit_of_Work

## 04 Concurrency

- ⬜ Threading
- ⬜ Async_Await
- ⬜ Race_Conditions
- ⬜ Deadlocks
- ⬜ Actor_Model
- ⬜ Reactive_Programming
- ⬜ Locks_Synchronization
- ⬜ Atomic_Lock_Free
- ⬜ Memory_Models
- ⬜ Coroutines
- ⬜ CSP
- ⬜ Livelock_Starvation
- ⬜ Concurrency_vs_Parallelism

## 05 Distributed Systems

- ⬜ CAP_Theorem
- ⬜ Consistency_Models
- ⬜ Idempotency
- ⬜ Retry_Patterns
- ⬜ Circuit_Breaker
- ⬜ Distributed_Transactions
- ⬜ PACELC
- ⬜ Consensus_Algorithms
- ⬜ Leader_Election
- ⬜ Distributed_Locks
- ⬜ Vector_Clocks
- ⬜ Two_Phase_Commit
- ⬜ Service_Discovery
- ⬜ Sharding
- ⬜ Replication
- ⬜ Quorum
- ⬜ Gossip_Protocols

## 06 Data Storage

- ⬜ Relational
- ⬜ NoSQL
- ⬜ Indexing
- ⬜ Transactions
- ⬜ ORM_vs_Raw
- ⬜ Schema_Migrations
- ⬜ Connection_Pooling
- ⬜ Normalization
- ⬜ ACID_vs_BASE
- ⬜ Database_Internals
- ⬜ N_Plus_One
- ⬜ CDC (Change Data Capture)
- ⬜ TimeSeries_DB
- ⬜ Graph_DB
- ⬜ Vector_DB
- ⬜ Search_Engines

## 07 Networking

- ⬜ HTTP_Deep_Dive
- ⬜ REST_vs_RPC
- ⬜ GraphQL
- ⬜ WebSockets
- ⬜ TLS_SSL
- ⬜ API_Design
- ⬜ gRPC
- ⬜ HTTP2_HTTP3
- ⬜ TCP_vs_UDP
- ⬜ DNS
- ⬜ Server_Sent_Events
- ⬜ WebRTC
- ⬜ mTLS
- ⬜ CORS
- ⬜ CDN
- ⬜ Reverse_Proxy
- ⬜ Webhooks
- ⬜ Rate_Limiting

## 08 Security

- ⬜ OWASP
- ⬜ Authentication
- ⬜ Authorization
- ⬜ OAuth2
- ⬜ JWT
- ⬜ Secure_Coding
- ⬜ OpenID_Connect
- ⬜ SAML
- ⬜ CSRF
- ⬜ XSS
- ⬜ SQL_Injection
- ⬜ Cryptography
- ⬜ Password_Hashing
- ⬜ Secret_Management
- ⬜ Zero_Trust
- ⬜ RBAC_ABAC_ReBAC
- ⬜ Container_Security
- ⬜ Supply_Chain_Security
- ⬜ SAST_DAST

## 09 Testing

- ⬜ Unit_Testing
- ⬜ Integration_Testing
- ⬜ E2E_Testing
- ⬜ TDD
- ⬜ Mocking
- ⬜ BDD
- ⬜ Property_Based_Testing
- ⬜ Mutation_Testing
- ⬜ Snapshot_Testing
- ⬜ Contract_Testing
- ⬜ Performance_Testing
- ⬜ Chaos_Testing
- ⬜ Test_Doubles
- ⬜ Test_Pyramid

## 10 DevOps

- ⬜ CI_CD
- ⬜ Docker
- ⬜ Kubernetes
- ⬜ Versioning
- ⬜ Deployment_Strategies
- ⬜ Infrastructure_as_Code
- ⬜ Configuration_Management
- ⬜ GitOps
- ⬜ Service_Mesh
- ⬜ Helm
- ⬜ Feature_Flags
- ⬜ Trunk_Based_Development
- ⬜ Monorepo_vs_Polyrepo
- ⬜ Pre_Commit_Hooks
- ⬜ Build_Systems

## 11 Performance

- ⬜ Profiling
- ⬜ Caching
- ⬜ Load_Balancing
- ⬜ Bottleneck_Analysis
- ⬜ Big_O_Applied
- ⬜ Memory_Leaks
- ⬜ CPU_vs_IO_Bound
- ⬜ Lazy_Loading
- ⬜ Pagination
- ⬜ Batch_Processing
- ⬜ Compression

## 12 Observability

- ⬜ Logging
- ⬜ Metrics
- ⬜ Tracing
- ⬜ Monitoring
- ⬜ Alerting
- ⬜ SLI_SLO_SLA
- ⬜ OpenTelemetry
- ⬜ APM
- ⬜ Error_Tracking
- ⬜ Log_Aggregation
- ⬜ Dashboard_Design
- ⬜ Incident_Response
- ⬜ On_Call

## 13 Integration

### Message Brokers
- ⬜ RabbitMQ
- ⬜ Kafka
- ⬜ NATS
- ⬜ Redis_Streams
- ⬜ AWS_SQS_SNS

### Patterns
- ⬜ PubSub
- ⬜ Saga
- ⬜ Event_Streaming
- ⬜ Outbox_Inbox
- ⬜ Dead_Letter_Queue
- ⬜ Competing_Consumers
- ⬜ Request_Reply
- ⬜ Schema_Registry

### Serialization
- ⬜ JSON
- ⬜ Protobuf
- ⬜ Avro
- ⬜ MessagePack

## 14 Languages

### C
- ⬜ Memory_Management
- ⬜ Pointers
- ⬜ Undefined_Behavior
- ⬜ Build_System
- ⬜ Standard_Library

### C++
- ⬜ Memory_Management
- ⬜ Concurrency
- ⬜ Templates
- ⬜ RAII
- ⬜ Move_Semantics
- ⬜ STL

### C#
- ⬜ Async
- ⬜ Internals
- ⬜ GC
- ⬜ LINQ
- ⬜ Span_T
- ⬜ Source_Generators

### Python
- ⬜ GIL
- ⬜ Asyncio
- ⬜ Type_Hints
- ⬜ Dataclasses
- ⬜ Packaging

### Rust
- ⬜ Ownership_Borrowing
- ⬜ Lifetimes
- ⬜ Traits
- ⬜ Async
- ⬜ Macros
- ⬜ Cargo

### TypeScript
- ⬜ Type_System
- ⬜ Generics
- ⬜ Type_Inference
- ⬜ Decorators
- ⬜ Modules
- ⬜ Compilation

### Java
- ⬜ JVM_Internals
- ⬜ GC
- ⬜ Concurrency
- ⬜ Streams_Lambdas
- ⬜ Reactive
- ⬜ Build_Tools

## 15 Algorithms & Data Structures

- ⬜ Data_Structures
- ⬜ Sorting
- ⬜ Searching
- ⬜ Practical_Use_Cases
- ⬜ Graph_Algorithms
- ⬜ Dynamic_Programming
- ⬜ Greedy
- ⬜ Divide_and_Conquer
- ⬜ Hash_Tables
- ⬜ Trees
- ⬜ Heaps
- ⬜ Probabilistic_Data_Structures
- ⬜ Skip_Lists
- ⬜ String_Algorithms
- ⬜ Big_O_Complexity

## 16 Anti-Patterns

- ⬜ God_Object
- ⬜ Spaghetti_Code
- ⬜ Premature_Optimization
- ⬜ Over_Engineering
- ⬜ Magic_Numbers
- ⬜ Copy_Paste_Programming
- ⬜ Cargo_Cult
- ⬜ Big_Ball_of_Mud
- ⬜ Golden_Hammer
- ⬜ Shotgun_Surgery
- ⬜ Feature_Envy
- ⬜ Long_Method
- ⬜ Primitive_Obsession
- ⬜ Anemic_Domain_Model
- ⬜ Service_Locator
- ⬜ Reinventing_the_Wheel
- ⬜ Dependency_Hell

## 20 Domain-Driven Design

- ⬜ Bounded_Context
- ⬜ Aggregates
- ⬜ Value_Objects
- ⬜ Entities
- ⬜ Domain_Events
- ⬜ Ubiquitous_Language
- ⬜ Strategic_Design
- ⬜ Tactical_Design
- ⬜ Anti_Corruption_Layer

## 21 Cloud Native

- ⬜ Twelve_Factor_App
- ⬜ Sidecar
- ⬜ Ambassador
- ⬜ Edge_Computing
- ⬜ Multi_Tenancy
- ⬜ FinOps

## 22 AI/ML Integration

- ⬜ Embeddings
- ⬜ RAG
- ⬜ Prompt_Engineering
- ⬜ Agent_Patterns
- ⬜ Tool_Calling
- ⬜ LLM_API_Integration
- ⬜ Model_Evaluation
- ⬜ Vector_Search
- ⬜ Streaming_Responses
- ⬜ Cost_Latency_Optimization

## 23 Resilience Engineering

- ⬜ Chaos_Engineering
- ⬜ Fault_Injection
- ⬜ Graceful_Degradation
- ⬜ Backpressure
- ⬜ Bulkhead
- ⬜ Load_Shedding
- ⬜ Game_Days

## 24 Data Engineering

- ⬜ ETL_ELT
- ⬜ Batch_vs_Streaming
- ⬜ Data_Lake_Warehouse_Lakehouse
- ⬜ Data_Quality
- ⬜ Data_Pipelines
- ⬜ Apache_Spark_Basics
- ⬜ dbt
- ⬜ Workflow_Orchestrators

## 25 Documentation & Communication

- ⬜ Documentation_as_Code
- ⬜ C4_Model
- ⬜ PlantUML
- ⬜ Mermaid
- ⬜ Technical_Writing
- ⬜ Code_Review
- ⬜ Pair_Programming
- ⬜ Mentoring

## 26 Refactoring

- ⬜ Refactoring_Catalog
- ⬜ Branch_by_Abstraction
- ⬜ Parallel_Change

---

## Progress

- **Total proposed**: 337
- **Written (✅)**: 1 (SOLID)
- **Pending (⬜)**: 336

To recompute live: `python tools/wiki.py status`.
