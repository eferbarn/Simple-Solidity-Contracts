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
---
<h2>4. 💳 <a href="./Contracts/Crowdfunding.sol">Crowdfunding</a> </h2>

* This contract has the capability for you to attract capital through crowdfunding and accept any desired token as the base token.
* Modified on Wednesday, November 01, 2023
---
<h2>5. 💞 <a href="./Contracts/Lovers_Q&A.sol">Lovers Q&A</a> </h2>

* Ask a question and simultaneously send the question and its answer in secret and hashed form to the contract. Now it's your partner's turn to respond to your question. This contract has the capability for you to pose any number of questions within it, and your partner can respond to those questions. Whenever a question concludes (whether your partner answered it correctly or incorrectly), you can ask the next question.
* Modified on Wednesday, November 01, 2023
---
<h2>6. 💠 <a href="./Contracts/Batch_NFT_Transfer.sol">Batch NFT Transfer (safeTransferFrom)</a> </h2>

* Want to send lots of NFTs but got confused? No worries! Just deploy this contract and pass the NFT contract address through the constructor!
* Modified on Wednesday, November 03, 2023
---
<h2>7. 💠 <a href="./Contracts/Batch_NFT_Transfer_1155.sol">Batch NFT Transfer - 1155 Version</a> </h2>

* Everything is as the same as `6. Batch NFT Transfer`, but for ERC1155 standard!
* Modified on Wednesday, November 03, 2023
