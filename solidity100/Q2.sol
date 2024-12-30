// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 1. uint 형이 들어가는 array를 선언하고, 짝수만 들어갈 수 있게 걸러주는 함수를 구현하세요.
contract Q1 {
    uint[] array;

    function pushItem(uint _item) public {
        // require(_item % 2 == 0);
        if(_item % 2 == 0) array.push(_item);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}

// 2. 숫자 3개를 더해주는 함수, 곱해주는 함수 그리고 순서에 따라서 a*b+c를 반환해주는 함수 3개를 각각 구현하세요.
contract Q2 {
    function add(uint _a, uint _b, uint _c) public pure returns(uint) {
        return _a + _b + _c;
    }

    function mul(uint _a, uint _b, uint _c) public pure returns(uint) {
        return _a * _b * _c;
    }

    function mulAdd(uint _a, uint _b, uint _c) public pure returns(uint) {
        return _a * _b + _c;
    }
}

// 3. 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
contract Q3 {    
    function mulAdd(uint _input) public pure returns(string memory) {
        if(_input % 3 == 0) return "A";
        else if(_input % 3 == 1) return "B";
        else if(_input % 3 == 2) return "C";
        else return "Error";
    }
}

/*
    4. 학번, 이름, 듣는 수험 목록을 포함한 학생 구조체를 선언하고 학생들을 관리할 수 있는 array를 구현하세요.
    array에 학생을 넣는 함수도 구현하는데 학생들의 학번은 1번부터 순서대로 2,3,4,5 자동 순차적으로 증가하는 기능도 같이 구현하세요.
*/
contract Q4 {
    struct Student {
        uint number;
        string name;
        string[] courseList;
    }

    Student[] students;

    function pushStudent(string memory _name) public {
        Student memory s;
        s.number = students.length + 1;
        s.name = _name;
        students.push(s);
    }

    function getStudents() public view returns(Student[] memory) {
        return students;
    }
}

// 5. 배열 A를 선언하고 해당 배열에 0부터 n까지 자동으로 넣는 함수를 구현하세요. 
contract Q5 {
    uint[] A;

    function pushSequenceNum(uint _n) public {
        for(uint i = 0; i <= _n; i++) A.push(i);
    }

    function getA() public view returns(uint[] memory) {
        return A;
    }
}

// 6. 숫자들만 들어갈 수 있는 array를 선언하고 해당 array에 숫자를 넣는 함수도 구현하세요. 또 array안의 모든 숫자의 합을 더하는 함수를 구현하세요.
contract Q6 {
    uint[] array;

    function pushNum(uint _n) public {
        array.push(_n);
    }

    function arraySum() public view returns(uint) {
        uint sum = 0;
        for(uint i = 0; i < array.length; i++) sum += array[i];
        return sum;
    }
}

// 7. string을 input으로 받는 함수를 구현하세요. 이 함수는 true 혹은 false를 반환하는데 Bob이라는 이름이 들어왔을 때에만 true를 반환합니다. 
contract Q7 {
    function arraySum(string memory _input) public pure returns(bool) {
        return (keccak256(abi.encodePacked("Bob")) == keccak256(abi.encodePacked(_input)));
    }
}

// 8. 이름을 검색하면 생일이 나올 수 있는 자료구조를 구현하세요. (매핑) 해당 자료구조에 정보를 넣는 함수, 정보를 볼 수 있는 함수도 구현하세요.
contract Q8 {
    mapping(string=>string) public birthMap;

    function pushBirth(string memory _name, string memory _birth) public {
        birthMap[_name] = _birth;
    }

    function searchBirth(string memory _name) public view returns(string memory){
        return birthMap[_name];
    }
}

// 9. 숫자를 넣으면 2배를 반환해주는 함수를 구현하세요. 단 숫자는 1000이상 넘으면 함수를 실행시키지 못하게 합니다.
contract Q9 {
    function getDouble(uint _input) public pure returns(uint){
        require(_input < 1000);
        return _input * 2;
    }
}

/*
    10. 숫자만 들어가는 배열을 선언하고 숫자를 넣는 함수를 구현하세요.
    15개의 숫자가 들어가면 3의 배수 위치에 있는 숫자들을 초기화 시키는(3번째, 6번째, 9번째 등등) 함수를 구현하세요. (for 문 응용 → 약간 까다로움)
*/
contract Q10 {
   uint[] array;

    function pushNum(uint _input) public {
        array.push(_input);

        if(array.length == 15) {
            for(uint i = 2; i < array.length; i+=3)
                delete array[i];
        }
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}
