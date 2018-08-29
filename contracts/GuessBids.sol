pragma solidity ^0.4.24;

import './ProductOwnership.sol';
import './SaleClockAuction.sol';


/// @title Handles creating auctions for sale and bid of Product.
///  This wrapper of ReverseAuction exists only so that users can create
///  auctions with only one transaction.
contract GuessBids is ProductOwnership {

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

    /// @dev Sets the reference to the siring auction.
    /// @param _address - Address of siring contract.
    // function setGuessBidAddress(address _address) external onlyCEO {
    //     SiringClockAuction candidateContract = SiringClockAuction(_address);

    //     // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
    //     require(candidateContract.isGuessBid());

    //     // Set the new contract address
    //     guessBid = candidateContract;
    // }

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
/*
    /// @dev Put a kitty up for auction to be sire.
    ///  Performs checks to ensure the kitty can be sired, then
    ///  delegates to reverse auction.
    function createGuessBid(
        uint256 _productID,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If kitty is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _productID));
        require(isReadyToBreed(_productID));
        _approve(_productID, address(guessBid));
        // Siring auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the kitty.
        siringAuction.createAuction(
            _productID,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Completes a siring auction by bidding.
    ///  Immediately breeds the winning matron with the sire on auction.
    /// @param _sireId - ID of the sire on auction.
    /// @param _matronId - ID of the matron owned by the bidder.
    function bidOnSiringAuction(
        uint256 _sireId,
        uint256 _matronId
    )
        external
        payable
        whenNotPaused
    {
        // Auction contract checks input sizes
        require(_owns(msg.sender, _matronId));
        require(isReadyToBreed(_matronId));
        require(_canBreedWithViaAuction(_matronId, _sireId));

        // Define the current price of the auction.
        uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
        require(msg.value >= currentPrice + autoBirthFee);

        // Siring auction will throw if the bid fails.
        siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
        _breedWith(uint32(_matronId), uint32(_sireId));
    }

    /// @dev Transfers the balance of the sale auction contract
    /// to the KittyCore contract. We use two-step withdrawal to
    /// prevent two transfer calls in the auction bid function.
    function withdrawAuctionBalances() external onlyCLevel {
        saleAuction.withdrawBalance();
        guessBid.withdrawBalance();
    }

    */
}