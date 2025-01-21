// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 51. 숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
contract Q51 {
    uint[] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    function getArray() public returns(uint) {
        require(array.length >= 3, "More then 3");
        // sort
        for(uint i = 0; i < array.length - 1; i++){
            for(uint j = i+1; j < array.length; j++){
                if(array[i] < array[j]) (array[i], array[j]) = (array[j], array[i]);
            }
        }
        return array[2];
    }
}    

// 52. 자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
contract Q52 {
    function createId(string memory _name, string memory _birth) public view returns (bytes10) {
        return bytes10(keccak256(abi.encodePacked(_name, _birth, msg.sender)));
    }
}

// 53. 시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
// 힌트 : 이중 mapping을 꼭 이용하세요.
contract Q53 {
    mapping(string => mapping(address => uint)) bank;

    function getBalance(string memory _bank) public view returns (uint) {
        return bank[_bank][msg.sender];
    }

    function deposit(string memory _bank) public payable {
        bank[_bank][msg.sender] += msg.value;
    }

    function withdraw(string memory _bank, uint _value) public payable {
        require(bank[_bank][msg.sender] >= _value, "Insufficient balance");
        
        payable(msg.sender).transfer(_value);
        bank[_bank][msg.sender] -= _value;
    }
}    

// 54. 기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
// 힌트 : 굳이 mapping을 만들 필요는 없습니다.
contract Q54 {
    struct Contributor {
        uint donation;
        address addr;
    }

    Contributor[] contributors;

    function donate() public payable {
        (bool ret, uint index) = _isInContributor();
        if(ret) {
            contributors[index].donation += msg.value;
        } else {
            contributors.push(Contributor({
                donation : msg.value,
                addr : msg.sender
            }));
        }
    }
    function _isInContributor() private view returns (bool, uint) {
        for(uint i = 0; i < contributors.length; i++) {
            if(msg.sender == contributors[i].addr)
                return (true, i);
        }
        return (false, 0);
    }

    function getMostContributor() public view returns (address) {
        uint maxDonation = 0;
        address mostContributor = address(0);

        for(uint i = 0; i < contributors.length; i++) {
            if(maxDonation < contributors[i].donation) {
                maxDonation = contributors[i].donation;
                mostContributor = contributors[i].addr;
            }
        }

        return mostContributor;
    }
}

// 55. 배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
contract Q55 {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "Only allowed by owner");
        owner = _newOwner;
    }
}

// 56. 위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
contract Q56 {
    address owner;
    address sub_owner;

    constructor() {
        owner = msg.sender;
        sub_owner = msg.sender;
    }

    bool allowance;
    function allow() public {
        require(msg.sender == sub_owner, "Only allowed by sub owner");
        allowance = true;
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner && allowance, "Only allowed by owner");
        owner = _newOwner;
        allowance = false;
    }
}    

// 57. 위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
contract Q57 {
    address owner;
    address sub_owner;

    constructor() {
        owner = msg.sender;
        sub_owner = msg.sender;
    }

    bool allowance;
    function allow() public {
        require(msg.sender == owner, "Only allowed by owner");
        allowance = true;
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner || allowance, "Only allowed by owner");
        owner = _newOwner;
        allowance = false;
    }
}

// 58. A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
contract A {
    uint private a;
    uint internal b;
    uint public c;
}

// 59. 현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요
contract Q59 {
    function getTime_after2days () public view returns (uint) {
        return block.timestamp + 2 days;
    }
}

// 60. 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다.
// 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
// 예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
// 힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
contract Q60 {
    mapping(uint => mapping(uint => string[])) bookings;
    constructor() {
        bookings[0][20250111] = ["Dwayne", "Ellen", "Fitz"];
        bookings[1][20250111] = ["Alice", "Bob", "Charlie"];
        bookings[0][20250112] = ["Isabel", "Jane", "Charlie"];
        bookings[1][20250112] = ["Garret", "Hubert", "Bob"];
        bookings[0][20250113] = ["Alice"];
        bookings[1][20250113] = ["Dwayne", "Ellen"];
        bookings[0][20250114] = ["Hubert", "Bob"];
        bookings[1][20250114] = ["Isabel", "Jane"];
    }

    function getGuests(uint _roomNum, uint _date) public view returns (string[] memory) {
        return bookings[_roomNum][_date];
    }
}
