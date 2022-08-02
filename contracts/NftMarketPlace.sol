// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// ERRORS 
error NotOwner();
error PriveMustBeAboveZero();
error ItemAlreadyListed();
error NotApprovedForMarketplace();

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
     mapping (address => mapping (uint256 => Listing)) all_listings;

    // *** EVENTS ***
    event Listed(
        address indexed seller,
        address indexed nft,
        uint256 indexed tokenId,
        uint256 price
    );


        //  Modifier
    modifier notListed (
        address nftAddress,
        uint256 tokenId
        
    ) {
        Listing memory listeditem = all_listings[nftAddress][tokenId];
        if (listeditem.price > 0) {
            revert ItemAlreadyListed();
        }
        _;
    }

     modifier onlyOwner (
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
     function List(address nftaddress, uint256 token, uint256 price) external  
      notListed (nftaddress,token)
      onlyOwner(nftaddress,token, msg.sender) 
     {
        if (price <= 0) {
            revert PriveMustBeAboveZero();
        }
              // check if   the  nft is approved for this contract
        IERC721 nft = IERC721(nftaddress);
        if (nft.getApproved(token) != address(this)) {
            revert NotApprovedForMarketplace();
        }
          all_listings[nftaddress][token] = Listing(msg.sender, price);
          emit Listed (msg.sender, nftaddress, token, price);

     }
}