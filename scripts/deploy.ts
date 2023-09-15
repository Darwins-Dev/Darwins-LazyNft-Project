import { ethers } from "hardhat";

async function main() {
  const signers = await ethers.getSigners()
  const contract = await ethers.deployContract("LazyNft", [signers[0].address],);

  await contract.waitForDeployment();

  console.log("deployed at "+await contract.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
