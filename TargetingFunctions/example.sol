// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
// =================================================
// Targeting Functions
// =================================================
// We can call functions in 2 syntax:
// 1) high level syntax
// 2) low level syntax
//              ----------------------
// * High level syntax:
//   Create an object of the (contract/interface) and call the function by its name 

// * Low level syntax:
//   - Use call function and write the instruction in bytes as (opcode,operand1, operand2)
//   - To get the opcode for the function get the first 4 bytes of the output of keccak256() hash function
//     and enter the function signture to it (functionName(parameter List Types without space or alsing means we should use uint256 not uint)) 

// In this example we will have 2 contract A(to save the arithmetic results) and contract B (to do the arithmetic operations) 
contract A {
    address b;                // Address of contract B
    uint16 public sum;        // Addition result
    uint8 public sub;        // Subtraction result
    uint16 public product;    // Multiplication result
    uint8 public num1;        // First operand
    uint8 public num2;        // Second operand

    constructor(address _b, uint8 _num1, uint8 _num2) {
        b = _b;
        num1 = _num1;
        num2 = _num2;
    }

    // This function will call the functions in 2 syntax from contact B
    function doOperations() external {
        // High level syntax 
        sum = B(b).add(num1, num2);

        // Low level syntax
        // We need to get the instraction in bytes using abi.encode and call it using call function
        (bool successSub,bytes memory returnSubResult) = b.call(abi.encodeWithSignature("sub(uint8,uint8)", num1, num2)); 
        require(successSub);
        // To save the result from retruned data we need to use decode function 
        // Note we use () inside decode function because return could retruns a tuple
        sub = abi.decode(returnSubResult,(uint8));
        console.log(sub);
        
        // Low low level syntax (make what encode function do)
        // First we need to get the opcode for the function mul(uint8,uint8)
        console.logBytes32(keccak256("mul(uint8,uint8)")); 
        // This is the output: 0xe51a3b408354cd13750692a2f03748f42713bd8d49a185071f86f9a3b2634370
        // So the opcode for mul opration is 0xe51a3b40
        (bool success,bytes memory returnData) = b.call(
            hex"e51a3b4000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000008"
            // Call a not decleared opcode will cause to revert the transaction or call the fallback function in contact B 
            // hex"e5103b4000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000008"
        );
        require(success);
        // To save the result from retruned data we need to use decode function 
        product = abi.decode(returnData,(uint16));
        console.log(product);
    }
}

contract B {
    function add(uint8 num1, uint8 num2) external pure returns(uint16){
        return num1+num2;
    }

    function sub(uint8 num1, uint8 num2) external pure returns(uint8){
        return num1-num2;
    }
    function mul(uint8 num1, uint8 num2) external pure returns(uint16){
        console.log("Mul function operands:", num1,num2);
        return num1*num2;
    }

    fallback() external {
        console.log("Function is not found");
        console.log("Function signiture is:");
        console.logBytes4(msg.sig);
        console.log("Function data is:");
        console.logBytes(msg.data);
    }
}