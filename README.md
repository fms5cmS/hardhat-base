[hardhat 官网](https://hardhat.org/)

[hardhat 中文官网](https://hardhat.cn/)

[ethers.js](https://docs.ethers.org/)

# 基本使用

```shell
# 清除编译缓存
yarn hardhat clean
```

## 初始化项目

在空目录下执行

```shell
# 初始化，之后全部回车即可
yarn init
# 添加 hardhat 依赖
yarn add --dev hardhat
# 使用 hardhat 来初始化项目结构、模版文件(js, ts)
yarn hardhat
```

## 编写合约文件

在 contracts 目录下编写智能合约。

## 编译合约

```shell
yarn hardhat compile
```

## 开启本地节点

可以以独立方式运行 Hardhat Network，以便外部客户端可以连接到它。

```shell
yarn hardhat node
```

## 部署合约

```shell
# hardhat 使用假的 RPC URL 和 private key 来部署、运行，而不需要在 deploy.js 再写了
yarn hardhat run scripts/deploy.js

# 在 hardhat.config.js 可以配置导出的网络，即使不配置，里面也会有一个默认的网络 hardhat
# 所以可以指定网络为配置的那些导出的网络，如默认的 hardhat
yarn hardhat run --network hardhat scripts/deploy.js 
# 如果要增加网络，在 hardhat.config.js 配置
```

如果使用默认的 Hardhat 网络部署，当 Hardhat 运行完成时，部署实际上是会丢失的！

相比 add.sol，ballot.sol 中合约的构造函数有参数，所以在部署脚本中需要设置初始的参数！

### 部署到远端网络

在 hardhat.config.js 文件中增加远端网络的配置信息

```javascript
const LOCAL_URL = "http://localhost:7545"
const LOCAL_ADDRESS = "0xC5B1B728C203EaD38b0b8d7d7267ef12a5523845"
const LOCAL_PRIVATE_KEY = "0xaa529b2ea31c96bed2a26e346f437b3fa7406e9e638d000c906fa952a44f4c83"

module.exports = {
  solidity: "0.8.19",
  networks: {
    local: {
      url: `${LOCAL_URL}`,
      accounts: [LOCAL_PRIVATE_KEY]
    }
  }
};
```

这里为了在本地测试，配置的是本地的信息，所以需要先使用 `yarn hardhat node` 开启一个本地节点，然后再 `yarn hardhat run scripts/deploy_vallot.js --network local` 进行部署。

注意：通过 `yarn hardhat node` 开启的本地节点，如果向其部署合约，再调用接口访问合约时会报错 未识别的 methodId，所以建议使用 [Ganache](https://github.com/trufflesuite/ganache-ui) 创建一个本地的区块链后再部署到上面，或直接部署到测试网上。

## 验证合约

验证合约也就意味着公布合约源码以及你的编译器设置，任何人都可以对其进行编译并生成字节码，从而与链上实际部署的字节码进行比较。

需要先在 [Etherscan](https://etherscan.io/) 注册登录后，获取 APIKey。

详见：https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify

## 测试合约

通常使用 [Chai](https://www.chaijs.com/) 进行测试。

```shell
yarn hardhat test test/add.js
```

# task

task 可以看作是是自动化脚本，Hardhat 内置的常用任务(可使用 `yarn hardhat` 查看)：

- `yarn hardhat compile` 编译 Solidity 智能合约
- `yarn hardhat test` 运行测试脚本
- `yarn hardhat run` 运行脚本
- `yarn hardhat clean` 清楚构建输出和缓存文件
- `yarn hardhat node` 启动本地开发节点

创建自定义 task，骑士就是往 hardhat.config.js 中添加代码。

> 注意，在 hardhat.congig.js 文件中不用也不能引入 hardhat 包

```javascript
// 第一个参数是任务名称
// 第二个参数是任务描述
// 第三个参数是一个异步函数，它在运行任务时执行
task("accounts", "Print the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});
```

添加完成后，在终端运行 `yarn hardhat` 就会发现多了一行：

```shell
accounts              Print the list of accounts
```

执行 `yarn hardhat accounts` 运行该任务。

