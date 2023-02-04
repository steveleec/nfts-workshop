// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import {IERC721, IERC721Metadata, Stirngs, Address, IERC721Receiver} from "./Utils.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract NftDesdeCeroSol is IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    /**
    name
    symbol
    safeMint
    balanceOf
    ownerOf

    approve - por token
    getApproved - lectura

    setApprovalForAll - por toda la coleccion
    isApprovedForAll - lectura

    transferFrom
    safeTransferFrom
    safeTransferFrom

    tokenUri

    supportsInterface
    */

    // 1. Para guardar a los dueños de cada NFT
    // sabremos quien es el duenio de cada token id
    // apuntamos del token id al address
    mapping(uint256 => address) duenios;

    // 2. queremos saber cuantos tokens tiene cada duenio
    mapping(address => uint256) balances;

    // 7. dar permiso para un token
    mapping(uint256 => address) permisosUnToken;

    // 8. un duenio le da permiso a otra cuenta par manejar todos sus tokens
    // duenio token => maneja => true/false
    mapping(address => mapping(address => bool)) permisosTodosTokens;

    // 3. empieza en cero y seguira incrementando
    uint256 counter;

    function name() public view returns (string memory) {
        return "";
    }

    function symbol() public view returns (string memory) {
        return "";
    }

    // 4. podemos crear la function mint
    function safeMint(address to) public {
        duenios[counter] = to;
        balances[to] += 1;

        counter += 1;
    }

    // 5. averiguar cuantos nfts tiene una cuenta
    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    // 6. averiguar quien es el duenio de un token
    function ownerOf(uint256 tokenId) public view returns (address) {
        return duenios[tokenId];
    }

    // 9. dar permiso para un token a una address
    function approve(address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "No es el duenio del token");
        permisosUnToken[tokenId] = to;
    }

    // 10. devuelve quien tiene el permiso para manejar un token ID
    function getApproved(uint256 tokenId) public view returns (address) {
        return permisosUnToken[tokenId];
    }

    // 11.
    function setApprovalForAll(address operator, bool approved) public {
        permisosTodosTokens[msg.sender][operator] = approved;
    }

    // 12.
    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return permisosTodosTokens[owner][operator];
    }

    // 13
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == from, "No es el duenio");

        duenios[tokenId] = to;

        balances[from] -= 1;
        balances[to] += 1;
    }

    // 15
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    // 14
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public {
        transferFrom(from, to, tokenId);
        _checkOnERC721Received(from, to, tokenId, data);
    }

    // 16
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return interfaceId == type(IERC721).interfaceId;
    }

    function _baseURI() internal pure returns (string memory) {
        return "ipfs://QmVZkuCVeMStEYnYj1vFYDEdggwoQ2evHFn7wmj97RMUmf/";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(
            ownerOf(tokenId) != address(0),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();

        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

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
