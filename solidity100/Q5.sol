// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 41. 숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 그 배열에 숫자를 넣는 함수를 구현하세요. 배열을 초기화하는 함수도 구현하세요. (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
contract Q41 {
    uint[4] array;
    uint index;

    function pushItem(uint _item) public {
        array[index++] = _item;
        if(index == 4) {
            index = 0;
            delete array;
        }
    }

    function clearArray() public {
        index = 0;
        delete array;
    }

    function getArray() public view returns(uint[4] memory) {
        return array;
    }
}

// 42. 이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요. 새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
contract Q42 {
    struct customer {
        string name;
        uint number;
        address addr;
    }
    customer[] public customers;
    
    function registerCustomer (string calldata _name) public {
        require(bytes(_name).length >= 5, "Must be at least 5 characters");
        customers.push(customer({
            name: _name,
            number: customers.length + 1,
            addr: msg.sender
        }));
    }
}

// 43. 은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다. 해당 contract에 ether를 예치할 수 있는 기능을 만드세요. 또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요.
contract Q43 {
    mapping (address => uint) balance;

    function deposit() public payable {
        require(msg.sender != address(0), "Not be 0 address");
        balance[msg.sender] += msg.value;
    }

    function withdrawAll() public payable {
        require(balance[msg.sender] != 0, "insufficient balance");

        payable(msg.sender).transfer(balance[msg.sender]);
        balance[msg.sender] = 0;
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
}

// 44. string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
contract Q44 {
    string[] array;
    
    function pushArray (string calldata _item) public {
        require(bytes(_item).length >= 4, "Must be at least 4 characters");
        array.push(_item);
    }

    function getArray() public view returns(string[] memory) {
        return array;
    }
}

// 45. 숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
contract Q45 {
    uint[] array;
    
    function pushArray (uint _num) public {
        require(_num <= 100, "Only numbers less or 100 are allowed");
        array.push(_num);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}    
    
// 46. 3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
contract Q46 {
    uint[] array;
    
    function pushArray (uint _num) public {
        require(_num % 10 == 0 && _num < 50, "Condition unsatisfied");
        array.push(_num);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}    
    
// 47. 배포와 함께 배포자가 owner로 설정되게 하세요. owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
contract Q47 {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _addr) public {
        require(owner == msg.sender, "Only allowed by owner");
        owner = _addr;
    }
}    
    
// 48. A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
contract A {
    function add(uint _a, uint _b) public pure returns (uint) {
        return _a + _b;
    }
}

contract B is A{
    function test_ADD1and2() public pure returns (uint) {
        return add(1, 2);
    }
}

    
// 49. 긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
// 예) 459273 → 273 // 492871 → 871 // 92218 → 218
contract Q49 {
    function subNum(uint _num) public pure returns (string memory) {
        require(_num > 999, "Greater or 1000");

        bytes1 num1 = bytes1(uint8(48 + (_num)%10));
        bytes1 num2 = bytes1(uint8(48 + (_num / 10)%10));
        bytes1 num3 = bytes1(uint8(48 + (_num / 100)%10));
        
        return string(abi.encodePacked(num3, num2, num1));
    }
}    

// 50. 숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요. 
// 예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15 
// 응용 문제 : 3개 아닌 n개의 숫자 이어붙이기
contract Q50 {
    function concatNum(uint[] memory _nums) public pure returns (uint) {
        uint ret;
        for(uint i = 0; i < _nums.length; i++) {
            require(_nums[_nums.length - i - 1] < 10, "Not a single digit");
            ret += _nums[_nums.length - i - 1] * 10**i;
        }
        return ret;
    }
}    
