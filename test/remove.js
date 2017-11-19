/* global artifacts contract describe assert it */

const TestSDLL = artifacts.require('TestSDLL.sol');

contract('SDLL', () => {
  describe('Function: remove', () => {
    it('Should remove a node from a list', async () => {
      const proxy = await TestSDLL.deployed();

      let insertVal = 10;
      let [prev, next] = await proxy.getInsertPoint.call(insertVal);
      await proxy.insert(insertVal, prev, next);
      insertVal = 100;
      [prev, next] = await proxy.getInsertPoint.call(insertVal);
      await proxy.insert(insertVal, prev, next);
      insertVal = 1;
      [prev, next] = await proxy.getInsertPoint.call(insertVal);
      await proxy.insert(insertVal, prev, next);
      insertVal = 50;
      [prev, next] = await proxy.getInsertPoint.call(insertVal);
      await proxy.insert(insertVal, prev, next);

      // <1/3, 10/1, 50/4, 100/2>

      await proxy.remove('1');
      // <1/3, 50/4, 100/2>

      [prev, next] = await proxy.getInsertPoint.call('25');
      assert.strictEqual(prev.toString(10), '3', 'expected prev to be 3');
      assert.strictEqual(next.toString(10), '4', 'expected next to be 4');
    });
  });
});

