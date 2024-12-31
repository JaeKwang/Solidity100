// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
* 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
* 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
* 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
-------------------------------------------------------------------------------
* S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)

기입할 학생들의 정보는 아래와 같습니다.

Alice, 1, 85
Bob,2, 75
Charlie,3,60
Dwayne, 4, 90
Ellen,5,65
Fitz,6,50
Garret,7,80
Hubert,8,90
Isabel,9,100
Jane,10,70

*/

contract CodingTest01 {
    
    // 이름, 번호, 점수, 학점 그리고 듣는 수업
    struct Student {
        string name;
        uint number;
        uint score;
        string grade;
        string[] courseList;
    }

    Student[] students;
    mapping(string => uint) searchTable_name;

    // 1. 학생 추가 기능 - 특정 학생의 정보를 추가
    // * 학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.
    function pushStudent(string memory _name, uint _score) public {
        Student memory s;    
        s.name = _name;
        s.score = _score;
        s.number = students.length + 1;
        
        // calculate grade
        if(_score >= 90) s.grade = "A";
        else if(_score >= 80) s.grade = "B";
        else if(_score >= 70) s.grade = "C";
        else if(_score >= 60) s.grade = "D";
        else s.grade = "F";

        students.push(s);

        // for 3. getStudentByName
        searchTable_name[_name] = s.number;
    }

    // 2. 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    function getStudentByNum(uint _num) public view returns(Student memory) {
        require(_num > 0);
        return students[_num -1];
    }

    // 3. 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudentByName(string memory _name) public view returns(Student memory) {
        require(searchTable_name[_name] > 0);
        return students[searchTable_name[_name] - 1];
    }
    // 3-1. 동명이인이 있을 경우
    function getStudentByName2(string memory _name) public view returns(Student[] memory) {
        uint count = 0;

        // 매칭되는 학생 수를 셈
        for (uint i = 0; i < students.length; i++) {
            if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(students[i].name))) {
                count++;
            }
        }

        // 배열 생성
        Student[] memory ret = new Student[](count);
        uint index = 0;

        // 매칭되는 학생을 배열에 추가
        for (uint i = 0; i < students.length; i++) {
            if (keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked(students[i].name))) {
                ret[index] = students[i];
                index++;
            }
        }

        return ret;
    }

    // 4. 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getScoreByName(string memory _name) public view returns(uint) {
        return getStudentByName(_name).score;
    }

    // 5. 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    function getStudentNum() public view returns(uint) {
        return students.length;
    }

    // 6. 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getStudentAll() public view returns(Student[] memory) {
        return students;
    }

    // 7. 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getAverageScore() public view returns(uint) {
        require(getStudentNum() > 0);

        uint aver = 0;
        for(uint i = 0; i < getStudentNum(); i++) aver += students[i].score;
        aver /= getStudentNum();
        return aver;
    }

    // 8. 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function evaluation() public view returns(bool) {
        return getAverageScore() >= 70;
    }

    // 9. 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    function getStudent_F() public view returns(Student[] memory) {
        uint count = 0;

        // 매칭되는 학생 수를 셈
        for (uint i = 0; i < students.length; i++) {
            if (students[i].score < 60) {
                count++;
            }
        }

        // 배열 생성
        Student[] memory ret = new Student[](count);
        uint index = 0;

        // 매칭되는 학생을 배열에 추가
        for (uint i = 0; i < students.length; i++) {
            if (students[i].score < 60) {
                ret[index] = students[i];
                index++;
            }
        }

        return ret;
    }

    // 10. S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)
    function getStudent_S() public view returns(Student[] memory) {
        uint length = students.length;
        Student[] memory sortedStudents = new Student[](length);

        // students 배열 복사
        for (uint i = 0; i < length; i++) sortedStudents[i] = students[i];

        // Bubble Sort (내림차순)
        for (uint i = 0; i < length; i++) {
            for (uint j = 0; j < length - i - 1; j++) {
                if (sortedStudents[j].score < sortedStudents[j + 1].score) {
                    // Swap
                    (sortedStudents[j], sortedStudents[j+1]) = (sortedStudents[j+1], sortedStudents[j]);
                }
            }
        }

        // 상위 4개의 학생만 반환 (배열 길이에 따라 조정)
        uint returnLength = length >= 4 ? 4 : length;
        Student[] memory top4Students = new Student[](returnLength);
        for (uint i = 0; i < returnLength; i++) top4Students[i] = sortedStudents[i];

        return top4Students;
    }

    // for Test
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
}
