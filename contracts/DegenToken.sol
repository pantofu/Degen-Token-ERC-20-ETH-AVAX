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
    uint256 public itemCount;

    constructor(uint256 initialSupply, uint8 decimals) ERC20('Degen', 'DGN') Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));


        //Items
        addItem(1, "Stickers", 5, "You have bought the Stickers!");
        addItem(2, "Pins", 8, "You have bought the Pins!");
        addItem(3, "Keychains", 10, "You have bought the Keychains!");
    }
    
    // Only the contract owner can mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    
    // Any user can burn their tokens
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
        uint256 price = items[itemId].price;
        require(balanceOf(msg.sender) >= price, "Insufficient token balance");
        
        _burn(msg.sender, price);
        
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
        itemCount++;
    }
}
