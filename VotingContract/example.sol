// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/console.sol";
// We're going to focus on creating a voting contract that will allow members to create new proposals.
// This contract can contain many proposals which will be voted on by a group of members. 
// Each proposal will keep track of its votes to decide when its time to execute.
// At execution time, these proposals will send calldata to a smart contract.
// The calldata could be anything! We could have a Voting system that allows 100 members to decide when to upgrade a protocol. 
// The calldata might target a function with the signature upgrade(address) and send over the new protocol implementation.
// That would be a very cool use of your Voting contract!

contract Voting {
    // Array of valid addresses that can create a new proposal or add a vote 
    address[] validAddresses;
    uint threshold = 10;

    // Get the valid addresses + depolyed user address
    constructor (address[] memory _validAddresses){
        validAddresses = _validAddresses;
        validAddresses.push(msg.sender);
    }

    // This struct is used to use it in modification operation 
    struct Vote {
        bool hasVoted;
        bool value;
    }

    // Event when we successfully create a proposal  
    event ProposalCreated(uint256 proposalId);
    // Event when we successfully add a vote on a proposal  
    event VoteCast(uint256 proposalId,address voter);

    // A proposal should take in some calldata, and a target.
    // When the proposal passes the voting stage, the contract will send that calldata to the target.
    // To begin with, the yesCount and noCount should be zero until we record some votes!    
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        // mapping (address=>bool) votes; // We need to change this because solidity doesn't have (null, none, undefied value) so initially the value for all address will be default value which is false (and this will effect the logic) 
        mapping (address=>Vote) votes;    // Save all users who votes and their votes 
    }

    // List of propsals
    Proposal[] public proposals;

    // Function to create a new proposal and add it to the list of proposals
    // Note only the valid addresses can create new proposal
    function newProposal(address targetAddress, bytes calldata _data) external onlyValidAddresses{
        Proposal storage proposal =  proposals.push();
        proposal.target = targetAddress;
        proposal.data = _data;
        proposal.yesCount = 0;
        proposal.noCount = 0;
        emit ProposalCreated(proposals.length-1);
    } 

    // Function to add a vote for a proposal
    // Note only the valid addresses can vote/modify vote for a proposal
    function castVote(uint id, bool vote) external onlyValidAddresses{
        // Modify the old vote
        if(proposals[id].votes[msg.sender].hasVoted){
            if(vote && proposals[id].votes[msg.sender].value == false ){
                proposals[id].yesCount += 1;
                proposals[id].noCount -= 1;
            } else if (!vote && proposals[id].votes[msg.sender].value == true) {
                proposals[id].noCount += 1;
                proposals[id].yesCount -= 1;
            }
        // Vote for the first time
        } else{
            if(vote){
                proposals[id].yesCount += 1;
            }else { 
                proposals[id].noCount += 1;
            }
            // For new vote either vote yes or no 
            proposals[id].votes[msg.sender].hasVoted = true;
            emit VoteCast(proposals.length-1, msg.sender);
        }
        // For all votes (new vote, or old vote) update the value of the users' vote and check if we reach the threshold or not
        proposals[id].votes[msg.sender].value = vote; 
        if (proposals[id].yesCount == threshold)
            execute(id);           
    }

    // Function to execute the proposal 
    function execute(uint256 id) internal{
        (bool success,) = proposals[id].target.call(proposals[id].data);
    }

    // Check if the user is valid to do the operation or not
    modifier onlyValidAddresses {
        bool notValidUser = true;
        for(uint i = 0; i < validAddresses.length; i++){
            if (validAddresses[i] == msg.sender){
                _;
                notValidUser = false;
            }
        }
        if (notValidUser)
            revert("This is not a valid address");
    }
}