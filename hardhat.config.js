require("@nomicfoundation/hardhat-toolbox");

const LOCAL_URL = "http://localhost:7545"
const LOCAL_ADDRESS = "0xC5B1B728C203EaD38b0b8d7d7267ef12a5523845"
const LOCAL_PRIVATE_KEY = "0xaa529b2ea31c96bed2a26e346f437b3fa7406e9e638d000c906fa952a44f4c83"

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    local: {
      url: `${LOCAL_URL}`,
      accounts: [LOCAL_PRIVATE_KEY]
    }
  }
};

// 创建自定义 task
task("accounts", "Print the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});