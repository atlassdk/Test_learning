"""EVM bridge connector."""
from dataclasses import dataclass

@dataclass
class EVMConnector:
    chain: str = "base"
    chain_ids = {"ethereum": 1, "base": 8453, "arbitrum": 42161, "optimism": 10}
    rpc_urls = {"ethereum": "https://eth.llamarpc.com", "base": "https://mainnet.base.org", "arbitrum": "https://arb1.arbitrum.io/rpc", "optimism": "https://mainnet.optimism.io"}

    def __init__(self, chain: str = "base"):
        assert chain in self.chain_ids, f"Unsupported: {chain}"
        self.chain = chain

    @property
    def chain_id(self) -> int: return self.chain_ids[self.chain]
    @property
    def rpc_url(self) -> str: return self.rpc_urls[self.chain]
