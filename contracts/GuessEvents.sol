pragma solidity ^0.4.24;


/**
@dev events
 */
contract GuessEvents {

    // create round 
    event OnNewRound (
        uint256 rid
    );

    // guess 
    event OnGuess (
        uint256 rID,
        uint256 pID,
        uint256 price,
        uint256 affID,
        uint256 timestamp,
        address addr
    );
    
    // fired at end of buy or reload
    event OnEndTx
    (
        address playerAddress,
        uint256 playerID,
        uint256 ethIn
    );
    
    // OnEndRound
    event OnEndRound
    (
        uint256 rID,
        uint256 pID,
        uint256 winPrice,
        uint256 endTime,
        address addr
    );

    // OnAirdrop
    event OnAirdrop
    (
        uint256 valaut,
        uint256 playerCount,
        uint256 timestamp
    );

    // fired whenever theres a withdraw
    event OnWithdraw
    (
        uint256 indexed playerID,
        address playerAddress,
        uint256 ethOut,
        uint256 timeStamp
    );
    
    // fired whenever an affiliate is paid
    event OnAffiliatePayout
    (
        uint256 indexed affiliateID,
        address affiliateAddress,
        uint256 indexed roundID,
        uint256 indexed buyerID,
        uint256 amount,
        uint256 timeStamp
    );
}