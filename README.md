# DegenToken

DegenToken is a Solidity smart contract that implements an ERC20 token named "Degen" (symbol: DGN). It provides functionalities for token creation, minting, transferring, burning, and a store where tokens can be redeemed for items. This contract uses the OpenZeppelin library for ERC20 and Ownable functionalities.

## Features

- **ERC20 Token:** Implements the ERC20 standard with a fixed decimal of 0.
- **Minting:** Allows minting of new tokens by the contract owner.
- **Transfers:** Supports transferring tokens between accounts.
- **Burning:** Enables burning (destroying) tokens.
- **Store System:** Includes a built-in store where tokens can be redeemed for predefined items.

## Getting Started

### Prerequisites

To compile and deploy this contract, you will need:

- Remix IDE or another Solidity development environment.

### Compilation

1. **Open Remix IDE:**
   - Navigate to [Remix IDE](https://remix.ethereum.org/).
   
2. **Create a New File:**
   - Click on the "+" icon in the left-hand sidebar.
   - Save the file with a `.sol` extension (e.g., `DegenToken.sol`).

3. **Copy the Solidity Code:**

   ```solidity
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


## Deployment

### Deploy the Contract

1. **Connect to Metamask:**
   - Ensure that your account is connected to the Metamask wallet.

2. **Deploy the Contract:**
   - Click on the "Deploy & Run Transactions" tab in the left-hand sidebar.
   - Select the "DegenToken" contract from the dropdown menu.
   - Click on the "Deploy" button.

## Interacting with the Contract

Once deployed, interact with the contract using the following functions:

- **Mint Tokens:** Call the `mint` function with the recipient address and amount.
- **Check Balance:** Call the `getBalance` function to check the balance of any address.
- **Transfer Tokens:** Call the `transferTokens` function with the recipient address and amount.
- **Burn Tokens:** Call the `burnTokens` function with the amount to burn.
- **Show Store Items:** Call the `showStoreItems` function to view available store items.
- **Redeem Item:** Call the `redeemItem` function with the item name to redeem an item using tokens.

## Authors

- **Vikash Kumar Singh**

## License

This project is licensed under Vikash Kumar Singh.
