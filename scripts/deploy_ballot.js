// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const proposolA = hre.ethers.encodeBytes32String("a")
  const proposolB = hre.ethers.encodeBytes32String("b")
  console.log(a)
  console.log(proposolB)
  const ballot = await hre.ethers.deployContract("Ballot", [proposolA, proposolB]);
  await ballot.waitForDeployment();

  console.log(`Ballot deployed to ${ballot.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
