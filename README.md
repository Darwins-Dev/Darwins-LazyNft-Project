# LazyNFT

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

When building a web3 application that has off-chain components—e.g. applications like opensea or centralized exchanges—need to consolidate off-chain information with on-chain information. Attached is a standard NFT contract with lazy-minting that implements openzeppelin’s ERC-721 contract. With a language and database of your choice, build a simple off-chain marketplace for this NFT. The solution must include:

- A. Lazymint, mint, and transfer methods. A full RESTful api or equivalent is unnecessary. For example, in the case of the transfer method.
  ```cpp
    void transferFrom(User A, User B) {  /** state mutation logic **/  }
  ```
  Or
  ```js
    const transferFrom = (A User, B User) => {  /** state mutation logic **/  }
  ```
  Will suffice.
- B. A persistent database storing information of users that interact with the contract. This can by mongodb, postgres, mysql, firestore, etc
- C. Detect **off-platform** transactions. In other words, transactions that were not broadcast via the methods mentioned in A.

Bonus points if the methods for A does not involve waiting for the finalization of a transaction.