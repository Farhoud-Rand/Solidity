// Solidity Version and license
//------------------------------
// For license we need to add the its type: open license, MIT,..
// pragma solidity 0.8.19; // work only with 0.8.19 version
// pragma solidity >=0.8.19 <0.9.0; // Versions that are grater than 0.8.19 or less than 0.9.0

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; // works with 0.8.19 and above versions

// -------------------------------------------
// contract is the same as classes in opp
contract FirstCode {
    // Basic state variable types:
    // boolean, uint {unsigned integer}, int{signed integer}, address, bytes {fix size array}
    // The default visibility is intrernal 
    // These are called state variables {variable outside the functions} --> it will be save in storage 
    bool booleanVar = true;
    uint firstuInt = 10; // by default it contains 256 bit but we can specify the number of bits{8,16,32,64,128,256} like the next line
    uint8 seconduInt = 3;
    int firstInt = -30;  // The same as uint
    int8 secondInt = -3;
    address myAdress = 0x111122223333444455556666777788889999aAaa; // Holds Ethereum addresses (20-byte values)
    bytes32 myBytes = "hello"; // It can by from 1 to 32
    bytes1 oneByte = "g";      // byte = bytes1
    string myString = "hi";    // The same as bytes, array of characters

    // Functions 
    // function functionName(Parameter List) access modifiers [returns(returnTypes)] 
    // Visiability modifiers:
    //   * public --> internally and externally
    //   * external --> externally,this is only used with functions not variable, Another function inside this contract couldn’t call an external function
    //   * internal --> internally, only inside contract and its child -it is the defalut
    //   * private --> only inside contract
    //   * view --> only allow read state from the blockchain and disallow update variables (functions that don't have to run or send a transaction for me when we call them it will be in blue while function which send transaction will be in orange)
    //   * pure --> disallow read state or storage from the blockchain and also disallow update variables (functions that don't have to run or send a transaction for me when we call them)
    
    int256 public myFavoriteNumber = 6; // public access modifier create a get method for this variable {state and storage variable}  

    // This function to update the value of a state varaible 
    // Snice we updata something in a blockchain then we need to send a transaction (so we cannot use view or pure modifier)
    function store(int256 _favoriteNumber) public {
        // _favoriteNumber is a local variable {variable inside a function}
        myFavoriteNumber = _favoriteNumber;
    }

    // Function to get a private variables, we can return more than one varaible (as a tuple) 
    // Note we need to add memory after the string 
    // Bytes will return the ascii code for each character while string will return the characters itself 
    // We add view modifier because we read a state variable, view disallowed any modification of state
    function retrive() public view returns(bytes32 ,string memory) {
        // myFavoriteNumber = myFavoriteNumber + 1; // This line will cause an error
        return (myBytes,myString);
    }

    // Example to use pure modifier (we cannot read or update state variables)
        function retrive2() public pure returns(bytes32) {
        // myFavoriteNumber = myFavoriteNumber + 1; // This line will cause an error
        // return (myBytes,myString);           // This line will cause an error
        return('a');
    }

    // Additional data types:
    // Dynamic array 
    int256[] myArray;
    
    // Static array
    int256[3] myArray2;    
    
    // We can also has a hash map by using mapping
    // Note that for non existting keys the vaule will be the default vause for the value data type
    mapping(string => uint256) public nameToFavoriteNumber;

    // Struct (as small class) --> custom or own type 
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    // Make an object from this struct
    Person public rand = Person(6,"rand");
    Person public ali = Person({name:"ali", favoriteNumber:0});

    // We can make a dynamic array of Pepole 
    Person[] public listOfPeople;

    // Function to add person in the array 
    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        // We can do it like this 
        // Person memory newPerson = Person(_favoriteNumber, _name);
        // listOfPeople.push(newPerson);
       
        // Or directly 
        listOfPeople.push(Person(_favoriteNumber, _name));

        // To add to hash map 
        nameToFavoriteNumber[_name]=_favoriteNumber;
    }

    // Places where EVM can read and write data:
    // calldata, memory, storage
    // calldata, memory --> means that this variable is only going to exist temporarily which means that it exist only for the duration of the function call
    // The difference between them that when we use memory we can re-assign (change or manipulated) the variable name while using calldata don't allow that
    // by default string variable should be a memory variable
    //  * Calldata is a temporary variables that cannot be modified 
    //  * Memory is temporary variables that can be modified 
    //  * Storage is permanent variables (stay in the contract forever) that can be modified
    // State variables will be saved in a storage 
    // Note that we can only use these with primitive data type (string, struct, array)
    // Of course we cannot use storage with parameters of the function (because this variable will be used only for short time)

    // So the addPerson function could be 
    function addPerson2(uint256 _favoriteNumber, string calldata _name) public {
        // _name = "ggg"; // will give an error
        listOfPeople.push(Person(_favoriteNumber, _name));
    }    
}