// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct ClothingItem {
        string name;
        uint256 price;
        bool available;
    }

    ClothingItem[] public clothingItems;

    mapping(address => mapping(uint256 => uint256)) public userClothingBalances; // User address => Clothing item ID => Quantity

    constructor() ERC20("Degen", "DGN") {
        // Initialize with some clothing items
        clothingItems.push(ClothingItem("Virtual Hat", 100 * 10**decimals(), true));
        clothingItems.push(ClothingItem("Virtual Shirt", 200 * 10**decimals(), true));
        clothingItems.push(ClothingItem("Virtual Pants", 150 * 10**decimals(), true));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address receiver, uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Degen Tokens");
        approve(msg.sender, value);
        transferFrom(msg.sender, receiver, value);
    }

    function burnTokens(uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Degen Tokens");
        burn(value);
    }

    function buyClothingItem(uint256 itemId, uint256 quantity) external {
        require(clothingItems[itemId].available, "Clothing item not available");
        uint256 totalPrice = clothingItems[itemId].price * quantity;
        require(balanceOf(msg.sender) >= totalPrice, "You do not have enough Degen Tokens");

        transfer(address(this), totalPrice);
        userClothingBalances[msg.sender][itemId] += quantity;
    }

    function redeemClothingItem(uint256 itemId, uint256 quantity) external {
        require(clothingItems[itemId].available, "Clothing item not available");
        uint256 totalPrice = clothingItems[itemId].price * quantity;
        require(userClothingBalances[msg.sender][itemId] >= quantity, "You do not have enough of this item to redeem");
        
        userClothingBalances[msg.sender][itemId] -= quantity;
        _mint(msg.sender, totalPrice);  // Mint tokens back to the user
    }

    function getClothingItem(uint256 itemId) external view returns (string memory, uint256, bool) {
        ClothingItem memory item = clothingItems[itemId];
        return (item.name, item.price, item.available);
    }

    function getUserClothingBalance(address user, uint256 itemId) external view returns (uint256) {
        return userClothingBalances[user][itemId];
    }

    function addClothingItem(string memory name, uint256 price) public onlyOwner {
        clothingItems.push(ClothingItem(name, price, true));
    }

    function setClothingItemAvailability(uint256 itemId, bool available) public onlyOwner {
        clothingItems[itemId].available = available;
    }
}
