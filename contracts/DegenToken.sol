// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 price;
    }

    Item[] private storeItemsArray;
    mapping(string => uint256) private itemPrices;
    mapping(address => Item[]) private playerInventories;

    constructor() ERC20("Degen", "DGN") {
        console.log("Deploying DegenToken contract");

        _addStoreItem("Sword", 10);
        console.log("Sword added");

        _addStoreItem("Shield", 15);
        console.log("Shield added");

        _addStoreItem("Potion", 5);
        console.log("Potion added");

        console.log("DegenToken contract deployed successfully");
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        transfer(_receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "You do not have enough Degen Tokens");
        _burn(msg.sender, _value);
    }

    function _addStoreItem(string memory itemName, uint256 itemPrice) internal {
        console.log("Adding store item:", itemName, itemPrice);
        storeItemsArray.push(Item(itemName, itemPrice));
        itemPrices[itemName] = itemPrice;
        console.log("Store item added:", itemName, itemPrice);
    }

    function showStoreItems() external view returns (Item[] memory) {
        return storeItemsArray;
    }

    function redeemItem(string memory itemName) external {
        uint256 itemPrice = itemPrices[itemName];
        require(itemPrice > 0, "Item not found");
        require(balanceOf(msg.sender) >= itemPrice, "You do not have enough Degen Tokens to redeem this item");

        _burn(msg.sender, itemPrice);

        Item memory redeemedItem = Item(itemName, itemPrice);
        playerInventories[msg.sender].push(redeemedItem);
    }

    function getPlayerInventory() external view returns (Item[] memory) {
        return playerInventories[msg.sender];
    }
}
