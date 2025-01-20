// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 61. a의 b승을 반환하는 함수를 구현하세요.
contract Q61 {
    function pow(uint a, uint b) public pure returns (uint) {
        return a**b;
    }
}

// 62. 2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
contract Q62 {
    function _isLT10(uint a) private pure returns(bool) {
        return a < 10;
    }

    function add(uint a, uint b) public pure returns(uint) {
        require(_isLT10(a) && _isLT10(b), "Input cannot exceed 10");
        return a+b;
    }

    function mul(uint a, uint b) public pure returns(uint) {
        require(_isLT10(a) && _isLT10(b), "Input cannot exceed 10");
        return a*b;
    }

    function pow(uint a, uint b) public pure returns(uint) {
        require(_isLT10(a) && _isLT10(b), "Input cannot exceed 10");
        return a**b;
    }
}

// 63. 2개 숫자의 차를 나타내는 함수를 구현하세요.
contract Q63 {
    function sub(uint a, uint b) public pure returns(uint) {
        return a > b ? a-b : b-a;
    }
}

// 64. 지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
contract Q64 {
    function splitAddress(address _addr) public pure returns (bytes4[] memory) {
        bytes20 addr2bytes = bytes20(_addr);
        
        bytes4[] memory array = new bytes4[](5);
        array[0] = bytes4(addr2bytes);
        array[1] = bytes4(addr2bytes << 32);
        array[2] = bytes4(addr2bytes << 32*2);
        array[3] = bytes4(addr2bytes << 32*3);
        array[4] = bytes4(addr2bytes << 32*4);

        return array;
    }
}

// 65. 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
// 예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자) 
contract Q65 {
    function powBatch(uint a, uint b, uint c) public pure returns(uint) {
        return a < b ? a < c ? b < c ? b**2 : c**2 : a**2 : b < c ? a < c ? a**2 : c**2: b**2;
    }
}

// 66. 특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
contract Q66 {
    function getDigits(uint _n) public pure returns(uint) {
        uint temp = _n;
        uint digits;
        while(temp != 0) {
            temp /= 10;
            digits++;
        }
        return digits;
    }

    function getDigits_5(uint _n) public pure returns(uint) {
        uint temp = _n;
        uint digits;
        while(temp != 0) {
            temp /= 5;
            digits++;
        }
        return digits;
    }
}

// 67. 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
// B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
contract A {
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}

contract B {
    function sendMoney(address _addr) public payable {
        payable(_addr).transfer(address(this).balance);
    }
}

// 68. 계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
// 예) 5 → 1*2*3*4*5 = 120, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
// while을 사용해보세요
contract Q68 {
    function NFactorial(uint _n) public pure returns (uint) {
        if(_n == 0) return 0;

        uint fac = 1;
        while(_n != 0) {
            fac *= _n;
            _n--;
        }
        return fac;
    }
}    

// 69. 숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
// 힌트 : 7번 문제(시,분,초로 변환하기)
// [1, 2, 3, 4]
contract Q69 {
    function SeqNum(uint[] calldata _nums) public pure returns (string memory) {
        string memory str;

        if(_nums.length >= 2) {
            for(uint i = 0; i < _nums.length - 2; i++)
                str = string(abi.encodePacked(str, uint2str(_nums[i]), " and "));
            
            str = string(abi.encodePacked(str, uint2str(_nums[_nums.length - 2]), " or "));
        }
        if(_nums.length >= 1) str = string(abi.encodePacked(str, uint2str(_nums[_nums.length - 1])));

        return str;
    }

    function uint2str(uint _value) private pure returns (string memory) {
        if (_value == 0) {
            return "0"; // 숫자가 0일 때는 바로 "0" 반환
        }

        uint temp = _value;
        uint digits;
        while (temp != 0) {
            digits++; // 자릿수 계산
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits); // 자릿수 크기의 배열 생성
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + _value % 10)); // ASCII 숫자 변환
            _value /= 10;
        }

        return string(buffer); // bytes 배열을 string으로 변환
    }
}

// 70. 번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요.
// bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다.
// 고객의 정보를 넣고 변화시키는 함수를 구현하세요.
contract Q70 {
    struct Customer{
        uint number;
        string name;
        bytes serialNum;
    }

    Customer[] customers;

    function pushCustomer(string calldata _name) public {
        customers.push(Customer({
            number : customers.length + 1,
            name : _name,
            serialNum : bytes(_toSerialNum(customers.length, _name))
        }));
    }

    function editCustomer(uint _number, string calldata _name) public {
        require(customers.length >= _number && _number > 0, "Not exist");
        customers[_number-1].name = _name;
        customers[_number-1].serialNum = bytes(_toSerialNum(_number-1, _name));
    }

    function getCustomer(uint _number) public view returns (Customer memory){
        require(customers.length >= _number && _number > 0, "Not exist");
        return customers[_number-1];
    }

    function _toSerialNum(uint _n, string calldata _name) private pure returns(bytes memory) {
        return abi.encodePacked(keccak256(abi.encodePacked(_n, _name)));
    }
}
