// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 81. Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.  
contract Q81 {
    mapping(address => uint) balance;

    function deposit() public payable {
        require(msg.sender != address(0), "Required Address");
        balance[msg.sender] += msg.value;
    }
    function withdraw(uint _n) public payable {
        require(balanceOf(msg.sender) >= _n, "Insufficient balance");
        payable(msg.sender).transfer(_n);
    }
    function withdrawAll(address _addr) public payable {
        require(_addr == msg.sender, "Only allowed by owner");
        payable(_addr).transfer(balanceOf(_addr));
    }
    function balanceOf(address _addr) public view returns (uint) {
        return balance[_addr];
    }
}

// 82. 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
contract Q82 {
    function getTimes358(uint _n) public pure returns (uint, uint, uint) {
        return (_n/3, _n/5, _n/8);
    }
}

// 83. 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요.
// 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
contract Q83 {
    struct Man {
        string name;
        uint number;
        address addr;
        mapping(uint => string) data;
    }

    Man[] mans;
    
    function pushMan(string calldata _name, address _addr, uint[] calldata _key, string[] calldata _value) public {
        require(_key.length == _value.length, "Not matched array length (key, value)");
        Man storage newMan = mans.push();
        newMan.name = _name;
        newMan.number = mans.length;
        newMan.addr = _addr;
        
        for(uint i = 0; i < _key.length; i++)
            newMan.data[_key[i]] = _value[i];
    }
    
}

// 84. 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
contract Q84 {
    address[] blacklist;

    function pushBlackList(address _addr) public {
        blacklist.push(_addr);
    }

    function _isBlackList(address _addr) private view returns (bool) {
        for(uint i = 0; i < blacklist.length; i++){
            if(blacklist[i] == _addr) return true;
        }
        return false;
    }

    function calcNum(uint _a, uint _b) public view returns (uint, uint, uint) {
        require(!_isBlackList(msg.sender), "you are on the blacklist");

        return _a > _b ? (_a+_b, _a-_b, _a*_b) : (_a+_b, _b-_a, _a*_b);
    }
}

// 85. 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
// 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
contract Q85 {
    uint public agreeCount;
    uint public disagreeCount;
    uint startBlock;

    constructor() {
        startBlock = block.number;
    }

    function _checkValidation() public view {
        require(block.number - startBlock < 20, "Can only proceed for 20 blocks after distribution");
    }
    
    function agree() public {
        _checkValidation();
        agreeCount++;
    }

    function disagree() public {
        _checkValidation();
        disagreeCount++;
    }
}

// 86.  숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
contract Q86 {
    uint public agreeCount;
    uint public disagreeCount;

    function _checkValidation() public payable {
        require(msg.value >= 1 ether, "Only allowed to those who deposit more than 1 won");
    }

    function agree() public payable {
        _checkValidation();
        agreeCount++;
    }

    function disagree() public payable {
        _checkValidation();
        disagreeCount++;
    }
}

// 87. visibility에 신경써서 구현하세요. 
// 숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요. 
contract Q87 {
    uint private a;

    function setA(uint _n) private {
        a = _n;
    }
}
    
// 88. 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
/*
    contract OWNER {
    	address private owner;
    
    	constructor() {
    		owner = msg.sender;
    	}
    
        function setInternal(address _a) internal {
            owner = _a;
        }
    
        function getOwner() public view returns(address) {
            return owner;
        }
    }
*/
// 힌트 : 상속
contract OWNER {
	address private owner;
    
    constructor() {
        owner = msg.sender;
	}
    
    function setInternal(address _a) internal {
        owner = _a;
    }
    
    function getOwner() public view returns(address) {
        return owner;
    }
}
contract Q88 is OWNER {
    function setOwner(address _addr) public {
        setInternal(_addr);
    }
}
 
// 89. 이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. 
// (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
contract Q89 {
    struct Customer {
        string name;
        string introduce;
    }

    Customer public customer;

    function setName(string calldata _name) public {
        require(bytes(_name).length <= 10 && bytes(_name).length >= 5, "5 digits ~ 10 digits");
        customer.name = _name;
    }

    function setIntroduce(string calldata _introduce) public {
        require(bytes(_introduce).length <= 50 && bytes(_introduce).length >= 20, "20 digits ~ 50 digits");
        customer.introduce = _introduce;
    }
}

// 90. 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
contract Q90 {
    function tellMeYourWallet() public view returns(bytes memory, string memory) {
        bytes20 addr = bytes20(msg.sender);

        bytes memory ret = new bytes(40);

        for(uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(addr << (8 * i));
            ret[i*2] = _byte2ASCII(uint8(b >> 4 & 0x0f));
            ret[i*2+1] = _byte2ASCII(uint8(b & 0x0f));
        }

        return (ret, string(abi.encodePacked(ret)));
    }

    function _byte2ASCII(uint8 _n) private pure returns (bytes1) {
        return _n > 9 ? bytes1(_n - 10 + 0x61) : bytes1(_n + 0x30);
    }
}
