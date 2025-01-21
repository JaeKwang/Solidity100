// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
자동차와 관련된 어플리케이션을 만들면 됩니다.
1개의 smart contract가 자동차라고 생각하시고, 구조체를 활용하시면 편합니다.

아래의 기능들을 구현하세요.

* 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
* 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
* 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
* 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
* 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
--------------------------------------------------------
* 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
*/

contract CodingTest08 {
    // 0. 데이터 정의
    enum carState{
        stop,
        start
    }

    uint public fuel;
    uint public balance;
    uint public speed;
    carState public carStart;

    // 1. 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function acc() public {
        require(speed < 70, "Speed can be set up to 70");
        require(fuel > 30, "Fuel shortage");
        require(carStart == carState.start, "Please start the car");

        fuel -= 20;
        speed += 10;
    }

    // 2. 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function oiling() public payable { // 1234567890123456789 wei
        uint myBalance = balance + msg.value;
        require(myBalance >= 1 ether, "Pay more than 1 Ether");

        balance = myBalance - 1 ether;
        fuel += 100;
    }

    // 3. 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function decel() public {
        require(speed > 0, "The brakes do not work at speed 0");
        require(fuel > 10, "Fuel shortage");
        require(carStart == carState.start, "Please start the car");

        fuel -= 10;
        speed -= 10;
    }

    // 4. 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function turnOff() public {
        require(speed != 0, "The brakes do not work at speed 0");

        carStart = carState.stop;
    }

    // 5. 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function turnOn() public {
        carStart = carState.start;
    }

    // 6. 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    function chargeCost() public payable {
        require(msg.value > 0, "Deposit a value greater than 0");

        balance += msg.value;
    }
}