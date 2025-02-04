// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 71. 숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
// 한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
contract Q71 {
    uint public a;
    uint public changedTime;

    function setA(uint _n) public {
        a = _n;
    }

    function setA_coolTime(uint _n) public {
        require(block.timestamp - changedTime > 10 * 60, "Cool time 10 minutes");
        a = _n;
        changedTime = block.timestamp;
    }
}

// 72.  contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. 
// owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
// 예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
contract Q72 {
    address public owner;
    uint maxDeposit;
    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        if(msg.value > maxDeposit) {
            owner = msg.sender;
            maxDeposit = msg.value; 
        }
    }

    function withdraw(uint _v) public payable {
        require(msg.sender == owner, "Only allowed by owner");
        require(address(this).balance > _v, "Insufficient balance");
        payable(owner).transfer(_v);
    }
}

// 73. 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
// 예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
contract Q73 {
address public owner;
    uint maxDeposit;
    mapping(address => uint) totalDeposit;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        totalDeposit[msg.sender] += msg.value;
        
        if(totalDeposit[msg.sender] > maxDeposit) {
            owner = msg.sender;
            maxDeposit = totalDeposit[msg.sender]; 
        }
    }

    function withdraw(uint _v) public payable {
        require(msg.sender == owner, "Only allowed by owner");
        require(address(this).balance > _v, "Insufficient balance");
        payable(owner).transfer(_v);
    }
}

// 74. 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
// 예) 20 -> 22(20 + 2, 2는 20의 10%), 0 
// 50 -> 55(50+5, 5는 50의 10%), 0 
// 42 -> 46(42+4), 2 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) 
// 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
contract Q74 {
    function add_10per(uint _n) public pure returns(uint, uint) {
        return (_n * 110 / 100, _n % 10);
    }
}

// 75. 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
// 예) abc,3 -> abcabcabc // ab,5 -> ababababab
contract Q75 {
    function repeatNstr(string calldata _str, uint _repeat) public pure returns(string memory) {
        string memory str;
        for(uint i = 0; i < _repeat; i++)
            str = string.concat(str, _str);
        return str;
    }
}

// 76. 숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. (패키지없이)
contract Q76 {
    function num2str(uint _n) public pure returns (string memory) {
        if(_n == 0) return "0";

        // 자릿수 계산
        uint temp = _n;
        uint digits;
        while(temp != 0) {
            temp /= 10;
            digits++;
        }

        // 배열 선언
        bytes memory numBytes = new bytes(digits);

        for(uint i = 0; i < digits; i++) {
            numBytes[i] = bytes1(uint8(48 + (_n / (10 ** (digits - i - 1))) % 10));
        }

        return string(numBytes);
    }
}

// 77. 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
import "@openzeppelin/contracts/utils/Strings.sol";
contract Q77 {
    function num2str(uint _n) public pure returns (string memory) {
        return Strings.toString(_n);
    }
}

// 78. 숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
// 예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
contract Q78 {
    uint[] array;

    function setArray(uint[] calldata _input) public {
        array = _input;
    }

    function isIn10to25() public view returns(bool) {
        for(uint i = 0; i < array.length; i++) {
            if(array[i] >= 10 && array[i] <= 25) return true;
        }
        return false;
    }
}

// 79. 3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요.
// Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요.
// 학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요.
// 구현할 때는 Contract A를 import 하여 구현하세요.
contract A {
    function bigNum(uint _n1, uint _n2, uint _n3) public pure returns(uint) {
        return _n1 > _n2 ? _n1 > _n3 ? _n1 : _n3 : _n2 > _n3 ? _n2 : _n3;
    }
}

contract B is A {
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] public students;

    function pushStudent(string calldata _name, uint _score) public {
        students.push(Student({
            name : _name,
            number : students.length + 1,
            score : _score
        }));
    }

    function pushStudent_3(string calldata _name1, uint _score1, string calldata _name2, uint _score2, string calldata _name3, uint _score3) public returns (Student memory) {
        pushStudent(_name1, _score1);
        pushStudent(_name2, _score2);
        pushStudent(_name3, _score3);

        uint bn = bigNum(_score1, _score2, _score3);

        for(uint i = 0; i < students.length; i++) {
            if(students[i].score == bn) return students[i];
        }

        revert("none");
    }
}

// 80. 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 
// 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 
// 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다.
// 가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다.
// push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
contract Q80 {
    uint[] array;

    function getArray() public view returns (uint[] memory) { return array; }

    function pushArrayFIFIO(uint _n) public {
        array.push(_n);
    }

    function popArrayFIFO() public {
        if(array.length == 1) array.pop();
        else{
            // 1칸씩 떙기기
            for(uint i = 1; i < array.length; i++)
                array[i - 1] = array[i];
            
            array.pop();
        }
    }
}
