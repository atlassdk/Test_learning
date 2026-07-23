"""Example: Virtuals Protocol integration."""
from atlas import AtlasClient
task = AtlasClient(ecosystem="virtuals").create_task(["SENTIMENT"], 25, {"model": "gpt-4", "cross_ecosystem": True})
print(f"Virtuals task: {task.task_id}")
