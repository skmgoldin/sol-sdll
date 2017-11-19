/* global artifacts */

const SDLL = artifacts.require('./SDLL.sol');
const DLL = artifacts.require('dll/DLL.sol');
const AttributeStore = artifacts.require('attrstore/AttributeStore.sol');

module.exports = function (deployer) {
  deployer.deploy(DLL);
  deployer.deploy(AttributeStore);

  deployer.link(DLL, SDLL);
  deployer.link(AttributeStore, SDLL);

  deployer.deploy(SDLL);
};
