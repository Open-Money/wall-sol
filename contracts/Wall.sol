// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Wall is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => bytes32) public hashes;

    uint256 private _fee;
    bool private _feeEnabled;
    string private __baseURI;

    event WrittenOnTheWall(address user, uint256 tokenId, bytes32 messageHash);

    modifier feeCollector() {
        require(
            msg.value >= _fee || !_feeEnabled,
            "WALL: you must pay the fee to write"
        );
        _;
    }

    constructor() ERC721("Wall", "WALL") {
        setBaseURI("https://wall.omchain.io/");
    }

    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    function setBaseURI(string memory newUri) public onlyOwner {
        __baseURI = newUri;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function write(bytes32 messageHash) public payable feeCollector {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        hashes[tokenId] = messageHash;
        emit WrittenOnTheWall(msg.sender, tokenId, messageHash);
    }

    function setFeesEnabled(bool isEnabled) public onlyOwner {
        _feeEnabled = isEnabled;
    }

    function setFee(uint256 newFee) public onlyOwner {
        _fee = newFee;
    }

    function collectFees() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
