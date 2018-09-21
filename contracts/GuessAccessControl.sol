pragma solidity ^0.4.24;


/// @title A facet of GuessCore that manages special access privileges.
/// @author lihongzhen
contract GuessAccessControl {
    // This facet controls access control for Guess. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is initially set to the address that created the smart contract 
    //         in the GuessCore constructor. The CEO can add new Merchants。
    // 
    //     - The CFO: The CFO can withdraw funds from GuessCore.
    //
    //     - The COO: The COO can manual start and end the game.
    //
    //     - The MCH: The MCH can create and distribute Products.

    /// @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;
    mapping (address => uint256) merchants;

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }

    modifier onlyMCH() {
        require(merchants[msg.sender] != 0, "not member of merchants");
        _; 
    }

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /// @dev Add new merchat
    function addMerchant(address _newMCH) external onlyCEO {
        require(_newMCH != address(0));
        merchants[_newMCH] = 1;
    }
    
    /// @dev remove merchant
    function removeMerchant(address _newMCH) external onlyCEO {
        merchants[_newMCH] = 0;
    }
}