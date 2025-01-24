// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract A is ERC20("A token", "A") {
    function decimals() public pure override returns(uint8){
        return 0;
    }
    function mint(uint _n) public {
        _mint(msg.sender, _n);
    }
}

contract B is ERC20("B token", "B") {
    function decimals() public pure override returns(uint8){
        return 0;
    }
    function mint(uint _n) public {
        _mint(msg.sender, _n);
    }
}

contract CPMM is ERC20("ABLP token", "ABLP") {
    event Warning(string message, uint a, uint b); // 2.5:1이 되면 발생

    ERC20 public token_a;
    ERC20 public token_b;

    constructor(address _a, address _b, uint _initA, uint _initB, uint _initLP) {
        token_a = ERC20(_a);
        token_b = ERC20(_b);

        A(address(token_a)).mint(_initA);
        B(address(token_b)).mint(_initB);
        _mint(msg.sender, _initLP);
    }

    function decimals() public pure override returns(uint8){
        return 0;
    }

    function getBalance() public view returns(uint, uint) {
        uint bal_a = token_a.balanceOf(address(this));
        uint bal_b = token_b.balanceOf(address(this));

        return (bal_a, bal_b);
    }

    function getK() public view returns(uint) {
        (uint bal_a, uint bal_b) = getBalance();

        return bal_a * bal_b;
    }

    // LP provide
    function addLiquidity(address _token, uint _n) public {
        (uint bal_a, uint bal_b) = getBalance();
        bool isA = _token == address(token_a);

        if(isA) {
            uint _m = _n * bal_b / bal_a;

            token_a.transferFrom(tx.origin, address(this), _n);
            token_b.transferFrom(tx.origin, address(this), _m);

            uint _x = totalSupply() * _n / bal_a;

            _mint(msg.sender, _x);
        } else {
            uint _m = _n * bal_a / bal_b;

            token_a.transferFrom(tx.origin, address(this), _m);
            token_b.transferFrom(tx.origin, address(this), _n);

            uint _x = totalSupply() * _n / bal_b;

            _mint(msg.sender, _x);
        }
    }

    // LP withdraw
    function withLiquidity(uint _n) public {
        (uint bal_a, uint bal_b) = getBalance();

        uint _a = _n * bal_a / totalSupply();
        uint _b = _n * bal_b / totalSupply();

        _burn(msg.sender, _n);

        token_a.transfer(msg.sender, _a);
        token_b.transfer(msg.sender, _b);
    }

    // Swap
    // 81492 70862 49290
    function _swap(address _token, uint _n) private {
        (uint bal_a, uint bal_b) = getBalance();

        uint k = bal_a * bal_b;

        bool isA = _token == address(token_a);

        if(isA) {
            uint out = bal_b - k / (bal_a+_n) * 999 / 1000;
            token_a.transferFrom(msg.sender, address(this), _n);
            token_b.transfer(msg.sender, out);
        } else {
            uint out = bal_a - k / (bal_b+_n) * 999 / 1000;
            token_b.transferFrom(msg.sender, address(this), _n);
            token_a.transfer(msg.sender, out);
        }
    }

    // 가스비: 81317 70710 49138
    function swap(address _token, uint _n) public {
        (uint bal_a, uint bal_b) = getBalance();

        bool isA = _token == address(token_a);

        if(isA) {
            // uint out = bal_b - k / (bal_a+_n) * 999 / 1000;
            uint out = (_n * bal_b) * 999 / (bal_a+_n) / 1000;
            token_a.transferFrom(msg.sender, address(this), _n);
            token_b.transfer(msg.sender, out);
            if(_n * 25 >= out * 10)
                emit Warning("The price ratio exceeds (TokenA : TokenB ~ 2.5 : 1)", _n, out);
        } else {
            // uint out = bal_a - k / (bal_b+_n) * 999 / 1000;
            uint out = (_n * bal_a) * 999 / (bal_b+_n) / 1000;
            token_b.transferFrom(msg.sender, address(this), _n);
            token_a.transfer(msg.sender, out);
            if(out * 25 >= _n * 10)
                emit Warning("The price ratio exceeds (TokenA : TokenB ~ 2.5 : 1)", out, _n);
        }        
    }
}
