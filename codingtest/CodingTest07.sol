// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.
입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.
*/

contract CodingTest07 {
    function validatePW(string calldata _pw) public pure returns(bool) {
        bytes memory byteArray = abi.encodePacked(_pw);

        bool numLetter;
        bool bigLetter;
        bool smallLetter;

        for(uint i = 0; i < byteArray.length; i++)
        {
            if(byteArray[i] > 0x2F && byteArray[i] < 0x3A) numLetter = true; // 숫자 (0x30~0x39)
            else if(byteArray[i] > 0x40 && byteArray[i] < 0x5B) bigLetter = true; // 대문자 (0x41~0x5A)
            else if(byteArray[i] > 0x60 && byteArray[i] < 0x7B) smallLetter = true; // 소문자 (0x61~0x7A)
            else return false; // 대/소/숫자 이외의 입력
        }

        // 8자리 이상 추가
        return (byteArray.length >= 8 && smallLetter && bigLetter && numLetter);
    }
}
