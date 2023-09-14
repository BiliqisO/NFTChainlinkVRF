// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
contract NFTChainlink is ERC721URIStorage,VRFConsumerBaseV2 {
VRFCoordinatorV2Interface immutable vrfCoordinatorV2;
bytes32 immutable keyHash;
bytes64 immutable subcriptionId;
uint32 immutable callBackGasLimit;
uint16 constant REQUESTCONFIRMATION = 2;
uint16 constant NUM_WORDS = 1;
uint constant MaxChanceValue = 6;


mapping (uint =>address)requestIdToSender;
uint256 tokenCounter;

   constructor(address _vrfCoordinatorV2, bytes32 _keyHash, uint64 _subcriptionId,uint32 _callBackGasLimit ) ERC721("NFTbillion" "NFTB"){
    vrfCoordinatorV2 = VRFCoordinatorV2Interface(_vrfCoordinatorV2);
    keyHash = _keyHash;
    subcriptionId = _subcriptionId;
    callBackGasLimit =_callBackGasLimit;
    
   }

   function mintNFT() public returns (uint requestId){
       requestId = vrfCoordinatorV2.requestRandomWords(
        //price per gas
        keyHash,
        subcriptionId,
        REQUESTCONFIRMATION,
        //max gas amount
        callBackGasLimit,
        NUM_WORDS

       );
       requestIdToSender[requestId] = msg.sender; 
   }
   function fulfillRandomWords(uint256 requestId, uint[] memory randomWords) internal override{
   address cakeOwner =  requestIdToSender[requestId];
   uint newTokenId = tokenCounter;
   tokenCounter = tokenCounter +1; 

   uint cakes = randomWords[0] % MaxChanceValue;

   _safeMint(cakeOwner, newTokenId);

   }
   function getChanceArray() public pure returns(uint[3] memory){
    return (10, 30, MaxChanceValue);
   } 
   function getCakeFlavours(uint _cakes) {
    uint cumulativeSum = 0;
    
   }

}