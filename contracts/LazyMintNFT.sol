// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract LazyNft is ERC721URIStorage, EIP712, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(
        address minter
    ) ERC721("LazyNFT", "LZY") EIP712("LazyMintedNFT", "1") {
        _setupRole(MINTER_ROLE, minter);
    }

    /**
     * Mints a new token
     * @param account The account the token will be redeemed for
     * @param tokenId The token id of the redeemed token
     * @param uri The content uri of the token being redeemed
     */
    function mint(address account, uint256 tokenId, string memory uri) public {
        require(hasRole(MINTER_ROLE, msg.sender), "LazyNft: Unauthorized");

        // minting logic
        _mint(account, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * Redeems a token that has been lazy minted. Compares the signature of the lazy mint to the hash of the parameters to
     * create the token
     * @param tokenId The token id of the redeemed token
     * @param account The account the token will be redeemed for
     * @param uri The content uri of the token being redeemed
     * @param signature The signature to compare the hash of the parameters to
     */
    function redeem(
        uint256 tokenId,
        address account,
        string memory uri,
        bytes calldata signature
    ) external {
        require(
            _verify(_hash(tokenId, account, uri), signature),
            "LazyNFT: Unauthorized Signature"
        );

        _mint(account, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * Make sure the ECDSA recover equals the minter role
     * @param digest The hash of the lazy token parameters
     * @param signature The signature to compare digest to
     */
    function _verify(
        bytes32 digest,
        bytes memory signature
    ) internal view returns (bool) {
        return hasRole(MINTER_ROLE, ECDSA.recover(digest, signature));
    }

    /**
     * The hash of the token parameters
     * @param tokenId The token id of the redeemed token
     * @param account The account the token will be redeemed for
     * @param uri The content uri of the token being redeemed
     */
    function _hash(
        uint256 tokenId,
        address account,
        string memory uri
    ) internal view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        keccak256(
                            "LazyMintedNFT(uint256 tokenId,string uri,address account)"
                        ),
                        tokenId,
                        keccak256(bytes(uri)),
                        account
                    )
                )
            );
    }

    /**
     * This function is here because it needs to override the functions in the base classes
     * @param interfaceId N/A
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
