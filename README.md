# Liquidity-Pool
# Overview
- This project demonstrates a Solidity smart contract that integrates directly with Uniswap V2-style decentralized exchanges (tested on Arbitrum mainnet fork).  It provides a streamlined interface for:  **Swapping tokens, Adding liquidity with a single token or two tokens and Removing liquidity from a pool**.
The contract uses **OpenZeppelin’s SafeERC20** library to ensure safe token interactions.
# Key Features

- Token Swapping – Securely swap ERC20 tokens using the Uniswap V2 router.

- Single-Token Liquidity Provision – Provide liquidity using just one token (e.g., USDT), with the contract automatically handling the swap for the paired asset.

- Dual-Token Liquidity Provision – Add liquidity directly when holding both tokens in a pair.

- Liquidity Removal – Withdraw liquidity by burning LP tokens and reclaiming the underlying assets.

- Event Emission – Each operation emits clear events to support off-chain monitoring and analytics.

# Functional Overview

- Swap Tokens
    Enables seamless ERC20-to-ERC20 swaps through decentralized exchanges.

- Add Liquidity (Single Token)
    Allows users with only one asset (e.g., USDT) to participate in liquidity pools. The contract automatically swaps half into the paired token and supplies both.

- Add Liquidity (Dual Tokens)
    For users who already hold both assets, the contract provides a straightforward way to deposit liquidity and receive LP tokens.

- Remove Liquidity
    Lets users exit a pool and recover their deposited tokens, ensuring flexibility and control over liquidity positions.

