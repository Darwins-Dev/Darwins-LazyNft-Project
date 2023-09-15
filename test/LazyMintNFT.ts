import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { _TypedDataEncoder } from '@ethersproject/hash'

describe("LazyMintNFT", function () {
  async function deployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount, otherAccount2] = await ethers.getSigners();

    const LazyMintNFT = await ethers.getContractFactory("LazyNft");
    const contract = await LazyMintNFT.deploy(owner);

    return {contract, owner, otherAccount, otherAccount2 };
  }

  describe("testing", function () {
    it("lazy mint test", async () => {
      const { contract, owner, otherAccount } = await loadFixture(deployFixture);

      let domain = {
        name: "LazyMintedNFT",
        version: "1",
        verifyingContract: await contract.getAddress(),
        chainId: (await ethers.provider.getNetwork()).chainId
      }
      let types = {
        LazyMintedNFT: [
          {name: "tokenId", type: "uint256"},
          {name: "uri", type: "string"},  
          {name: "account", type: "address"},
        ]
      }
      let lazyMint = {
        tokenId: 0,
        uri: "hello world",
        account: await otherAccount.getAddress(),
      }
      let signature = await owner.signTypedData(domain, types, lazyMint)

      await expect(ethers.recoverAddress(ethers.TypedDataEncoder.hash(domain, types, lazyMint), signature)).to.eq(owner.address)
      await expect(contract.redeem(lazyMint.tokenId, lazyMint.account, lazyMint.uri, signature)).to.emit(contract, "Transfer")
      await expect(await contract.ownerOf("0x0")).to.equal(otherAccount.address)
    })

    it("mint test", async () => {
      const {contract ,owner, otherAccount} = await loadFixture(deployFixture)
      await expect(contract.mint(otherAccount.address, "0x1", "hello world 1")).to.emit(contract, "Transfer")
    })

    it("transfer test", async () => {
      const {contract, otherAccount, otherAccount2} = await loadFixture(deployFixture)
      await expect(contract.mint(otherAccount.address, "0x2", "hello world 2")).to.emit(contract, "Transfer")
      
      await expect(contract.connect(otherAccount).transferFrom(otherAccount.address, otherAccount2.address, "0x2")).to.emit(contract, "Transfer")
    })
  });
});
