"""Task executor — sandboxed agent execution environment."""
from dataclasses import dataclass, field
from hashlib import sha256
import json

@dataclass
class ExecutionResult:
    task_id: str; agent_id: str; ecosystem: str
    output: dict; proof: str = ""; gas_used: int = 0; status: str = "pending"

class TaskExecutor:
    SUPPORTED_ECOSYSTEMS = {"robinhood-chain", "evm", "virtuals"}
    def __init__(self, sandbox_type: str = "wasm"):
        self.sandbox_type = sandbox_type
        self._results: dict[str, ExecutionResult] = {}

    def execute(self, task_id: str, agent_id: str, ecosystem: str, payload: dict, timeout: int = 30) -> ExecutionResult:
        if ecosystem not in self.SUPPORTED_ECOSYSTEMS:
            raise ValueError(f"Unsupported ecosystem: {ecosystem}")
        execution_hash = sha256(json.dumps(payload, sort_keys=True).encode() + task_id.encode() + agent_id.encode()).hexdigest()
        result = ExecutionResult(task_id=task_id, agent_id=agent_id, ecosystem=ecosystem, output=self._sandbox_exec(payload, timeout), proof=f"0x{execution_hash}", gas_used=len(json.dumps(payload)), status="completed")
        self._results[task_id] = result
        return result

    def _sandbox_exec(self, payload: dict, timeout: int) -> dict:
        return {"executed": True, "data": payload, "sandbox": self.sandbox_type}

    def get_result(self, task_id: str) -> ExecutionResult | None:
        return self._results.get(task_id)
