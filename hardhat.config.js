require("dotenv").config();

require("@nomiclabs/hardhat-ethers")
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("solidity-coverage");
require ("hardhat-deploy");



const KOVAN_RPC_URL =
    process.env.KOVAN_RPC_URL ||
    "https://eth-mainnet.alchemyapi.io/v2/your-api-key"
const RINKEBY_RPC_URL =
    process.env.RINKEBY_RPC_URL || "https://eth-mainnet.alchemyapi.io/v2/your-api-key"
    
const PRIVATE_KEY =
    process.env.PRIVATE_KEY ||
    "7fba7e7dcb79b64511fafada132d2155f6f9dec16510b3609c2a360d31c8bb19"

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
        {
            version: "0.8.15",
        },
        {
            version: "0.8.9",
        },
    ],
},
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      // gasPrice: 130000000000,
  },
  kovan: {
      url: KOVAN_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 42,
      blockConfirmations: 6,
  },
  rinkeby: {
      url: RINKEBY_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 4,
      blockConfirmations: 8,
    },
  },
  gasReporter: {
    enabled: true,
    outputFile : "gas_reporter.txt",
    noColors: true,
    currency: "USD",
    token: "MATIC"
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  namedAccounts: {
    deployer: {
        default: 0, // here this will by default take the first account as deployer
        1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
   },
   mocha: {
    timeout: 300000,
   },
};

