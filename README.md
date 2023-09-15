# LazyNFT

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test                    // run test script
npx hardhat node                    // run hardhat ganache instance
npx hardhat run scripts/deploy.ts   // run deployment script
```

Building a web3 application that has off-chain components—e.g. applications like opensea or centralized exchanges—requires consolidation off-chain information and on-chain information. Attached is a standard NFT contract with lazy-minting that implements openzeppelin’s ERC-721 contract. With a language and database of your choice, build a simple off-chain marketplace for this NFT. The solution must include:

- A. Lazymint, mint, and transfer methods. A full RESTful api or equivalent is unnecessary. For example, in the case of the transfer method, the following will suffice:
  ```cpp
    // cpp
    void transferFrom(User A, User B, Token T) {  /** state mutation logic **/  }
  ```
  ```ts
    // ts
    const transferFrom = (A: User, B: User, Token: T) => {  /** state mutation logic **/  }
  ```
- B. A persistent database storing the information of users that interact with the contract. This can by mongodb, postgres, mysql, firestore, a csv or even a txt file, etc.
- C. Detect **off-platform** transactions. In other words, transactions that were not broadcast via the methods mentioned in A.

Bonus points if the solution for A does not involve waiting for finalization of transaction.