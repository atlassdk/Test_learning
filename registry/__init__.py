"""Agent registry and reputation system."""
from dataclasses import dataclass, field
from typing import Optional
import time

@dataclass
class AgentRecord:
    agent_id: str; owner: str; name: str; capabilities: list[str]
    ecosystem: str; reputation_score: float = 0.0
    total_tasks: int = 0; successful_tasks: int = 0
    active: bool = True; registered_at: float = field(default_factory=time.time)

class AgentRegistry:
    def __init__(self):
        self._agents: dict[str, AgentRecord] = {}

    def register(self, agent_id: str, owner: str, name: str, capabilities: list[str], ecosystem: str) -> AgentRecord:
        record = AgentRecord(agent_id=agent_id, owner=owner, name=name, capabilities=capabilities, ecosystem=ecosystem)
        self._agents[agent_id] = record
        return record

    def get_agent(self, agent_id: str) -> Optional[AgentRecord]:
        return self._agents.get(agent_id)

    def get_agents_by_ecosystem(self, ecosystem: str) -> list[AgentRecord]:
        return [a for a in self._agents.values() if a.ecosystem == ecosystem]

    def search_by_capability(self, capability: str) -> list[AgentRecord]:
        return [a for a in self._agents.values() if capability in a.capabilities]

    def update_reputation(self, agent_id: str, success: bool) -> None:
        agent = self._agents.get(agent_id)
        if agent:
            agent.total_tasks += 1
            if success: agent.successful_tasks += 1
            agent.reputation_score = agent.successful_tasks / agent.total_tasks * 100.0 if agent.total_tasks > 0 else 0.0
