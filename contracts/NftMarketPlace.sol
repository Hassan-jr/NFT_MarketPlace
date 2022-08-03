// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// ERRORS
error NotOwner();
error PriveMustBeAboveZero();
error ItemAlreadyListed();
error NotApprovedForMarketplace();
error InsufficientFund();
error ItemNotListed();

contract NftMarketPlace is ReentrancyGuard {
    // Buy
    // list
    // update
    // cancel
    // withdraw
    struct Listing {
        address seller;
        uint256 price;
    }

    // *** MAPPING ***
    mapping(address => mapping(uint256 => Listing)) all_listings;
    mapping(address => uint256) addressToAmount;

    // *** EVENTS ***
    event Listed(
        address indexed seller,
        address indexed nft,
        uint256 indexed tokenId,
        uint256 price
    );

    event ItemBought(
        address indexed buyer,
        address indexed nft,
        uint256 indexed tokenId,
        uint256 price
    );

    //  Modifier
    modifier notListed(address nftAddress, uint256 tokenId) {
        Listing memory listeditem = all_listings[nftAddress][tokenId];
        if (listeditem.price > 0) {
            revert ItemAlreadyListed();
        }
        _;
    }

    modifier isListed(address nftAddress, uint256 tokenId) {
        Listing memory listeditem = all_listings[nftAddress][tokenId];

        if (listeditem.price < 0) {
            revert ItemNotListed();
        }
        _;
    }

    modifier onlyOwner(
        address nftAddress,
        uint256 tokenId,
        address spender
    ) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NotOwner();
        }
        _;
    }

    //  ********* Main Functions ****************************
    // ******************************************************

    //  LIST AN ITEM
    function List(
        address nftaddress,
        uint256 token,
        uint256 price
    )
        external
        notListed(nftaddress, token)
        onlyOwner(nftaddress, token, msg.sender)
    {
        if (price <= 0) {
            revert PriveMustBeAboveZero();
        }

        IERC721 nft = IERC721(nftaddress);
        if (nft.getApproved(token) != address(this)) {
            revert NotApprovedForMarketplace();
        }
        all_listings[nftaddress][token] = Listing(msg.sender, price);
        emit Listed(msg.sender, nftaddress, token, price);
    }

    // BUY ITEM
    function Buy(address nftaddress, uint256 token)
        external
        payable
        isListed(nftaddress, token)
    {
        Listing memory itembought = all_listings[nftaddress][token];
        if (msg.value < itembought.price) {
            revert InsufficientFund();
        }

        addressToAmount[itembought.seller] += msg.value;
        delete (all_listings[nftaddress][token]);
        IERC721(nftaddress).safeTransferFrom(
            itembought.seller,
            msg.sender,
            token
        );
        emit ItemBought(msg.sender, nftaddress, token, itembought.price);
    }
}
