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

## 部署合约

```shell
# hardhat 使用假的 RPC URL 和 private key 来部署、运行，而不需要在 deploy.js 再写了
yarn hardhat run scripts/deploy.js

# 在 hardhat.config.js 可以配置导出的网络，即使不配置，里面也会有一个默认的网络 hardhat
# 所以可以指定网络为配置的那些导出的网络，如默认的 hardhat
yarn hardhat run --network hardhat scripts/deploy.js 
# 如果要增加网络，在 hardhat.config.js 配置
```

相比 add.sol，ballot.sol 中合约的构造函数有参数，所以在部署脚本中需要设置初始的参数！

## 开启本地节点

可以以独立方式运行 Hardhat Network，以便外部客户端可以连接到它。

```shell
yarn hardhat node
```

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

