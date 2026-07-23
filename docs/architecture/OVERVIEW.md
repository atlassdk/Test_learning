# Atlas Protocol — Architecture Overview

```
┌─────────────────────────────────────┐
│         Developer Layer              │
├─────────────────────────────────────┤
│        Coordination Layer            │
├─────────────────────────────────────┤
│        Execution Layer               │
├─────────────────────────────────────┤
│        Settlement Layer              │
├──────────┬──────────┬────────────────┤
│ Robinhood│   EVM    │   Virtuals     │
│ Chain    │  (ETH,   │   Protocol     │
│          │  Base,   │                │
│          │  Arbitrum)│                │
└──────────┴──────────┴────────────────┘
```

## Core Components

- **Contracts**: AtlasCore, AgentVault, TaskManager, Registry, Bridge
- **Runtime**: Executor (sandbox), Verifier (ZK), Relayer (cross-chain)
- **SDK**: Python, TypeScript, Rust
