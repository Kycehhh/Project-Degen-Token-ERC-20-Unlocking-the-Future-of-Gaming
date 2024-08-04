// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct CarItem {
        string name;
        uint256 price;
        bool available;
    }

    CarItem[] public carItems;

    mapping(address => mapping(uint256 => uint256)) public userCarBalances; // User address => Car item ID => Quantity

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        // Initialize with some car items
        carItems.push(CarItem("Sedan", 10000 * 10**decimals(), true));
        carItems.push(CarItem("SUV", 20000 * 10**decimals(), true));
        carItems.push(CarItem("Truck", 30000 * 10**decimals(), true));
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

    function buyCarItem(uint256 itemId, uint256 quantity) external {
        require(carItems[itemId].available, "Car item not available");
        uint256 totalPrice = carItems[itemId].price * quantity;
        require(balanceOf(msg.sender) >= totalPrice, "You do not have enough Degen Tokens");

        transfer(address(this), totalPrice);
        userCarBalances[msg.sender][itemId] += quantity;
    }

    function redeemCarItem(uint256 itemId, uint256 quantity) external {
        require(carItems[itemId].available, "Car item not available");
        uint256 totalPrice = carItems[itemId].price * quantity;
        require(userCarBalances[msg.sender][itemId] >= quantity, "You do not have enough of this item to redeem");
        
        userCarBalances[msg.sender][itemId] -= quantity;
        _mint(msg.sender, totalPrice);  // Mint tokens back to the user
    }

    function getCarItem(uint256 itemId) external view returns (string memory, uint256, bool) {
        CarItem memory item = carItems[itemId];
        return (item.name, item.price, item.available);
    }

    function getUserCarBalance(address user, uint256 itemId) external view returns (uint256) {
        return userCarBalances[user][itemId];
    }

    function addCarItem(string memory name, uint256 price) public onlyOwner {
        carItems.push(CarItem(name, price, true));
    }

    function setCarItemAvailability(uint256 itemId, bool available) public onlyOwner {
        carItems[itemId].available = available;
    }
}
