// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
간단한 게임이 있습니.
유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
4명까지만 들어올 수 있는 방이 있습니다. (array)
선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

예) 
방 안 : "empty" 
-- A 입장 --
방 안 : A 
-- B, D 입장 --
방 안 : A , B , D 
-- F 입장 --
방 안 : A , B , D , F 
A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
방 안 : "empty" 

유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
* 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
* 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
---------------------------------------------------------------------------------------------------
* 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
*/

contract CodingTest04 {
    constructor() {
        // 관리자 설정
        register('owner');
    }

    // 0. 번호, 이름, 주소, 잔고, 점수
    struct user {
        uint number;
        string name;
        address payable addr;
        uint score;
        uint balance;
    }

    user[] users;
    mapping(address => bool) isRegistered;
    address payable[] public room;

    // 1. 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function register(string memory _name) public {
        require(!isRegistered[msg.sender], "User already registered");

        user memory _user;
        _user.number = users.length + 1;
        _user.name = _name;
        _user.addr = payable(msg.sender);
        _user.score = _user.balance = 0;
        users.push(_user);

        isRegistered[msg.sender] = true;
    }

    // 2. 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser(uint _index) public view returns(uint, string memory, address payable, uint, uint) {
        require(_index < users.length, "Invalid user index");
        return (users[_index].number, users[_index].name, users[_index].addr, users[_index].score, users[_index].balance);
    }

    // 3. 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    // 0.01 ether = 10000000000000000 wei
    function getUserIndex(address _addr) internal view returns (uint) {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == _addr) return i;
        }
        revert("User not found!");
    }
    function joinGame() public payable {
        require(isRegistered[msg.sender], "User not registered");
        require(msg.value >= 0.01 ether || users[getUserIndex(room[0])].balance >= 0.01 ether, "Insufficient funds");

        if(msg.value >= 0.01 ether) {
            // smart contract에 보관 & 참가비 제외 잔고에 등록
            users[getUserIndex(msg.sender)].balance += msg.value - 0.01 ether;
        } else if (users[getUserIndex(msg.sender)].balance >= 0.01 ether) {
            // balance 차감
            users[getUserIndex(msg.sender)].balance -= 0.01 ether;
        }

        // push address 중복 방지 ?
        room.push(payable(msg.sender));
        if(room.length == 4) {
            users[getUserIndex(room[0])].score = 4;
            users[getUserIndex(room[1])].score = 3;
            users[getUserIndex(room[2])].score = 2;
            users[getUserIndex(room[3])].score = 1;
            delete room;
        }
    }

    // 4. 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function exchange() public payable {
        require(isRegistered[msg.sender], "User not registered");
        require(users[getUserIndex(msg.sender)].score >= 10, "Insufficient funds");
        users[getUserIndex(msg.sender)].score -= 10;
        users[getUserIndex(msg.sender)].balance += 0.1 ether;
    }
    
    // 5. 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    function withdraw(uint _amount) public payable {
        require(isRegistered[msg.sender], "User not registered");
        require(getUserIndex(msg.sender) == 0, "Only admin address");
        require(_amount < address(this).balance, "Insufficient contract balance");

        users[0].addr.transfer(_amount);
    }

    // 6. 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    function deposit() public payable {
        require(isRegistered[msg.sender], "User not registered");
        require(msg.value > 0, "Insufficient funds");
        users[getUserIndex(msg.sender)].balance += msg.value;
    }
}
