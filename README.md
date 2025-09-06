# 💧 Liquidity-Pool

- This project demonstrates a **Solidity smart contract** that integrates directly with Uniswap V2-style decentralized exchanges (tested on Arbitrum mainnet fork).  It provides a streamlined interface for:  **Swapping tokens, Adding liquidity with a single token or two tokens and Removing liquidity from a pool**.
The contract uses **OpenZeppelin’s SafeERC20** library to ensure safe token interactions.

# 🔑 Key Features

- **Token Swapping** – Securely swap ERC20 tokens using the Uniswap V2 router.

- **Single-Token Liquidity Provision** – Provide liquidity using just one token (e.g., USDT), with the contract automatically handling the swap for the paired asset.

- **Dual-Token Liquidity Provision** – Add liquidity directly when holding both tokens in a pair.

- **Liquidity Removal** – Withdraw liquidity by burning LP tokens and reclaiming the underlying assets.

- **Event Emission** – Each operation emits clear events to support off-chain monitoring and analytics.

# ⚡ Functional Overview

- **Swap Tokens**
    Enables seamless ERC20-to-ERC20 swaps through decentralized exchanges.

- **Add Liquidity** (Single Token)
    Allows users with only one asset (e.g., USDT) to participate in liquidity pools. The contract automatically swaps half into the paired token and supplies both.

- **Add Liquidity** (Dual Tokens)
    For users who already hold both assets, the contract provides a straightforward way to deposit liquidity and receive LP tokens.

- **Remove Liquidity**
    Lets users exit a pool and recover their deposited tokens, ensuring flexibility and control over liquidity positions.

# 🛠️ Skills Needed

- Smart contract development in Solidity

- Integration with Uniswap V2 protocol

- DeFi mechanics: token swaps, liquidity pools, LP tokens

- Mainnet fork testing with Foundry

- Secure ERC20 handling with OpenZeppelin libraries

# 🧪 Testing

This project includes a comprehensive Foundry test suite executed against an Arbitrum mainnet fork, ensuring realistic and reliable results.

Each test validates core contract functionality under real-world conditions:

✅ **Contract Deployment**
Verifies that the contract is deployed correctly with the expected router and factory addresses.

✅ **Token Swap**
Confirms that a user can successfully swap USDT → DAI, checking balance changes before and after the transaction.

✅ **Add Liquidity (Single Token)**
Tests the process where a user provides only USDT; the contract automatically swaps half into DAI and adds both into the pool.

✅ **Add Liquidity (Dual Tokens)**
Validates liquidity provision when the user holds both USDT and DAI, ensuring LP tokens are issued correctly.

✅ **Remove Liquidity**
Ensures a user can withdraw liquidity by redeeming LP tokens, correctly receiving back USDT and DAI.

**100% covered in Testing**

<img width="685" height="196" alt="image" src="https://github.com/user-attachments/assets/1917c0e3-1eb1-4f2f-8259-40d590f5397f" />


This testing approach demonstrates not only functionality but also real integration with live DeFi protocols under mainnet conditions.

