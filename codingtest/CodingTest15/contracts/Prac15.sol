// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TOKENA is ERC20("Token A", "A") {
    uint public price; // 토큰 개당 가격
    uint startTime; // 개시 시간

    constructor() {
        price = 0.001 ether;
        startTime = block.timestamp;
    }

    function decimals() public pure override returns(uint8) {
        return 0;
    }

    function buyTokenA() public payable returns(uint, uint) {
        if(block.timestamp - startTime > 2 * 24 * 60 * 60) price = 0.005 ether;

        uint newToken = msg.value / price;
        uint refund = msg.value % price;

        _mint(msg.sender, newToken);
        payable(msg.sender).transfer(refund);

        return (newToken, refund);
    }
}
