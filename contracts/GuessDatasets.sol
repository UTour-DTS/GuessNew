pragma solidity ^0.4.24;


library GuessDatasets {

    struct Player {
        address addr;   // player address
        bytes32 name;   // player name
        uint256 airdrop;    // airdrop vault
        uint256 gen;    // general vault
        uint256 aff;    // affiliate vault
        uint256 lrnd;   // last round played
        uint256 laff;   // last affiliate id used
    }

    struct PlayerRounds {
        uint256 plyrID;    // playerID
        uint256 uto;    // holding uto when guess
        uint256 price;  // guess price
        uint256 timestamp; // guess timestamp
        uint256 team;     // team id
        bool iswin;     // player is winner or not
    }

    struct Round {
        uint256 plyrCount; // joined players count
        uint256 plyrMaxCount; // max players joined, if players count more than this number, round would be over
        uint256 minUTO; // min amount of token holding
        uint256 prdctID; // productID

        uint256 airdrop;   // airdrop 
        uint256 eth;    // total eth
        uint256 pot;    // eth to pot (during round) / final amount paid to players (after round ends)   

        uint256 strt;   // time round started
        uint256 end;    // time ends/ended

        uint256 price;
        uint256 winPrice; 
        uint256 plyr;   // pID of player in lead
        uint256 team;   // tID of team in lead
        bool ended;     // has round end function been ran
    }

    struct TeamFee {
        uint256 gen;    // % of buy in thats paid to key holders of current round
        uint256 uto;    // % of buy in thats paid to p3d holders
    }

    struct PotSplit {
        uint256 gen;    // % of pot thats paid to players of current round
        uint256 uto;    // % of pot thats paid to uto holders of current round
        uint256 lott;   // % of pot thats paid to airdrop of current round
    } 

    struct Divide {
        uint256 fnd;    // % of guess thats paid to found 
        uint256 aff;    // % of guess thats paid to affiliate
        uint256 airdrop;// % of guess thats paid to airdrop
    }
}