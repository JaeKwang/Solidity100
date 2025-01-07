// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 1. 3의 배수만 들어갈 수 있는 array를 구현하세요.
contract Q1 {
    uint[] public array;

    function pushItem(uint _item) public {
        require(_item % 3 == 0, "Only multiples of 3 are allowed");
        array.push(_item);
    }
}

// 2. 뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
contract Q2 {
    function minus(uint _a, uint _b) public pure returns(uint){
        return _a > _b ? _a - _b : _b - _a;
    }
}

// 3. 5의 배수라면 “A”를, 나머지가 1이면 “B”를, 나머지가 2면 “C”를, 나머지가 3이면 “D”, 나미저가 4면 “E”를 반환하는 함수를 구현하세요.
contract Q3 {
    function minus(uint _v) public pure returns(string memory){
        if(_v % 5 == 0) return "A";
        else if(_v % 5 == 1) return "B";
        else if(_v % 5 == 2) return "C";        
        else if(_v % 5 == 3) return "D";
        else return "E";
    }
}

// 4. string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
contract Q4 {
    function strcmp(string calldata _input) public pure returns(bool){
        return keccak256(abi.encodePacked("Alice")) == keccak256(abi.encodePacked(_input));
    }
}

// 5. 배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
contract Q5 {
    uint[] A;

    function AutoPush(uint n) public {
       for(uint i = n; i > 0; i--) A.push(i);
       A.push(0);
    }

    function getA() public view returns (uint[] memory) {
        return A;
    }
}

// 6. 홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
contract Q6 {
    uint[] array_odd;
    uint[] array_even;

    function pushItem(uint _item) public {
        if(_item % 2 == 0) array_even.push(_item);
        else array_odd.push(_item);
    }

    function getArrayOdd() public view returns (uint[] memory) {
        return array_odd;
    }

    function getArrayEven() public view returns (uint[] memory) {
        return array_even;
    }
}

// 7. string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
contract Q7 {
    mapping(string => bytes32) map;

    function searchItem(string memory _key) public view returns(bytes32) {
        return map[_key];
    }
    function pushItem(string memory _key, bytes32 _value) public {
        map[_key] = _value;
    }
    function deleteItem(string memory _key) public {
        delete map[_key];
    }
}

// 8. ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
contract Q8 {
    function getKECCAK256(string memory _id, string memory _pw) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_id, _pw));
    }
}

// 9. 숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
contract Q9 {
    uint a;
    string b;

    constructor(){
        a = 10;
        b = "A";
    }
}

/*
10. 임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
(sorting 코드 응용 → 약간 까다로움)
*/
contract Q10 {
    function pushNum(uint[] memory _input) public pure returns (uint[] memory) {
        for(uint i = 0; i < _input.length-1; i++) {
            for(uint j = i+1; j < _input.length; j++) {
                if(_input[i] < _input[j]) (_input[i],  _input[j]) = (_input[j],  _input[i]) ;
            }
        }

        return _input;
    }
}
