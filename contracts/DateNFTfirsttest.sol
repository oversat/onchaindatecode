// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Drop.sol";

contract DateNFT is ERC721Drop {
   constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient
    )
        ERC721Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {}
  // Maximum number of tokens that can be minted
  uint256 public constant MAX_TOKENS = 365;

 // Current date, initialized to the time of mint
  // in UTC time zone
  uint256 public date;

  // Mapping from token ID to time zone offset
  // (using a fixed-size array to save on gas fees)
  int256[25] public timeZoneOffsets;

  // Mints a new NFT with the current date in the
  // specified time zone
  function mintAndCreateSVG(int256 timeZoneOffset) public {
    // Check that the total supply does not exceed 365
    require(totalSupply < 365, "Maximum number of NFTs reached.");

    // Calculate the token ID based on the current
    // date and time zone offset
    uint256 tokenId = date + timeZoneOffset;

    // Check if the token ID is already in use
    require(!_exists(tokenId), "Token ID is already in use.");

    // Record the time zone offset for the token
    timeZoneOffsets[timeZoneOffset + 12] = timeZoneOffset;

    // Generate the SVG image data for the token
    bytes memory svgData = createSVGLayers(tokenId);
// Generates the SVG image layers for the specified token
function createSVGLayers(uint256 _tokenId) public view returns (bytes memory) {
  // Set the image dimensions to 500x500 pixels
  string memory dimensions = "width='500' height='500'";

  // Generate a random HEX color for the background
  string memory backgroundColor = randomHexColor();

  // Set the font size and alignment for the token ID
  string memory tokenIdStyle = "font-size='12' text-anchor='end'";

  // Set the font size, weight, and alignment for the date
  string memory dateStyle = "font-size='24' font-weight='bold' text-anchor='middle'";

  // Create the SVG image layers
  bytes memory svgData = createSVGLayers(
    dimensions,
    backgroundColor,
    _tokenId,
    tokenIdStyle,
    date,
    dateStyle
  );

  // Return the generated SVG data
  return svgData;
}

    // Mint the NFT with the generated SVG data
    _mint(msg.sender, tokenId, svgData);

    // Increment the total supply
    totalSupply++;
  }

  // Sets the current date to a new value
  // (using a view function to save on gas fees)
  function setDate(uint256 newDate, uint256 tokenId) view public {
    // Only the owner of the specified token
    // can set the date
    require(_isOwner(msg.sender, tokenId), "Only the owner of the token can set the date.");

    // Set the current date
    date = newDate;
  }

  // Generates the SVG image layers for the specified token
  function createSVGLayers(uint256 tokenId) public view returns (bytes memory) {
    // Retrieve the time zone offset for the token
    int256 timeZoneOffset = timeZoneOffsets[tokenId - date + 12];

    // Generate the SVG layers for the date and time zone
    bytes memory dateLayer = createTextLayer(
      formatDate(date, timeZoneOffset),
      "Roboto",
      24,
      0x000000,
      0xFFFFFF
    );

    // Return the generated SVG layers
    return dateLayer;
  }
}
