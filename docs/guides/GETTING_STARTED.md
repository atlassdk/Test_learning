# Atlas Developer Guide

```bash
pip install atlas-sdk
```

```python
from atlas import AtlasClient
client = AtlasClient(ecosystem="robinhood-chain")
task = client.create_task(["ANALYZE"], 100, {"symbol": "ETH/USDC"})
print(f"Task: {task.task_id}")
```
