// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 1. 더하기, 빼기, 곱하기, 나누기 그리고 제곱을 반환받는 계산기를 만드세요.
contract Q1 {
    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }
    function sub(uint a, uint b) public pure returns(uint) {
        return a - b;
    }
    function mul(uint a, uint b) public pure returns(uint) {
        return a * b;
    }
    function div(uint a, uint b) public pure returns(uint, uint) {
        return (a / b, a % b);
    }
    function pow2(uint a) public pure returns(uint) {
        return a * a;
    }
}

// 2. 2개의 Input값을 가지고 1개의 output값을 가지는 4개의 함수를 만드시오. 각각의 함수는 더하기, 빼기, 곱하기, 나누기(몫)를 실행합니다.
contract Q2 {
    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }
    function sub(uint a, uint b) public pure returns(uint) {
        return a - b;
    }
    function mul(uint a, uint b) public pure returns(uint) {
        return a * b;
    }
    function div(uint a, uint b) public pure returns(uint) {
        return a / b;
    }
}

// 3. 1개의 Input값을 가지고 1개의 output값을 가지는 2개의 함수를 만드시오. 각각의 함수는 제곱, 세제곱을 반환합니다.
contract Q3 {
    function pow2(uint a) public pure returns(uint) {
        return a*a;
    }
    function pow3(uint a) public pure returns(uint) {
        return a*a*a;
    }
}

// 4. 이름(string), 번호(uint), 듣는 수업 목록(string[])을 담은 student라는 구조체를 만들고 그 구조체들을 관리할 수 있는 array, students를 선언하세요.
contract Q4 {
    struct student {
        string name;
        uint num;
        string[] subjects;
    }

    student[] students;
}

/*
5. 아래의 함수를 만드세요
  1~3을 입력하면 입력한 수의 제곱을 반환받습니다.
  4~6을 입력하면 입력한 수의 2배를 반환받습니다.
  7~9를 입력하면 입력한 수를 3으로 나눈 나머지를 반환받습니다.
*/
contract Q5 {
    function func(uint a) public pure returns(uint) {
        if(a <= 3) return a * a;
        else if(a <= 6) return a * 2;
        else if(a <= 9) return a % 3;
        else return 0;
    }
}

// 6. 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 9까지 자동으로 채우는 함수를 구현하세요.(for 문)
contract Q6 {
    uint[] numbers;

    function setArray() public {
        for(uint i = 0; i <= 9; i++) numbers.push(i);
    }

    // for confirm
    function getArray() public view returns (uint[] memory){
        return numbers;
    }
}

// 7. 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 5까지 자동으로 채우는 함수와 array안의 모든 숫자를 더한 값을 반환하는 함수를 각각 구현하세요.(for 문)
contract Q7 {
    uint[] numbers;

    function setArray() public {
        for(uint i = 0; i <= 5; i++) numbers.push(i);
    }

    function getAccumulatedSum() public view returns (uint){
        uint sum;
        for(uint i = 0; i < numbers.length; i++) sum += numbers[i];
        return sum;
    }

    // for confirm
    function getArray() public view returns (uint[] memory){
        return numbers;
    }
}

/*
8. 아래의 함수를 만드세요
1~10을 입력하면 “A” 반환받습니다.
11~20을 입력하면 “B” 반환받습니다.
21~30을 입력하면 “C” 반환받습니다.
*/
contract Q8 {
    function getGrade(uint _score) public pure returns(string memory) {
        if(_score > 30 || _score == 0) return "";

        if(_score > 20) return "C";
        else if(_score > 10) return "B";
        else return "A";
    }
}

// 9. 문자형을 입력하면 bytes 형으로 변환하여 반환하는 함수를 구현하세요.
contract Q9 {
    function str2bytes(string memory _str) public pure returns (bytes memory){
        bytes memory b3 = bytes(_str);
        return b3;
    }
}

// 10. 숫자만 들어가는 array numbers를 선언하고 숫자를 넣고(push), 빼고(pop), 특정 n번째 요소의 값을 볼 수 있는(get)함수를 구현하세요.
contract Q10 {
    uint[] numbers;

    function pushArray(uint _num) public {
        numbers.push(_num);
    }

    function popArray() public {
        numbers.pop();
    }

    function searchArray(uint _index) public view returns (uint) {
        return numbers[_index];
    }

    // for confirm
    function getArray() public view returns (uint[] memory){
        return numbers;
    }
}
