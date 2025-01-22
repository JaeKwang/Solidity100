// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 91. 배열에서 특정 요소를 없애는 함수를 구현하세요. 
// 예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
contract Q91 {
    uint[] array;

    constructor(){
        pushArray(4);
        pushArray(3);
        pushArray(2);
        pushArray(1);
        pushArray(8);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }

    function pushArray(uint _n) public {
        array.push(_n);
    }

    function deleteArrayIndexBy(uint _index) public {
        require(_index > 0 && _index <= array.length, "Invalid Index");

        for(uint i = _index-1; i < array.length-1; i++) {
            (array[i], array[i+1]) = (array[i+1], array[i]);
        }
        array.pop();
    }
}

// 92. 특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
contract Q92 {
    enum AddressType {
        EOA,
        CA
    }

    function getAddressType(address _addr) public view returns (AddressType) {
        return _addr.code.length == 0 ? AddressType.EOA : AddressType.CA;
    }
}

// 93. 다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
// input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
contract TEST {
    uint public number;
    address public addr;

    function method(uint _n, address _addr) public {
        number = _n;
        addr = _addr;
    }
}
contract Q93 {
    function useOtherCon(address _otherCon, uint _n, address _addr) public returns (bool){
        bytes4 methodId = bytes4(keccak256("method(uint256,address)"));
        bytes memory payload = abi.encodeWithSelector(methodId, _n, _addr);
        (bool succ, ) = _otherCon.call(payload);
        return succ;
    }
}

// 94. inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
contract Q94 {
    function add(uint _a, uint _b) public pure returns (uint) {
        assembly {
            let ptr:= mload(0x40)
            mstore(ptr, add(_a, _b))
            return (ptr, 0x20)
        }
    }
    function sub(uint _a, uint _b) public pure returns (uint) {
        assembly {
            let ptr:= mload(0x40)
            mstore(ptr, sub(_a, _b))
            return (ptr, 0x20)
        }
    }
    function mul(uint _a, uint _b) public pure returns (uint) {
        assembly {
            let ptr:= mload(0x40)
            mstore(ptr, mul(_a, _b))
            return (ptr, 0x20)
        }
    }
    function div(uint _a, uint _b) public pure returns (uint) {
        assembly {
            let ptr:= mload(0x40)
            mstore(ptr, div(_a, _b))
            return (ptr, 0x20)
        }
    }
}

// 95. inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
contract Q95 {
    function multiReturn(uint _a, uint _b, uint _c) public pure returns (uint, uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, add(_a, add(_b, _c)))
            mstore(add(ptr, 0x20), mul(_a, mul(_b, _c)))
            return (ptr, 0x40)
        }
    }
}

// 96. inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
contract Q96 {
    function getMinMaxV(uint _a, uint _b, uint _c, uint _d) public pure returns (uint, uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x00), _a)
            mstore(add(ptr, 0x20), _b)
            mstore(add(ptr, 0x40), _c)
            mstore(add(ptr, 0x60), _d)

            let ret_ptr := add(ptr, 0x80)
            mstore(ret_ptr, _a) // Max V
            for {let i := 0} lt(i, 4) {i := add(i, 1)} {
                let v_i := mload(add(ptr, mul(0x20, i)))

                // Min 값 비교
                let min := mload(ret_ptr)
                if lt(v_i, min) {
                    mstore(ret_ptr, v_i)
                }

                // Max 값 비교
                let max := mload(add(ret_ptr, 0x20))
                if lt(max, v_i) {
                    mstore(add(ret_ptr, 0x20), v_i)
                }
            }

            return (ret_ptr, 0x40)
        }
    }
}

// 97. inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
contract Q97 {
    uint[] numbers;

    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }

    function push(uint _n) public {
        assembly {
            let slot := numbers.slot
            let length := sload(slot)
            
            mstore(0x00, slot)
            let start := keccak256(0x0, 0x20)
            
            sstore(slot, add(length, 1))
            sstore(add(start, length), _n)
        }
    }

    function pop() public {
        assembly {
            let slot := numbers.slot
            let length := sload(slot)
            
            mstore(0x00, slot)
            let start := keccak256(0x0, 0x20)
            
            sstore(slot, sub(length, 1))
            sstore(add(start, sub(length, 1)), 0)
        }
    }
}

// 98. inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요..
contract Q98 {
    string public letter;

    function setLetter(string memory _str) public {
        assembly {
            let slot := letter.slot
            let length := mload(_str)

            sstore(slot, or(mload(add(_str, 0x20)), mul(length, 2)))
        }
    }
}

// 99. inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
contract Q99 {
    bytes4 public b;

    function setB(bytes4 _n) public {
        assembly {
            let slot := b.slot
            let ptr := mload(0x40)
            mstore(add(ptr, 0x1c), _n) // 0x20 - 0x04 = 0x1c
            sstore(slot, mload(ptr))
        }
    }
}

// 100. inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
contract Q100 {
    bytes public b;

    function setB(bytes memory _bytes) public {
        assembly {
            let slot := b.slot
            let length := mload(_bytes)

            sstore(slot, or(mload(add(_bytes, 0x20)), mul(length, 2)))
        }
    }
}
