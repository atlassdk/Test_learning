# Atlas Smart Contract Architecture

## Interfaces

| Interface | Purpose |
|-----------|---------|
| IAtlasCore | Protocol entry, guardian management |
| IAgentRegistry | Agent identity & capabilities |
| ITaskManager | Task lifecycle (create→bid→execute→settle) |
| ISettlementEngine | Payment settlement & slashing |
| IAtlasBridge | Cross-ecosystem messaging |
