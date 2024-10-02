// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Contract {
	enum Choices { Yes, No }
	
	struct Vote {
		Choices choice;
		address voter;
	}
	
	// Create a public state variable: an array of votes
	Vote[] public votes;

	// Function to add a new vote to the array of votes state variable
	function createVote(Choices choice) external onlyOnce {
		Vote memory vote = Vote(choice, msg.sender);
		votes.push(vote);
	}

    // Internal function to loop on votes list and return the index of voter address
    // Note return -1 if the voter address not existing --> so the return type will be int  
	function findVote(address voterAddress) internal view returns(int256){
		for(uint i=0; i<votes.length; i++){
			if (votes[i].voter == voterAddress)
				return int256(i);
		}
		return -1;
	}

    // Function to check if this user has a vote or not
	function hasVoted(address voterAddress) external view returns(bool){
		if(findVote(voterAddress) != -1)
			return true;
		return false;
	}

    // Function to get the user choice if existing 
	function findChoice(address voterAddress) external view returns(Choices){
		int index = findVote(voterAddress);
		if(index != -1)
            // Note to access to array by key, the key must be in uint256
			return votes[uint256(index)].choice;
        else 
            revert("You don't have a choice yet");
	}

    // Function to allow users to change their votes
	function changeVote(Choices newChoice) external {
		int index = findVote(msg.sender);
		if( index != -1){
			votes[uint256(index)].choice = newChoice;
		} else 
			revert("You don't have a vote");
	}

    // This modifier to make sure that each user create just one vote
	modifier onlyOnce{
		if(findVote(msg.sender) == -1)
			_;
		else 
			revert("You can only create one vote");
	}
}