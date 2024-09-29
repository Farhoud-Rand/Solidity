// SPDX-License-Identifier: MIT
// Only owner --> in the same function
pragma solidity ^0.8.20;
contract Contract {
    address public owner=msg.sender;
    constructor () payable{
        if (msg.value < 1 ether)
           revert("You must pay at least 1 ether"); 
    }
    
    // This function will withdraw all funds from the contract and send them to the deployer of the contract.
    function withdraw() public {
        // Require that only the deployer of the contract be allowed to call this function.
        if (msg.sender == owner){
            if(address(this).balance > 0){
                (bool success,) = owner.call{value: address(this).balance}("");
                require(success);
            } else {
                revert("Contract balance should be greater that 0");
            }
        // For all other addresses, this function should revert.
        } else {
            revert("You are not the deployer");
        }
    }
}
// ========================================================
// Function Modifiers 
import "forge-std/console.sol";
contract Example {
    function logMessage() public view logModifier {
        console.log("during");
    }

    modifier logModifier {
        console.log("before");
        _;
        console.log("after");
    }
}
// ========================================================
// SPDX-License-Identifier: MIT
// Only owner --> with function modifier
pragma solidity ^0.8.20;

contract Contract {
	uint configA;
	uint configB;
	uint configC;
	address owner;


	constructor() {
		owner = msg.sender;
	}

    // Notice that the onlyOwner modifier has been added to each of the configuration functions in this contract. Only problem is, it doesn't currently do anything!
	function setA(uint _configA) public onlyOwner {
		configA = _configA;
	}

	function setB(uint _configB) public onlyOwner {
		configB = _configB;
	}

	function setC(uint _configC) public onlyOwner {
		configC = _configC;
	}

    // OnlyOwner modifier requires that only the owner address can call these functions without reverting.
	modifier onlyOwner {
		// Require only the owner access
		if (msg.sender == owner)
		// Run the rest of the function body
			_;
        // Revert other users
		else 
			revert("You are not the owner");
	}
}
