// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVoting {

    address public owner;

    struct Candidate {
        string name;
        uint votes;
    }

    Candidate[] public candidateList;

    mapping(address => bool) public voted;

    event VoteCast(address voter, uint candidateIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // add a candidate (only owner)
    function addCandidate(string memory _name) public onlyOwner {
        require(bytes(_name).length > 0, "Name cannot be empty");

        candidateList.push(Candidate(_name, 0));
    }

    // vote once
    function vote(uint _index) external {
        require(!voted[msg.sender], "You already voted");
        require(_index < candidateList.length, "Candidate does not exist");

        voted[msg.sender] = true;
        candidateList[_index].votes++;

        emit VoteCast(msg.sender, _index);
    }

    // total number of candidates
    function getTotalCandidates() public view returns (uint) {
        return candidateList.length;
    }

    // get candidate info
    function getCandidate(uint _index) public view returns (string memory, uint) {
        require(_index < candidateList.length, "Invalid index");

        Candidate memory c = candidateList[_index];
        return (c.name, c.votes);
    }

    // find current winner
    function getWinner() public view returns (string memory) {
        require(candidateList.length > 0, "No candidates");

        uint highestVotes = 0;
        uint winnerIndex = 0;

        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i].votes > highestVotes) {
                highestVotes = candidateList[i].votes;
                winnerIndex = i;
            }
        }

        return candidateList[winnerIndex].name;
    }

    // reset all votes (only owner)
    function resetVotes() public onlyOwner {
        for (uint i = 0; i < candidateList.length; i++) {
            candidateList[i].votes = 0;
        }
    }
}