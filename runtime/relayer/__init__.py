"""Cross-ecosystem message relayer with economic security."""
from dataclasses import dataclass, field
from typing import Optional
import time, uuid

@dataclass
class RelayedMessage:
    message_id: str; source: str; target: str; payload: dict
    status: str = "pending"
    guardian_approvals: list[str] = field(default_factory=list)
    created_at: float = field(default_factory=time.time)

class CrossChainRelayer:
    MIN_GUARDIAN_APPROVALS = 3
    def __init__(self, relayer_id: Optional[str] = None):
        self.relayer_id = relayer_id or f"relayer-{uuid.uuid4().hex[:8]}"
        self._messages: dict[str, RelayedMessage] = {}

    def relay(self, source: str, target: str, payload: dict) -> RelayedMessage:
        msg = RelayedMessage(message_id=f"msg-{uuid.uuid4().hex[:16]}", source=source, target=target, payload=payload)
        self._messages[msg.message_id] = msg
        return msg

    def approve(self, message_id: str, guardian_id: str) -> bool:
        msg = self._messages.get(message_id)
        if not msg: return False
        if guardian_id not in msg.guardian_approvals:
            msg.guardian_approvals.append(guardian_id)
        if len(msg.guardian_approvals) >= self.MIN_GUARDIAN_APPROVALS:
            msg.status = "approved"
        return True

    def get_message(self, message_id: str) -> Optional[RelayedMessage]:
        return self._messages.get(message_id)
