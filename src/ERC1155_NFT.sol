// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {ERC1155} from "openzeppelin/token/ERC1155/ERC1155.sol";

 contract ERC1155_NFT is ERC1155 {

    constructor(string memory uri) ERC1155(uri) {}

    function mint(address receiver, uint256 id) public {
        _mint(receiver, id, 1, "");
    }
}
