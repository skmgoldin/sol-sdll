/* global artifacts */

const SDLL = artifacts.require('./SDLL.sol');
const TestSDLL = artifacts.require('TestSDLL.sol');

module.exports = function (deployer, network) {
  if (network === 'develop' || network === 'test') {
    deployer.link(SDLL, TestSDLL);

    deployer.deploy(TestSDLL, 'coolFactor');
  }
};
