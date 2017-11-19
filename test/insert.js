/* global artifacts contract describe assert it */

const TestSDLL = artifacts.require('TestSDLL.sol');

const SORT_ATTR = 'coolFactor';

const getNewNodeIDFromReceipt = (receipt) => {
  if (receipt.logs[0].event !== 'Inserted') {
    throw new Error('argumented provided to getNewNodeIDFromReceipt was not a receipt from an ' +
      'insert transaction');
  }
  return receipt.logs[0].args.nodeID;
};

contract('SDLL', () => {
  describe('Function: insert', () => {
    it('Should add a node to an empty list', async () => {
      const proxy = await TestSDLL.deployed();
      const insertVal = '10';

      const [prev, next] = await proxy.getInsertPoint.call(insertVal);
      assert.strictEqual(prev.toString(10), '0', 'expected prev to be 0');
      assert.strictEqual(next.toString(10), '0', 'expected next to be 0');

      const receipt = await proxy.insert(insertVal, prev, next);
      const newNodeID = getNewNodeIDFromReceipt(receipt);

      const coolFactor = await proxy.getAttr.call(newNodeID, SORT_ATTR);

      assert.strictEqual(coolFactor.toString(10), insertVal, 'was unable to add a value to an ' +
        'empty list');
    });

    it('Should add a node to the end of a list', async () => {
      const proxy = await TestSDLL.deployed();
      const insertVal = '100';

      const [prev, next] = await proxy.getInsertPoint.call(insertVal);
      assert.strictEqual(prev.toString(10), '1', 'expected prev to be 1');
      assert.strictEqual(next.toString(10), '0', 'expected next to be 0');

      const receipt = await proxy.insert(insertVal, prev, next);
      const newNodeID = getNewNodeIDFromReceipt(receipt);

      const coolFactor = await proxy.getAttr.call(newNodeID, SORT_ATTR);

      assert.strictEqual(coolFactor.toString(10), insertVal, 'was unable to add a value to the ' +
        'end of a list');
    });

    it('Should add a node to the beginning of a list', async () => {
      const proxy = await TestSDLL.deployed();
      const insertVal = '1';

      const [prev, next] = await proxy.getInsertPoint.call(insertVal);
      assert.strictEqual(prev.toString(10), '0', 'expected prev to be 0');
      assert.strictEqual(next.toString(10), '1', 'expected next to be 1');

      const receipt = await proxy.insert(insertVal, prev, next);
      const newNodeID = getNewNodeIDFromReceipt(receipt);

      const coolFactor = await proxy.getAttr.call(newNodeID, SORT_ATTR);

      assert.strictEqual(coolFactor.toString(10), insertVal, 'was unable to add a node at the ' +
        'beginning of a list');
    });

    it('Should add a node in the middle of a list', async () => {
      const proxy = await TestSDLL.deployed();
      const insertVal = '50';

      const [prev, next] = await proxy.getInsertPoint.call(insertVal);
      assert.strictEqual(prev.toString(10), '1', 'expected prev to be 1');
      assert.strictEqual(next.toString(10), '2', 'expected next to be 2');

      const receipt = await proxy.insert(insertVal, prev, next);
      const newNodeID = getNewNodeIDFromReceipt(receipt);

      const coolFactor = await proxy.getAttr.call(newNodeID, SORT_ATTR);

      assert.strictEqual(coolFactor.toString(10), insertVal, 'was unable to add a node in the ' +
        'middle of a list');
    });
  });
});

