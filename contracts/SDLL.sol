pragma solidity ^0.4.0;

import "dll/DLL.sol";
import "attrstore/AttributeStore.sol";

library SDLL {

  using DLL for DLL.Data;
  using AttributeStore for AttributeStore.Data;

  struct Data {
    AttributeStore.Data store;
		DLL.Data dll;

    string sortAttr;
  }

  /**********************
   * STATE CHANGING FUNCTIONS
   **********************/

  function insert(Data storage _self, uint _sortAttrVal, uint _prev, uint _new, uint _next)
  public {
    require(validatePosition(_self, _sortAttrVal, _prev, _next));

    _self.dll.insert(_prev, _new, _next);
    _self.store.setAttribute(keccak256(_new), _self.sortAttr, _sortAttrVal);
  }

	function remove(Data storage _self, uint _node) public {
    _self.dll.remove(_node);
  }

  function setAttr(Data storage _self, uint _node, string _attrName, uint _attrVal) public {
    require(keccak256(_attrName) != keccak256(_self.sortAttr));

    _self.store.setAttribute(keccak256(_node), _attrName, _attrVal);
  }

  /**********************
   * VIEW FUNCTIONS
   **********************/

  function getAttr(Data storage _self, uint _node, string _attrName) public view returns (uint) {
    return _self.store.getAttribute(keccak256(_node), _attrName);
  }

  function validatePosition(Data storage _self, uint _sortAttrVal, uint _prev, uint _next)
  public view returns (bool valid) {
    uint prevSortAttrVal = getAttr(_self, _prev, _self.sortAttr);
    uint nextSortAttrVal = getAttr(_self, _next, _self.sortAttr);

    if ((prevSortAttrVal <= _sortAttrVal) && ((_sortAttrVal <= nextSortAttrVal) || _next == 0)) {
        return true;
    }
    return false;
  }

  function getInsertPoint(Data storage _self, uint _sortAttrVal) public view returns (uint[2]) {
    uint currNode = 0;
    uint nextNode = _self.dll.getNext(currNode);
    uint[2] memory insertPoint = [currNode, nextNode];

    while((nextNode != 0) &&
          ((!(getAttr(_self, currNode, _self.sortAttr) <= _sortAttrVal)) || 
           (!(_sortAttrVal <= getAttr(_self, nextNode, _self.sortAttr)))
          )
         ) {
      currNode = nextNode;
      nextNode = _self.dll.getNext(currNode);
      insertPoint = [currNode, nextNode];
    }

    return insertPoint;
  }
}
