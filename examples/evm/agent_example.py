"""Example: EVM agent registration."""
from atlas import AtlasClient
print(AtlasClient(ecosystem="evm").create_task(["ANALYSIS"], 10, {"chain": "base"}).task_id)
