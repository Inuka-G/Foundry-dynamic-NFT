// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    string private s_happyNftImage_uri;
    string private s_sadNftImage_uri;
    uint256 private s_tokenCounter;
    error MoodNFT__NOT_APPRoVED_OR_OWNER();
    enum Mood {
        HAPPY,
        SAD
    }
    mapping(uint256 => Mood) private s_tokenIdtoMood;

    constructor(
        string memory happyNftImage_uri,
        string memory sadNftImage_uri
    ) ERC721("Mood Nft", "MN") {
        s_tokenCounter = 0;
        s_happyNftImage_uri = happyNftImage_uri;
        s_sadNftImage_uri = sadNftImage_uri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdtoMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint tokenId) public {
        //only owner can flip mood
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNFT__NOT_APPRoVED_OR_OWNER();
        }
        if (s_tokenIdtoMood[tokenId] == Mood.HAPPY) {
            s_tokenIdtoMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdtoMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:appilication/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageUrl;
        if (s_tokenIdtoMood[tokenId] == Mood.HAPPY) {
            imageUrl = s_happyNftImage_uri;
        } else {
            imageUrl = s_sadNftImage_uri;
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "description":"An NFT reflect mood of token owner","attributes":[{"trait_type":"moodiness","value":100}], "image":"',
                                imageUrl,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
