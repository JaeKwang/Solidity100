/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');

const PVK = PRIVATE_KEY

module.exports = {
  solidity: "0.8.28",

  networks : {
    sepolia : {
      url: `https://sepolia.infura.io/v3/API_KEY`,
      accounts: [PVK]
    }
  },

  etherscan : {
    apiKey : 'API_KEY',
  }
};
