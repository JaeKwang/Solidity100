// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
숫자를 시분초로 변환하세요.

예)
100 -> 1분 40초
600 -> 10분
1000 -> 16분 40초
5250 -> 1시간 27분 30초
*/
contract CodingTest11 {
    
    function convertTimeToString(uint _time) public pure returns (string memory) {
        uint h = _time / 3600;
        uint m = (_time % 3600) / 60;
        uint s = (_time % 3600) % 60;

        string memory strH;
        string memory strM;
        string memory strS;

        if(h != 0) {
            if(m!=0 || s !=0) strH = string(abi.encodePacked(uint2str(h), unicode"시간 ")); // 공백 포함
            else strH = string(abi.encodePacked(uint2str(h), unicode"시간"));
        }
        if(m != 0) {
            if(s !=0) strM = string(abi.encodePacked(uint2str(m), unicode"분 ")); // 공백 포함
            else strM = string(abi.encodePacked(uint2str(m), unicode"분"));
        }
        if(s != 0) strS = string(abi.encodePacked(uint2str(s), unicode"초"));
            
        return string(abi.encodePacked(strH, strM, strS));
    }

    function uint2str(uint _value) public pure returns (string memory) {
        if (_value == 0) {
            return "0"; // 숫자가 0일 때는 바로 "0" 반환
        }

        uint temp = _value;
        uint digits;
        while (temp != 0) {
            digits++; // 자릿수 계산
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits); // 자릿수 크기의 배열 생성
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + _value % 10)); // ASCII 숫자 변환
            _value /= 10;
        }

        return string(buffer); // bytes 배열을 string으로 변환
    }
}
