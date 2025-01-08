// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/*
안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요. 
    
사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)
    
* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
*/

contract CodingTest06 {
    //  안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    struct Proposal{
        uint num;
        string title;
        string contents;
        address proponent;
        uint agree;
        uint disagree;
    }

    // 사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)
    struct User{
        string name;
        address addr;
        uint[] myProposalIndex;
        mapping(string => bool) agree;
        mapping(string => bool) disagree;
    }

    uint userCount;
    Proposal[] proposals;
    mapping(string => uint) public proposalTable;
    mapping(address => User) public userTable;

    // 1. 사용자 등록 기능 - 사용자를 등록하는 기능
    function registUser(string memory _name) public {
        require(userTable[msg.sender].addr == address(0), "User already registered");

        userTable[msg.sender].name = _name;
        userTable[msg.sender].addr = msg.sender;
        userCount ++;
    }

    // 2. 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(string memory _title, bool _agree) public {
        require(userTable[msg.sender].addr != address(0), "Please register as a member first");
        require(!userTable[msg.sender].agree[_title] && !userTable[msg.sender].disagree[_title], "You have already voted on this proposal");

        if(_agree){
            userTable[msg.sender].agree[_title] = true;
            proposals[proposalTable[_title]].agree ++;
        }
        else{
            userTable[msg.sender].disagree[_title] = true;
            proposals[proposalTable[_title]].disagree ++;
        } 
    }

    // 3. 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function propose(string memory _title, string memory _contents) public {
        require(userTable[msg.sender].addr != address(0), "Please register as a member first");

        Proposal memory p = Proposal({
            num : proposals.length + 1,
            title : _title,
            contents : _contents,
            proponent : msg.sender,
            agree : 0,
            disagree : 0
        });

        userTable[msg.sender].myProposalIndex.push(proposals.length);
        proposalTable[_title] = proposals.length;
        proposals.push(p);
    }

    // 4. 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getMyProposal() public view returns (Proposal[] memory, string[] memory) {
        require(userTable[msg.sender].addr != address(0), "Please register as a member first");
        Proposal[] memory ret = new Proposal[](userTable[msg.sender].myProposalIndex.length);
        string[] memory progress = new string[](userTable[msg.sender].myProposalIndex.length);

        for(uint i = 0; i < userTable[msg.sender].myProposalIndex.length; i++) {
            ret[i] = proposals[userTable[msg.sender].myProposalIndex[i]];
            progress[i] = getProgress(ret[i].title);
        }
        return (ret, progress);
    }

    // 5. 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getProposal(string memory _title) public view returns (Proposal memory) {
        return proposals[proposalTable[_title]];
    }


    // 6. 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 
    // 둘 중 하나라도 만족못하면 기각
    function getProgress(string memory _title) public view returns (string memory) {

        uint voter_agree = proposals[proposalTable[_title]].agree;
        uint voter_disagree = proposals[proposalTable[_title]].disagree;
        uint voter = voter_agree + voter_disagree;

        if(_isAfret15Block())
        {
            if(voter >= userCount * 7 / 10 && voter_agree >= voter * 66 / 100)
                return "passed";        
            else
                return "rejected";
        }

        return "In progress";
    }
    function _isAfret15Block() public pure returns (bool){
        return true; // 모르갰..ㅠㅠ
    }
}
