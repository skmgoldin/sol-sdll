pragma solidity^0.4.0;

import "./SDLL.sol";

contract TestSDLL {
  event Inserted(uint nodeID);

  using SDLL for SDLL.Data;
  SDLL.Data sdll;

  uint nonce;

  function TestSDLL(string _sortAttr) public {
    nonce = 1;
    sdll.sortAttr = _sortAttr;
  }

  function insert(uint _sortAttrVal, uint _prev, uint _next) public returns (uint nodeID) {
    sdll.insert(_sortAttrVal, _prev, nonce, _next);
    Inserted(nonce);

    nonce = nonce + 1;

    return nonce;
  }

  function getAttr(uint _node, string _attrName) public view returns (uint) {
    return sdll.getAttr(_node, _attrName);
  }

  function getInsertPoint(uint _sortAttrVal) public view returns (uint[2]) {
    return sdll.getInsertPoint(_sortAttrVal);
  }

	function remove(uint _node) public {
    sdll.remove(_node);
  }
}
