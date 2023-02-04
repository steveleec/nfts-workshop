// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import {Address, IERC721Receiver} from "./Utils.sol";

contract NftDesdeCero {
    using Address for address;

    /**
    1 - name
    2 - symbol
    3 - safeMint
    4 - balanceOf
    5 - ownerOf

    6 - approve - por token
    7 - getApproved - lectura

    8 - setApprovalForAll - por toda la coleccion
    9 - isApprovedForAll - lectura

    10 - transferFrom
    11 - safeTransferFrom
    12 - safeTransferFrom

    13 - tokenUri

    14 - supportsInterface
    */

    function name() public view returns (string memory) {
        return "";
    }

    function symbol() public view returns (string memory) {
        return "";
    }

    function safeMint(address to) public {}

    function balanceOf(address owner) public view returns (uint256) {}

    function ownerOf(uint256 tokenId) public view returns (address) {}

    function approve(address to, uint256 tokenId) public {}

    function getApproved(uint256 tokenId) public view returns (address) {}

    function setApprovalForAll(address operator, bool approved) public {}

    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {}

    function transferFrom(address from, address to, uint256 tokenId) public {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, data);
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {}

    function _baseURI() internal pure returns (string memory) {}

    function tokenURI(uint256 tokenId) public view returns (string memory) {}

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}
