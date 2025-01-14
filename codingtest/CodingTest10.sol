// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
A라고 하는 erc-20(decimal 0)을 발행하고, B라는 NFT를 발행하십시오.
A 토큰은 개당 0.001eth 정가로 판매한다.
B NFT는 오직 A로만 구매할 수 있고 가격은 50으로 시작합니다.
첫 10명은 50A, 그 다음 20명은 100A, 그 다음 40명은 200A로 가격이 상승합니다. (추가는 안해도 됨)

B를 burn 하면 20 A만큼 환불 받을 수 있고, 만약에 C라고 하는 contract에 전송하면 30A 만큼 받는 기능도 구현하세요.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract A is ERC20 {
    address owner;

    constructor(uint256 initialSupply) ERC20("TokenA", "TKA") {
        owner = msg.sender;
        _mint(msg.sender, initialSupply); // 20000
    }
    
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // A 토큰은 개당 0.001eth 정가로 판매한다.
    function swapEtA() public payable {
        if (_msgSender() == address(0))
            revert ERC20InvalidReceiver(address(0));
        
        uint price = 10**15; // 정가 1000000000000000 wei
        
        // 환전
        uint value = msg.value / price; // 환전액
        _update(owner, _msgSender(), value);
        
        // 거스름돈 환불
        uint refund = msg.value % price; // 환불액
        if(refund > 0) payable(msg.sender).transfer(refund);
    }
}

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract B is ERC721 {
    IERC20 tokenA; // A 토큰 인터페이스
    uint tokenIdCounter; // 토큰 ID
    uint currentPrice = 50; // 현재 가격 (50 A 시작)
    uint buyersCount; // 구매자 수 카운터
    mapping(uint256 => bool) public burned; // 소각된 NFT 여부

    constructor(address _tokenA) ERC721("TokenB", "TKB") {
        tokenA = IERC20(_tokenA); // A 토큰 주소 설정
    }

    function buyNFT() public {
        require(tokenA.balanceOf(msg.sender) >= currentPrice, "Insufficient A tokens");
        require(tokenA.allowance(msg.sender, address(this)) >= currentPrice, "Approve the required A tokens");

        // 토큰 받기
        tokenA.transferFrom(msg.sender, address(this), currentPrice);

        // NFT 발행
        uint256 tokenId = tokenIdCounter;
        _mint(msg.sender, tokenId);
        burned[tokenId] = false;
        tokenIdCounter++;
        
        // 가격 올려치기
        buyersCount++;
        if (buyersCount == 10) currentPrice = 100;
        else if (buyersCount == 30) currentPrice = 200;
    }

    function burnNFT(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(!burned[_tokenId], "NFT already burned");

        _burn(_tokenId);
        burned[_tokenId] = true;
        
        // 환불
        tokenA.transfer(msg.sender, 20);
    }

    function sendNFT(address _addr, uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner");
        _transfer(msg.sender, _addr, _tokenId);

        // C 컨트랙트?
        
        // 30 A 지급
        tokenA.transfer(msg.sender, 30);
    }
}

// B를 burn 하면 20 A만큼 환불 받을 수 있고, 만약에 C라고 하는 contract에 전송하면 30A 만큼 받는 기능도 구현하세요.
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
contract C is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) public override returns (bytes4){
        return 0x00;
    }
}
