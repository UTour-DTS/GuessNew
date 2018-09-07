pragma solidity ^0.4.24;


library GuessDatasets {

    struct Player {
        address addr;   // player address
        uint256 airdrop;    // airdrop vault
        uint256 gen;    // general vault
        uint256 aff;    // affiliate vault
        uint256 lrnd;   // last round played
        uint256 laff;   // last affiliate id used
        uint256 lockUto; // locked uto
    }

    struct PlayerRounds {
        uint256 plyrID;    // playerID
        uint256 uto;    // holding uto when guess
        uint256 price;  // guess price
        uint256 timestamp; // guess timestamp
        bool iswin;     // player is winner or not
    }

    struct Round {
        uint256 plyrCount; // joined players count
        uint256 plyrMaxCount; // max players joined, if players count more than this number, round would be over
        uint256 prdctID; // productID
        uint256 percent; // percent to tetants    

        uint256 holdUto;   // need holding uto 
        uint256 eth;    // total eth
        uint256 pot;    // eth to pot (during round) / final amount paid to players (after round ends)   

        uint256 strt;   // time round started
        uint256 end;    // time ends/ended

        uint256 price;
        uint256 plyr;   // pID of player in lead
        bool ended;     // has round end function been ran
    }

    struct Divide {
        uint32 fnd;    // % of guess thats paid to found 
        uint32 aff;    // % of guess thats paid to affiliate
        uint32 airdrop;// % of guess thats paid to airdrop
    }
}