// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    struct Item {
        string name;
        uint256 price;  
    }

    mapping(uint256 => Item) public items;
    mapping(uint256 => string) public itemMessages;

    event ItemRedeemed(address indexed user, uint256 indexed itemId, string itemName);

    constructor(uint256 initialSupply, uint8 decimals) ERC20('Degen', 'DGN') Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));

        // Predefined items
        addItem(1, "Stickers", 5, "You have bought the Stickers!");
        addItem(2, "Pins", 8, "You have bought the Pins!");
        addItem(3, "Keychains", 10, "You have bought the Keychains!");
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, amount);
    }

    function seeBalance() external view returns (uint256){
        return balanceOf(msg.sender);
    }

    function itemRedeem(uint256 itemId) public returns (string memory) {
        Item memory item = items[itemId];
        uint256 price = item.price;
        require(balanceOf(msg.sender) >= price, "Insufficient token balance");
        
        _burn(msg.sender, price);
        
        emit ItemRedeemed(msg.sender, itemId, item.name);
        
        return itemMessages[itemId];
    }

    function addItem(
        uint256 itemId, 
        string memory name, 
        uint256 price, 
        string memory message
    ) internal {
        items[itemId] = Item(name, price);
        itemMessages[itemId] = message;
    }
}
