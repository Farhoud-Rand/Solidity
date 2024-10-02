// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    //========================================================================
    // Normal map mapping(address => bool)
    //========================================================================
    // Create a public mapping called members which maps an address to a bool.
    // The bool will indicate whether or not the address is currently a member!
    mapping(address=>bool) public members;

    // Function to add a new member to list of members 
    function addMember(address newAddress) public {
        if(members[newAddress] == false)
           members[newAddress] = true;
        else 
            revert("You are aleady a member"); 
    } 

    // Function to check if the address existing in the list or not
    function isMember(address add) external view returns (bool){
        return members[add]; // The value in the map is boolean so we can return it directly 
    }

    // Function to remove a member from the list
    // Note in solidity there is no (null, none, undefined) values so non exsiting value will have the default value for the data type
    // So to remove an element from map just change its value to be the default value
    function removeMember(address add) external{
        members[add] = false;
    }
    //========================================================================
    // Struct inside a map mapping(address => struct)
    //========================================================================
    // User struct 
    struct User {
		uint balance;
		bool isActive;
	}
    // Create a public mapping called users that will map an address to a User struct.
	mapping(address=>User) public users;

    // This function should create a new user and associate it to the msg.sender address in the users mapping.
    // The balance of the new user should be set to 100 and the isActive boolean should be set to true.
	// newUser modifier --> Ensure that the createUser function is called with an address that is not associated with an active user. Otherwise, revert the call. 
    function createUser() external newUser {
		User memory user = User(100,true);
		users[msg.sender] = user;
	}

    // In this function, transfer the amount specified from the balance of the msg.sender to the balance of the recipient address.
    // Ensure that both addresses used in the transfer function have active users.
    // Ensure that the msg.sender has enough in their balance to make the transfer without going into a negative balance.
    // If either of these conditions aren't satisfied, revert the call.
	function transfer(address add, uint amount) external {
		if(users[msg.sender].isActive = true && users[add].isActive){
			if (users[msg.sender].balance >= amount){
				users[msg.sender].balance -= amount;
				users[add].balance += amount;
			} else 
				revert("The sender don't have enough money in his balance");
		} else 
			revert("Error: One of the addresses is not active!");
	}

	modifier newUser {
		if(users[msg.sender].balance == 0 && users[msg.sender].isActive == false)
			_;
		else
			revert("You already in the list");
	}
    //========================================================================
    // Nested map mapping(uint => mapping(address => bool))
    //========================================================================
    enum ConnectionTypes { 
		Unacquainted,
		Friend,
		Family
	}
	
	// create a public nested mapping `connections` 
	mapping (address => mapping(address => ConnectionTypes)) public connections; 
	
	function connectWith(address other, ConnectionTypes connectionType) external {
        // make the connection from msg.sender => other => connectionType
		connections[msg.sender][other] = connectionType;
	}
}