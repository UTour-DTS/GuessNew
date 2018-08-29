pragma solidity ^0.4.24;

import './ProductOwnership.sol';
import './SaleClockAuction.sol';
import './ERC20.sol';
import './GuessEvents.sol';
import './GuessDatasets.sol';

/// @title Handles creating auctions for sale and bid of Product.
///  This wrapper of ReverseAuction exists only so that users can create
///  auctions with only one transaction.
contract GuessBids is ProductOwnership, GuessEvents {

    // price of guess
    uint256 private rndPrz_ = .001 ether; 
    // min withdraw value         
    uint256 private wthdMin_ = .1 ether; 
    // amount of round at the same time          
    uint256 private rndNum_ = 1;  
    // max amount of players in one round                 
    uint256 private rndMaxNum_ = 200;   
    // max percent of pot for product           
    uint256 private rndMaxPrcnt_ = 50; 
    // total valaut for found            
    uint256 private fndValaut_;  
    // total airdrop in this round                  
    uint256 private airdrop_; 

    bool public activated_;                      

    /// @dev erc20 token contract for holding require. it's UTO by default. 
    ERC20 private erc20;

//==============================================================================
// data used to store game info that changes
//=============================|=============================================
    uint256 public rID_;    // round id number / total rounds that have happened
    uint256 public pID_;    // last player number;
//****************
// PLAYER DATA 
//****************
    // (addr => pID) returns player id by address
    mapping (address => uint256) public pIDxAddr_;  
    // (name => pID) returns player id by name        
    mapping (bytes32 => uint256) public pIDxName_; 
    // (pID => data) player data         
    mapping (uint256 => GuessDatasets.Player) public plyrs_;   
    mapping (uint256 => mapping (uint256 => GuessDatasets.PlayerRounds)) public plyrRnds_;
    // (pID => rID => data) player round data by player id & round id
    mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
    // (pID => name => bool) list of names a player owns. 
    // (used so you can change your display name amongst any name you own)
//****************
// ROUND DATA 
//****************
    // (rID => data) round data
    mapping (uint256 => GuessDatasets.Round) public round_; 
    mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_; 
    // (rID => tID => data) eth in per team, by round id and team id
    // mapping (uint256 => mapping(uint256 => GuessDatasets.PlayerRounds)) public rndPlyrs_;
    // (rID => pID => data) player data in rounds, by round id and player id
    mapping (uint256 => GuessDatasets.PlayerRounds[]) public rndPlyrs_;
//****************
// PRODUCT DATA 
//****************
    // (id => product) product data
    mapping(uint256 => Product) public prdcts_; 

//****************
// PRODUCT DATA 
//****************
    // (address => valaut) valaut of tetants sell product
    mapping(address => uint256) public tetants_; 

//****************
// TEAM FEE DATA 
//****************
    // (team => fees) fee distribution by team
    mapping (uint256 => GuessDatasets.TeamFee) public fees_;  
    // (team => fees) pot split distribution by team        
    mapping (uint256 => GuessDatasets.PotSplit) public potSplit_;     
//****************
// DIVIDE
//****************
    GuessDatasets.Divide private divide_; 

//==============================================================================
// initial data setup upon contract deploy
//==============================================================================
    constructor () public
    {
        divide_ = GuessDatasets.Divide(2, 10, 10);
    }

//==============================================================================
// these are safety checks
// modifiers
//==============================================================================
    /**
     * @dev used to make sure no one can interact with contract until it has 
     * been activated. 
     */
    modifier isActivated() {
        require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
        _;
    }
    
    /**
     * @dev prevents contracts from interacting with fomo3d 
     */
    modifier isHuman() {
        address _addr = msg.sender;
        uint256 _codeLength;
        
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0, "sorry humans only");
        _;
    }

    /**
     * @dev sets boundaries for incoming tx 
     */
    modifier isWithinLimits(uint256 _eth) {
        require(_eth >= 1000000000, "pocket lint: not a valid currency");
        require(_eth <= 100000000000000000000000, "no vitalik, no");
        _;    
    }

//==============================================================================
// use these to sell product
// saleauction
//==============================================================================
    // @dev set erc20 token contract by address.
    function setERC20(address _address) external onlyCEO {
        erc20 = ERC20(_address);
    } 

    // @notice The auction contract variables are defined in ProductFactory to allow
    //  us to refer to them in ProductOwnership to prevent accidental transfers.
    // `saleAuction` refers to the auction for gen0 and p2p sale of products.
    // `guessBid` refers to the auction for guess price of products.

    /// @dev Sets the reference to the sale auction.
    /// @param _address - Address of sale contract.
    function setSaleAuctionAddress(address _address) external onlyCEO {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        // NOTE: verify that a contract is what we expect
        require(candidateContract.isSaleClockAuction());

        // Set the new contract address
        saleAuction = candidateContract;
    }

    /// @dev Put a product up for auction.
    ///  Does some ownership trickery to create auctions in one tx.
    function createSaleAuction(
        uint256 _productID,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
        // whenNotPaused
    {
        // Auction contract checks input sizes
        // If product is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _productID));
        // Ensure the product is not pregnant to prevent the auction
        // contract accidentally receiving ownership of the child.
        // NOTE: the kitty IS allowed to be in a cooldown.
        _approve(_productID, address(saleAuction));
        // Sale auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the kitty.
        saleAuction.createAuction(
            _productID,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Transfers the balance of the sale auction contract
    /// to the KittyCore contract. We use two-step withdrawal to
    /// prevent two transfer calls in the auction bid function.
    function withdrawAuctionBalances() external onlyCLevel {
        saleAuction.withdrawBalance();
    }


    
}