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
        uint256 team,
        uint256 affID,
        address addr
    )
    
    // fired at end of buy or reload
    event OnEndTx
    (
        // uint256 compressedData,     
        // uint256 compressedIDs,      
        // bytes32 playerName,
        address playerAddress,
        uint256 playerID,
        uint256 teamID,
        uint256 ethIn
        // uint256 keysBought,
        // address winnerAddr,
        // bytes32 winnerName,
        // uint256 amountWon,
        // uint256 newPot,
        // uint256 P3DAmount,
        // uint256 genAmount,
        // uint256 potAmount,
        // uint256 airDropPot
    );
    
    // fired whenever theres a withdraw
    event OnWithdraw
    (
        uint256 indexed playerID,
        address playerAddress,
        uint256 ethOut,
        uint256 timeStamp
    );
    
    // (fomo3d long only) fired whenever a player tries a reload after round timer 
    // hit zero, and causes end round to be ran.
    event OnReLoadAndDistribute
    (
        address playerAddress,
        bytes32 playerName,
        uint256 compressedData,
        uint256 compressedIDs,
        address winnerAddr,
        bytes32 winnerName,
        uint256 amountWon,
        uint256 newPot,
        uint256 P3DAmount,
        uint256 genAmount
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
    
    // received pot swap deposit
    event OnPotSwapDeposit
    (
        uint256 roundID,
        uint256 amountAddedToPot
    );
}