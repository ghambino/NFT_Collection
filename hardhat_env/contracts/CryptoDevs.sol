//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//import neccessary files and standards for creating the NFT and Minting

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
//this value will be added to the tokenID to arrive at individual token URI
// baseTokenURI + TokenID = TokenURI

    string _baseTokenURI;

//price of one crypto Dev NFT

uint256 public _price = 0.01 ether;

//paused is used to pause the NFT in case of an Emergency
bool public _paused;

//
uint256 public maxTokenIds = 20;

//total number of tokenIds minted
uint256 public tokenIds;

//Whitelist contract instance
IWhitelist whitelist;

//boolean variable to keep track of presale kickoff or not
bool public presaleStarted;

//timestamp of when presale to end
uint256 public presaleEnd;

modifier onlyWhenNotPaused {
    require(!_paused, "contract currently paused");
    _;
}

constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
    _baseTokenURI = baseURI;
    whitelist = IWhitelist(whitelistContract); 
}

function startPresale() public onlyOwner {
    presaleStarted = true;
    presaleEnd = block.timestamp + 5 minutes;

}

function presaleMint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp < presaleEnd, "Presale is not running");
    require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
    require(tokenIds < maxTokenIds, "Exceeded Maximum Crypto Devs supply");
    require(msg.value >= _price, "Ethers sent is not correct");

    _safeMint(msg.sender, tokenIds);

     tokenIds += 1;
}
//public minting of the NFT after the presale period ended
function mint() public payable onlyWhenNotPaused {
    require(presaleStarted && block.timestamp >= presaleEnd, "Presale is not running");
    require(tokenIds < maxTokenIds, "Exceeded Maximum Crypto Devs supply");
    require(msg.value >= _price, "Ethers sent is not correct");

    _safeMint(msg.sender, tokenIds);

     tokenIds += 1;
}

function _baseURI() internal view virtual override returns (string memory){ 
    return _baseTokenURI;
}

function setPaused(bool val) public onlyOwner {
    _paused = val;
}

function withdraw() public onlyOwner {
    address _owner = owner();

    uint256 amount = address(this).balance;

    (bool sent, ) = _owner.call{value: amount}("");

    require(sent, "Failed to send Ether");

}
//Receive function when Ether.msg.data is empty
receive() external payable {}

//fallback function when msg.data is not empty
fallback() external payable {}

}
