// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요. (숫자는 작은수에서 큰수로)
예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   3,5,9 // 28712 -> 5,   1,2,2,7,8
--------------------------------------------------------------------------------------------
문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요. (알파벳은 순서대로)
예) abde -> 4,   a,b,d,e // fkeadf -> 6,   a,d,e,f,f,k

소문자 대문자 섞이는 상황은 그냥 생략하셔도 됩니다
*/

contract CodingTest13 {
    
    // 1. 숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요. (숫자는 작은수에서 큰수로)
    // 예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   3,5,9 // 28712 -> 5,   1,2,2,7,8
    function cvtNumberToSortedArray(uint _n) public pure returns(uint, uint[] memory) {
        // 자리수 구하기
        uint temp = _n;
        uint digits = 0;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        // num to array
        uint[] memory array = new uint[](digits);

        for (uint i = 0; i < array.length; i++) {
            array[i] = _n % 10;
            _n /= 10;
        }

        // 배열정렬
        for (uint i = 0; i < array.length-1; i++) {
            for (uint j = i+1; j < array.length; j++) {
                if(array[i] > array[j]) (array[i], array[j]) = (array[j], array[i]);
            }
        }

        return (digits, array);
    }

    // 2. 문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요. (알파벳은 순서대로)
    // 예) abde -> 4,   a,b,d,e // fkeadf -> 6,   a,d,e,f,f,k
    function cvtStringToSortedArray(string calldata _str) public pure returns (uint, string[] memory) {
        bytes memory strBytes = bytes(_str);

        // 배열 정렬
        for(uint i = 0; i < strBytes.length; i++) {
            for (uint j = i+1; j < strBytes.length; j++) {
                if(strBytes[i] > strBytes[j]) (strBytes[i], strBytes[j]) = (strBytes[j], strBytes[i]);
            }
        }

        // String 배열로 변환
        string[] memory array = new string[](bytes(_str).length);

        // 한 글자씩 분리
        for (uint i = 0; i < strBytes.length; i++) {
            bytes memory singleChar = new bytes(1);
            singleChar[0] = strBytes[i];
            array[i] = string(singleChar);
        }

        return (array.length, array);
    }
}
