const stargateBridge = artifacts.require("../contracts/StargateBridge.sol");
module.exports = async (deployer) => {
  await deployer.deploy(stargateBridge);
};