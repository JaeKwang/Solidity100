// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*

학생 점수관리 프로그램입니다.
여러분은 한 학급을 맡았습니다.
학생은 번호, 이름, 점수로 구성되어 있고(구조체)
가장 점수가 낮은 사람을 집중관리하려고 합니다.

가장 점수가 낮은 사람의 정보를 보여주는 기능,
총 점수 합계, 총 점수 평균을 보여주는 기능,
특정 학생을 반환하는 기능, -> 숫자로 반환
가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)

*/

contract CodingTest02 {
    struct Student {
        uint number;
        string name;
        uint score;
    }

    // 0. 데이터 준비
    Student[] students;
    struct ValueData { // Mapping은 모든 Key에 대해서 0을 반환하기 때문에 Check Flag 세팅
        uint value;
        bool isValue;
    }
    mapping (uint => ValueData) public searchTable_number; // Key: 학번, Value: List의 Index

    function pushStudent(string memory _name, uint _score) public {
        Student memory s;    
        s.name = _name;
        s.score = _score;
        s.number = students.length + 1;

        students.push(s);

        ValueData memory data;
        data.value = students.length - 1;
        data.isValue = true;
        searchTable_number[s.number] = data;
    }

    function pushStudentsAll() public {
        pushStudent("Alice", 85);
        pushStudent("Bob",75);
        pushStudent("Charlie", 60);
        pushStudent("Dwayne", 90);
        pushStudent("Ellen", 65);
        pushStudent("Fitz", 50);
        pushStudent("Garret", 80);
        pushStudent("Hubert", 90);
        pushStudent("Isabel", 100);
        pushStudent("Jane", 70);
    }

    // 1. 가장 점수가 낮은 사람의 정보를 보여주는 기능
    function lowestStudent() public view returns (Student memory) {
        require(students.length > 0, "Length of Student[] is 0");

        uint min = type(uint).max;
        uint index;

        for(uint i = 0; i < students.length; i++) {
            if(min > students[i].score){
                min = students[i].score;
                index = i;
            }
        }

        return students[index];
    }

    // 2. 총 점수 합계, 총 점수 평균을 보여주는 기능,
    function getSumAvr() public view returns (uint, uint) {
        require(students.length > 0, "Length of Student[] is 0");
        uint sum = 0;

        for(uint i = 0; i < students.length; i++) {
            sum += students[i].score;
        }

        return (sum, sum/students.length);
    }

    // 3. 특정 학생을 반환하는 기능, -> 숫자로 반환
    function getStudentByNumber(uint _number) public view returns(Student memory) {
        require(searchTable_number[_number].isValue, "No key exists");
        return students[searchTable_number[_number].value];
    }

    // 4. 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    function getStudents() public view returns (Student[] memory) {
        return students;
    }

}