// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // 生成合约构造函数的参数
  const aBytes = hre.ethers.toUtf8Bytes("a");
  const proposolA = hre.ethers.zeroPadValue(aBytes, 32)
  const bBytes = hre.ethers.toUtf8Bytes("b");
  const proposolB = hre.ethers.zeroPadValue(bBytes, 32)
  const proposolNames = [proposolA, proposolB]
  console.log(proposolNames)

  // 打印部署的账户
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // 部署合约
  const ballot = await hre.ethers.deployContract("Ballot", [proposolNames]);
  await ballot.waitForDeployment();
  // 打印合约地址
  console.log(`Ballot deployed to ${ballot.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
