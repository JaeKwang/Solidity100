// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 31. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
contract Q31 {
    function isAliceOrBob(string memory _str) public pure returns (bool) {
        bytes32 strHash = keccak256(abi.encodePacked(_str));
        return keccak256(abi.encodePacked("Alice")) == strHash || keccak256(abi.encodePacked("Bob")) == strHash;
    }
}

// 32. 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
contract Q32 {
    uint[] public array;

    function pushItem(uint _item) public {
        require(_item % 3 == 0 && _item % 10 != 0, "Only multiples of 3 are allowed");
        array.push(_item);
    }
}

// 33. 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
contract Q33 {
    struct user {
        string name;
        uint num;
        address addr;
        string birth;
    }

    user[] users;
    mapping (string => user) searchTable;

    function registerUser(string memory _name, address _addr, string memory _birth) public {
        user memory u = user({
            name : _name,
            num : users.length + 1,
            addr : _addr,
            birth : _birth
        });
        users.push(u);
        searchTable[_name] = u;
    }

    function getUser(string memory _name) public view returns (user memory) {
        return searchTable[_name] ;
    }
}

// 34. 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
contract Q34 {
    struct student {
        string name;
        uint num;
        uint score;
    }

    student[] students;

    function pushStudent(string memory _name, uint _score) public {
        students.push(student({
            name : _name,
            num : students.length + 1,
            score : _score
        }));
    }

    function getAverageScore() public view returns (uint) {
        require(students.length > 0, "Array length is 0");
        uint sum = 0;
        for(uint i = 0; i < students.length; i++) sum += students[i].score;
        return sum / students.length;
    }

    // for Test
    function pushStudentsAll() public {
        pushStudent("Alice", 85);
        pushStudent("Bob",75);
        pushStudent("Charlie", 60);
        pushStudent("Dwayne", 90);
        pushStudent("Ellen", 65);
        pushStudent("Fitz", 50);
        pushStudent("Garret", 80);
        pushStudent("Hubert", 90);
        pushStudent("Isabel", 100);
        pushStudent("Jane", 70);
    }
}

// 35. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
contract Q35 {
    uint[] array;

    function pushNums(uint[] memory _array) public {
        array = _array;
    }

    function getElements_Even() public view returns (uint[] memory) {
        uint[] memory ret = new uint[](array.length/2);
        uint index = 0;
        for(uint i = 1; i < array.length; i+=2) ret[index++] = array[i];
        return ret;
    }
}

// 36. high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
contract Q36 {
    enum State {
        high,
        neutral,
        low
    }
    State public state;
    uint a;

    function setA(uint _v) public {
        a = _v;

        if(a >= 7) state = State.high;
        else if(a >= 4) state = State.neutral;
        else state = State.low;
    }
}

/*
37. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 
최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
(힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
*/
contract Q37 {
    address payable owner;
    constructor() {
        owner = payable(msg.sender);
    }

    function donationWEI() public payable  {
        require(msg.value == 1 wei, "Enter 1 wei to donate");
    }

    function donationFINNEY() public payable  {
        require(msg.value == 0.001 ether, "Enter 1 finney to donate");
    }

    function donationETHER() public payable  {
        require(msg.value == 1 ether, "Enter 1 ether to donate");
    }

    function withdrawAll() public payable  {
        require(msg.sender == owner, "Not the owner of the smart contract");
        owner.transfer(address(this).balance);
    }
}

/*
38. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요.
단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
(힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
*/
contract Q38 {
    string public a;
    address owner;
    constructor() {
        a = "A";
        owner = msg.sender;
    }

    function setA2B() public {
        isOwner();
        a = "B";
    }
    function setA2C() public {
        isOwner();
        a = "C";
    }

    function isOwner() public view {
        require(msg.sender == owner, "Not the owner of the smart contract");
    }

}

// 39. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
contract Q39 {
    function func09 (uint num) public pure returns(uint, uint, uint, uint) {
        uint digits = 0;
        for(uint i = 0; i < 32; i++) {
            if(num / 10**i == 0){
                if(num % 10**i == 0) digits++;
                break;
            }
            digits++;
        }

        if(digits == 0) return (0, 0, 0, 0);

        uint num_digits = 10**(digits-1); // 1,234 => 1,000, 50,438 => 10,000
        
        return (num_digits / 2, num_digits / 3, num_digits / 5, num_digits / 7);
    }
}

/*
40. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요.
가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
*/
contract Q40 {
    function pushNum(uint[] memory _input) public pure returns (uint, uint) {

        for(uint i = 0; i < _input.length-1; i++) {
            for(uint j = i+1; j < _input.length; j++) {
                if(_input[i] < _input[j]) (_input[i],  _input[j]) = (_input[j],  _input[i]) ;
            }
        }

        return _input.length % 2 == 1 ? (0, _input[_input.length / 2]) :(_input[_input.length / 2], _input[_input.length / 2 + 1]);
    }
}
