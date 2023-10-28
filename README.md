# Simple Solidity Contracts
<h2>You can find some handy examples of Solidity contracts here!</h2>
🔮 I hope they will be inspirational! 
<br>
<br>
<h2>1. 🗳 <a href="./Contracts/Proposals_And_Voting.sol">Proposals And Voting</a> </h2>

* A simple implementation of a DAO
* Modified on Sunday, October 29, 2023
---
<h2>2. 🎲 <a href="./Contracts/Rand_Between.sol">Simple "Rand-Between" Contract</a> </h2>

* **⚠️ Use with Caution**; Since the Ethereum blockchain and its derivatives are considered deterministic systems, this type of implementation lacks reliable randomness, in other words, we don't have a VRF (Verifiable Random Function). Therefore, it's better not to use this kind of implementation if you have contracts that handle significant amounts of money.
* Modified on Sunday, October 29, 2023
---
<h2>3. 🎰 <a href="./Contracts/CommitReveal_Rand_Between.sol">Commit/Reveal Schema for "Rand-Between"</a> </h2>

* Relative to a simple random approach, this method is better as it is both cost-effective and highly reliable. If you do not want to use tools like ChainlinkVRF, this method will help you.
* Modified on Sunday, October 29, 2023
