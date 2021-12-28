// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Dao is Ownable {

	address payable public winner;
	uint public timePeriod = 10 minutes;
	uint votingPeriod;
	uint public indexOfWinner;


	struct Proposal {
		address recipient;
		uint amount;
		string name;
		string proposalText;
		uint votes;
		bool passed;
		uint assignedPower;
	}


	struct Voter {
		uint vote;
		address voterAddress;
		uint power;
		bool authorized;
		bool voted;
	}

	enum ELECTION_STATE {
		OPEN,
		CLOSED
	}

	ELECTION_STATE public election_state;
	Proposal[] public proposals;
	mapping(address => Voter) public voters;


	constructor() {
		election_state = ELECTION_STATE.CLOSED;
	}


	function startVoting() public onlyOwner {
		require(election_state == ELECTION_STATE.CLOSED);
		votingPeriod = block.timestamp + timePeriod;
		election_state = ELECTION_STATE.OPEN;
	}


	function registerProposal(address _recipient, uint _amount, string memory _name, string memory _proposal) public {
		require(election_state == ELECTION_STATE.OPEN);
		proposals.push(Proposal(_recipient, _amount, _name, _proposal, 0, false, 0));
	}


	function getPower() payable public {
		require(msg.value > 0, "The amount can't be 0");
		require(election_state == ELECTION_STATE.OPEN);
		require(votingPeriod > block.timestamp);
		uint amountSent = msg.value;
		// This function will take their money and assign power to the voter
		// The power is equal to their deposit in eth * 10 so for each eth they get 10 power
		voters[msg.sender].power = msg.value * 10;
		payable(msg.sender).transfer(amountSent);
	}


	function showPower() public view returns (uint) {
		uint voterPower = voters[msg.sender].power;
		return voterPower;
	}


	function vote(uint _vote) public {
		require(voters[msg.sender].voted == false);
		require(voters[msg.sender].power > 0, "You need to have some power to vote");
		require(election_state == ELECTION_STATE.OPEN);
		voters[msg.sender].vote = _vote;
		uint amountOfPower = voters[msg.sender].power;
		proposals[_vote].votes += 1;
		proposals[_vote].assignedPower += amountOfPower;
		voters[msg.sender].voted = true;
	}


	function endVoting() public onlyOwner {
		require(election_state == ELECTION_STATE.OPEN);
		election_state = ELECTION_STATE.CLOSED;
	}


	function countVotes() public onlyOwner view returns (uint _winningProposal) {
		// require(block.timestamp > votingPeriod, "The voting hasn't ended yet");
		uint mostPower = 0;
		for (uint index = 0; index < proposals.length; index++) {
			if (proposals[index].assignedPower > mostPower) {
				mostPower = proposals[index].assignedPower;
				_winningProposal = index;
			}
		}
	}


	function winnerName() public view returns(string memory) {
		require(election_state == ELECTION_STATE.CLOSED, "Election hasn't ended yet");
		string memory winningName = proposals[countVotes()].name;
		return winningName;
	}
}






