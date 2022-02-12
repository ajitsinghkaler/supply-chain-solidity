// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract ItemManager{
    mapping(uint => S_item) public items;

    struct S_item {
        string _identifier;
        uint _itemPrice;
        SupplyChainState _state;
    }

    event SupplyChainStep(uint _itemIndex, uint _step);

    enum SupplyChainState{Created, Paid, Delivered}

    uint itemIndex;

    function createItem(string memory _identifier, uint _price) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _price;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item ha been already paid");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
    }

    function triggerDelivery(uint _itemIndex) public {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item ha been already paid");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
    }

}