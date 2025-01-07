// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
로또 프로그램을 만드려고 합니다. 
숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. (순서는 상관없음)

참가 금액은 0.05이더이다.

당첨번호 : 7,3,2,5,B,C
예시 1  : 8,2,4,7,D,A -> 맞은 번호 : 2     (1개)
예시 2  : 9,1,4,2,F,B -> 맞은 번호 : 2,B   (2개)
예시 3  : 2,3,4,6,A,B -> 맞은 번호 : 2,3,B (3개)
*/

contract CodingTest05 {
    bytes public sequence;

    // 랜덤 숫자 생성 함수
    function getRandomNumber(uint _i) public view returns (uint) {
        return uint(keccak256(abi.encodePacked(_i, block.timestamp, msg.sender, block.difficulty)));
    }

    // 랜덤 시퀀스 생성 함수
    function generateSequence() public {
        sequence = new bytes(6);
        
        // 숫자 4개 (0–9) 생성
        for (uint i = 0; i < 4; i++) {
            uint num = getRandomNumber(i) % 10; // 0–9
            sequence[i] = bytes1(uint8(num + 48)); // ASCII 0–9 (48–57)
        }

        // 문자 2개 (a–z) 생성
        for (uint i = 0; i < 2; i++) {
            uint letter = getRandomNumber(i + 4) % 26; // 0–25
            sequence[4 + i] = bytes1(uint8(letter + 97)); // ASCII a–z (97–122)
        }
    }
    function getSequence() public view returns (string memory) {
        return string(sequence);
    }
    
    function joinGame(string[6] calldata _str) public payable returns(uint){
        require(msg.value == 0.05 ether, "Participation fee is 0.05 Ethereum"); // 50000000000000000 wei
        bool[6] memory check;
        uint count = 0;

        // 중복 허용 search
        for (uint i = 0; i < 6; i++) {
            for (uint j = 0; j < 6; j++) {
                if (bytes(_str[i])[0] == sequence[j] && !check[j]) {
                    check[j] = true;
                    count++;
                    break;
                }
            }
        }

        // 맞춘 개수로 상금 결정
        uint prize;
        if (count == 6) prize = 1 ether;
        else if (count == 5) prize = 0.75 ether;
        else if (count == 4) prize = 0.25 ether;
        else if (count == 3) prize = 0.1 ether;
        else prize = 0;
        
        if (prize > 0) payable(msg.sender).transfer(prize); // 상금 지급
        
        return count;
    }
}
