pragma solidity ^0.4.24;

// import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './Ownable.sol';
import './GuessAccessControl.sol';
import './SaleClockAuction.sol';

/// @title Base contract for Guess. Holds all common structs, events and base variables.
/// @author lihongzhen
contract ProductFactory is GuessAccessControl {
    /*** EVENTS ***/

    /// @dev create new product, will start a new game
    event CreateProduct(
        address owner, 
        uint256 productId, 
        string _name, 
        string _nameEn, 
        string _disc, 
        string _discEn, 
        uint256 _price,
        uint32 _percent,
        uint64 _starttime
        );

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a product
    ///  ownership is assigned, including create.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    /// @dev The main Product struct. Every product in GUESS is represented by a copy
    ///  of this structure, so great care was taken to ensure that it fits neatly into
    ///  exactly two 256-bit words. Note that the order of the members in this structure
    ///  is important because of the byte-packing rules used by Ethereum.
    ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
    struct Product {
        // name of product in Chinese.
        string name;

        // name of product in English.
        string nameEn;

        // discription of product in Chinese.
        string disc;

        // discription of product in English.
        string discEn;

        // reference price for the market.
        uint256 price;

        // percent of merchant will withdraw.
        uint32 percent;

        // The timestamp from the block when this cat came into existence.
        uint64 createTime;

        // The latest timestamp of game will start.
        uint64 lastestTime;
    }

    /*** CONSTANTS ***/

    // An approximation of currently how many seconds are in between blocks.
    uint256 public secondsPerBlock = 15;

    /*** STORAGE ***/

    /// @dev An array containing the Products struct for all Product in existence. The ID
    ///  of each product is actually an index into this array. Note that ID 0 is invalid.
    Product[] public products;

    /// @dev A mapping from product IDs to the address that owns them. All products have
    ///  some valid owner address.
    mapping (uint256 => address) public productToOwner;

    // @dev A mapping from owner address to count of tokens that address owns.
    //  Used internally inside balanceOf() to resolve ownership count.
    mapping (address => uint256) ownerProductCount;

    /// @dev A mapping from ProductIDs to an address that has been approved to call
    ///  transferFrom(). Each Product can only have one approved address for transfer
    ///  at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public productToApproved;

    /// @dev The address of the ClockAuction contract that handles sales of Product. 
    ///  The Players can sale the Product which they win.
    SaleClockAuction public saleAuction;

    /// @dev The address of a custom subclassed contract that handles Guess
    ///  auctions.
    // GuessBid public guessBid;

    /// @dev Assigns ownership of a specific Product to an address.
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of products is capped to 2^32 we can't overflow this
        ownerProductCount[_to]++;
        // transfer ownership
        productToOwner[_tokenId] = _to;
        // When creating new products _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownerProductCount[_from]--;
            // clear any previously approved ownership exchange
            delete productToApproved[_tokenId];
        }
        // Emit the transfer event.
        emit Transfer(_from, _to, _tokenId);
    }

    /// @dev An internal method that creates a new product and stores it. This
    ///  method doesn't do any checking and should only be called when the
    ///  input data is known to be valid. Will generate both a CreateProduct event
    ///  and a Transfer event.
    /// @param _name The name of product in Chinese.
    /// @param _nameEn The name of product in English.
    /// @param _disc The discription of product in Chinese.
    /// @param _discEn The discription of product in English.
    /// @param _price The reference price of Product for the market.
    /// @param _percent The percent of merchant will withdraw.
    /// @param _starttime The lastest time when game will start.
    /// @param _owner The inital owner of this product, must be non-zero.
    function _createProduct(
        string _name, 
        string _nameEn, 
        string _disc, 
        string _discEn, 
        uint256 _price, 
        uint32 _percent,
        uint64 _starttime,
        address _owner
    )
        internal
        returns (uint256)
    {
        // required _owner must be merchant.
        require(merchants[msg.sender] != 0);

        Product memory _product = Product({
            name: _name,
            nameEn: _nameEn,
            disc: _disc,
            discEn: _discEn,
            price: _price,
            percent: _percent,
            lastestTime: _starttime,
            createTime: uint64(now)
        });

        uint256 newProductId = products.push(_product) - 1;

        // emit the CreateProduct event
        emit CreateProduct(
            _owner,
            newProductId,
            _name,
            _nameEn,
            _disc,
            _discEn,
            _price,
            _percent,
            _starttime
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(address(0), _owner, newProductId);

        return newProductId;
    }

    // Any C-level can fix how many seconds per blocks are currently observed.
    function setSecondsPerBlock(uint256 secs) external onlyCLevel {
        require(secs > 0);
        secondsPerBlock = secs;
    }
}