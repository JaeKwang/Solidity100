// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
은행에 관련된 어플리케이션을 만드세요.
은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

* 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
* 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
* 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
* 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
* 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
* 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
-------------------------------------------------------------------------------------------------
* 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
* 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
*/

contract CodingTest09 {
    // 0. 데이터 정의
    address admin;
    constructor() {
        admin = msg.sender;   
    }

    // 가입계좌
    address[] public addrs;
    // 계좌 => 은행
    mapping(address=>string[]) public banks;
    // 은행 => 계좌 => 세금
    mapping(address=>uint) public tax;
    // 은행 => 계좌 => 잔고
    mapping(string=>mapping(address=>uint)) public balance;

    // 1. 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    function registUser(string calldata _bank) public {
        addrs.push(msg.sender);
        banks[msg.sender].push(_bank);
    }

    // 2. 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    function deposit(string calldata _bank) public payable {
        balance[_bank][msg.sender] += msg.value;
    }

    // 3. 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    function withdraw(string calldata _bank, uint _value) public  payable  {
        require(balance[_bank][msg.sender] >= _value, "Insufficient balance");
        
        payable(msg.sender).transfer(_value);
        balance[_bank][msg.sender] -= _value;
    }

    // 4. 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    function sendMoney(string calldata _bankA, string calldata _bankB, address _owner, uint _value) public {
        require(_owner == msg.sender, "Only allowed by owner");
        require(balance[_bankA][_owner] >= _value, "Insufficient balance");
        
        balance[_bankA][_owner] -= _value;
        balance[_bankB][_owner] += _value;
    }

    // 5. 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    function sendMoney2(string calldata _bankA, string calldata _bankB, address _from, address _to, uint _value) public {
        require(_from == msg.sender, "Only allowed by owner");
        require(balance[_bankA][_from] >= _value, "Insufficient balance");
        
        balance[_bankA][_from] -= _value;
        balance[_bankB][_to] += _value;
    }

    // 6. 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    function collectTax() public {
        require(admin == msg.sender, "Only allowed by admin");
        for(uint i = 0; i < addrs.length; i++) {
            address addr = addrs[i];

            for(uint j = 0; j < banks[addr].length; j++) {
                tax[addr] += balance[banks[addr][j]][addr] / 100;
            }
        }
    }

    // 7. 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    function sendMoney3(string calldata _bankA, string calldata _bankB, address _from, address _to, uint _value) public {
        require(_from == msg.sender, "Only allowed by owner");
        require(balance[_bankA][_from] >= _value + 10**15, "Insufficient balance");
        balance[_bankA][_from] -= _value + 10**15;
        balance[_bankB][_to] += _value;
        balance[_bankA][address(0)] += 10**15; // A은행의 지갑?
    }

    // 8. 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
    function TaxPayment_Force(address _addr) public {
        require(admin == msg.sender, "Only allowed by admin");
        
        for(uint i = 0; i < banks[_addr].length; i++) {
            string memory bank = banks[_addr][i];

            // 세금이 잔고보다 많으면 잔고 다 까고 다음 지갑에서 징수
            if(tax[_addr] > balance[bank][_addr]) {
                balance["A"][admin] += balance[bank][_addr];
                tax[_addr] -= balance[bank][_addr];
                balance[bank][_addr] = 0;
            } 
            // 잔고가 세금 이상이면 그대로 납부
            else {
                balance["A"][admin] += tax[_addr];
                balance[bank][_addr] -= tax[_addr];
                tax[_addr] = 0;
                break;
            }
        }
    }
}
