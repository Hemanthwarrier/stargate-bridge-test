const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config();
const mnemonic = process.env.MNEMONIC;
const token = process.env.INFURA_TOKEN;
let privateKeys = [process.env.PRIVATE_KEY];

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "999",
      websockets: true,
    },
    rinkeby: {
      network_id: "4",
      provider: () => {
        return new HDWalletProvider(mnemonic, token);
      },
      gasPrice: 75000000000, // 75 Gwei
      networkCheckTimeout: 10000000,
      skipDryRun: true,
    },
    mainnet: {
      provider: () => {
        return new HDWalletProvider(privateKeys, token);
      },
      network_id: "1",
      //  gasPrice: 40000000000, // 115 Gwei
      networkCheckTimeout: 1000000000000, //3 zero added
      gas: 2656227,
    },
    polygon: {
      host: "localhost",
      port: 8546,
      network_id: "80001",
      websockets: true,
    },
  },
  plugins: ["truffle-contract-size"],
  compilers: {
    solc: {
      version: "0.8.1",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
        evmVersion: "petersburg",
      },
    },
  },
  plugins: ["truffle-contract-size"],
};