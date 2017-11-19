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

  /**
  @dev Inserts a new node between _prev and _next. Throws if the provided _sortAttrVal is not
  between the sortAttr values of _prev and _next.
  @param _sortAttrVal the sortAttr value which will be attached to the new node
  @param _prev the node which _new will be inserted after
  @param _new the id of the new node being inserted
  @param _next the node which _new will be inserted before
  */
  function insert(Data storage _self, uint _sortAttrVal, uint _prev, uint _new, uint _next)
  public {
    require(validatePosition(_self, _sortAttrVal, _prev, _next));

    _self.dll.insert(_prev, _new, _next);
    _self.store.setAttribute(keccak256(_new), _self.sortAttr, _sortAttrVal);
  }

  /**
  @dev Removes a node from a dll. Does not delete any associated data from the store.
  @param _node the node to remove from the list
  */
  function remove(Data storage _self, uint _node) public {
    _self.dll.remove(_node);
  }

  /**
  @dev Add or change an attribute associated with a given node. You cannot change the attribute
  whose _attrName is the list's sortAttr. To update a node's sortAttr, you must remove the node
  and re-insert it.
  @param _node the node whose attribute store is being updated
  @param _attrName the node attribute whose value is being updated
  @param _attrVal the new value for the provided node attribute
  */
  function setAttr(Data storage _self, uint _node, string _attrName, uint _attrVal) public {
    require(keccak256(_attrName) != keccak256(_self.sortAttr));

    _self.store.setAttribute(keccak256(_node), _attrName, _attrVal);
  }

  /**********************
   * VIEW FUNCTIONS
   **********************/

  /**
  @dev Read an attribute for a specific node.
  @param _node the node whose attribute store is being inspected
  @param _attrName the node attribute whose value is being read
  @return the value stored at the provided node's provided attribute
  */
  function getAttr(Data storage _self, uint _node, string _attrName) public view returns (uint) {
    return _self.store.getAttribute(keccak256(_node), _attrName);
  }

  /**
  @dev Determines whether a value can be inserted between two nodes. _prev and _next must be
  adjacent nodes.
  @param _sortAttrVal the value to determine whether it can be inserted between _prev and _next
  @param _prev the node adjacent to _next
  @param _next the node adjacent to _prev
  @return true if _prev and _next are the proper insertion points for the provided _sortAttrVal,
  false otherwise
  */
  function validatePosition(Data storage _self, uint _sortAttrVal, uint _prev, uint _next)
  public view returns (bool valid) {
    require(_self.dll.getNext(_prev) == _next);
    require(_self.dll.getPrev(_next) == _prev);

    uint prevSortAttrVal = getAttr(_self, _prev, _self.sortAttr);
    uint nextSortAttrVal = getAttr(_self, _next, _self.sortAttr);

    if ((prevSortAttrVal <= _sortAttrVal) && ((_sortAttrVal <= nextSortAttrVal) || _next == 0)) {
        return true;
    }
    return false;
  }

  /**
  @dev Determines an insert point where the provided _sortAttrVal may be inserted.
  @param _sortAttrVal the value to determine an insert point for
  @return a uint[2]. The first uint is the prev value, the second uint is the next value.
  */
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
