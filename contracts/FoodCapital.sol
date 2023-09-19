// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact parkorn@farzai.com
contract FoodCapital is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MAX_MINT = 5;
    uint256 public constant MAX_MINT_WHITELIST = 10;
    uint256 public constant PRICE_PER_TOKEN = 0.01 ether;

    bool public isSaleActive = false;
    
    mapping(address => bool) private _waitingList;

    constructor() ERC721("FoodCapital", "FC") {}

    function hasWaitingList(address addr) public view returns (bool) {
        return _waitingList[addr];
    }

    function addToWaitingList(address addr) public onlyOwner {
        _waitingList[addr] = true;
    }

    function removeFromWaitingList(address addr) public onlyOwner {
        delete _waitingList[addr];
    }

    function setSaleState(bool state) public onlyOwner {
        isSaleActive = state;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        require(_waitingList[to], "Address is not in the waiting list");

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
