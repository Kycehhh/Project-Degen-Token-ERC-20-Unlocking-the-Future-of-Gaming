// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ShoeToken is ERC20, Ownable, ERC20Burnable {
    struct ShoeItem {
        string name;
        uint256 price;
        bool available;
    }

    ShoeItem[] public shoeItems;

    mapping(address => mapping(uint256 => uint256)) public userShoeBalances; // User address => Shoe item ID => Quantity

    constructor() ERC20("ShoeToken", "SHOE") {
        // Initialize with some shoe items
        shoeItems.push(ShoeItem("Running Shoes", 100 * 10**decimals(), true));
        shoeItems.push(ShoeItem("Basketball Shoes", 200 * 10**decimals(), true));
        shoeItems.push(ShoeItem("Casual Shoes", 150 * 10**decimals(), true));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function transferTokens(address receiver, uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Shoe Tokens");
        approve(msg.sender, value);
        transferFrom(msg.sender, receiver, value);
    }

    function burnTokens(uint256 value) external {
        require(balanceOf(msg.sender) >= value, "You do not have enough Shoe Tokens");
        burn(value);
    }

    function addShoeItem(string memory name, uint256 price) public onlyOwner {
        shoeItems.push(ShoeItem(name, price, true));
    }

    function purchaseShoeItem(uint256 itemId, uint256 quantity) external {
        require(shoeItems[itemId].available, "Shoe item not available");
        uint256 totalPrice = shoeItems[itemId].price * quantity;
        require(balanceOf(msg.sender) >= totalPrice, "You do not have enough Shoe Tokens");
        
        transfer(address(this), totalPrice);
        userShoeBalances[msg.sender][itemId] += quantity;
    }

    function redeemShoeItem(uint256 itemId, uint256 quantity) external {
        require(shoeItems[itemId].available, "Shoe item not available");
        require(userShoeBalances[msg.sender][itemId] >= quantity, "You do not have enough of this item to redeem");
        
        userShoeBalances[msg.sender][itemId] -= quantity;
        _mint(msg.sender, shoeItems[itemId].price * quantity);  // Mint tokens back to the user
    }
}
