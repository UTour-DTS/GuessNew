pragma solidity ^0.4.24;


contract ERC20{
    uint256 public totalSupply;
    
    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    
    function approve(address _spender, uint256 _value) public returns (bool success);
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
    
    function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success);
    
    function burn(uint256 _value) public returns (bool success);
    function burnFrom(address _from, uint256 _value) public returns (bool success);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed from, uint256 value);
}