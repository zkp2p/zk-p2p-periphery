// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;
pragma abicoder v2;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "base64/base64.sol";
import "./HexStrings.sol";
import "./NFTSVGV2.sol";

/// @title NFTDescriptorV2
/// @notice Provides a function for generating an SVG and other metadata associated with a ZKP2P NFT
/// Modified from Uniswap V3 NFTs https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTDescriptorV2.sol
/// CHANGELOG:
/// - Add support for multiple platforms
library NFTDescriptorV2 {
    using Strings for uint256;
    using HexStrings for uint256;

    struct ConstructTokenURIParams {
        uint256 tokenId;
        bytes32 idHash;
        address owner;
        string platform;
        string color0;
        string color1;
        string color2;
        string color3;
    }

    function constructTokenURI(ConstructTokenURIParams memory params) public pure returns (string memory) {
        string memory description = generateDescription(NFTSVGV2.bytes32ToString(params.idHash), params.platform);
        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "Proof of ",
                                params.platform,
                                '", "description":"',
                                description,
                                '", "image": "',
                                'data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function generateDescription(string memory idHash, string memory platform) private pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "This soulbound NFT represents proof that you are a unique ",
                    platform,
                    " user. ",
                    "Mint this by generating a zero knowledge proof of a payment confirmation email. "
                    "Your identifier is hashed, so no one knows who you are -- only that you are an user!",
                    "\\n\\n",
                    "Hashed ID: ",
                    idHash,
                    "\\n\\n"
                )
            );
    }

    function generateSVGImage(ConstructTokenURIParams memory params) internal pure returns (string memory svg) {
        NFTSVGV2.SVGParams memory svgParams =
            NFTSVGV2.SVGParams({
                idHash: params.idHash,
                tokenId: params.tokenId,
                owner: params.owner,
                platform: params.platform,
                color0: params.color0,
                color1: params.color1,
                color2: params.color2,
                color3: params.color3,
                x1: scale(getCircleCoord(uint256(params.idHash), 16, params.tokenId), 0, 255, 16, 274),
                y1: scale(getCircleCoord(uint256(uint160(params.owner)), 16, params.tokenId), 0, 255, 100, 484),
                x2: scale(getCircleCoord(uint256(params.idHash), 32, params.tokenId), 0, 255, 16, 274),
                y2: scale(getCircleCoord(uint256(uint160(params.owner)), 32, params.tokenId), 0, 255, 100, 484),
                x3: scale(getCircleCoord(uint256(params.idHash), 48, params.tokenId), 0, 255, 16, 274),
                y3: scale(getCircleCoord(uint256(uint160(params.owner)), 48, params.tokenId), 0, 255, 100, 484)
            });

        return NFTSVGV2.generateSVG(svgParams);
    }

    function scale(
        uint256 n,
        uint256 inMn,
        uint256 inMx,
        uint256 outMn,
        uint256 outMx
    ) private pure returns (string memory) {
        return ((n - inMn) * (outMx - outMn) / (inMx - inMn) + outMn).toString();
    }

    function getCircleCoord(
        uint256 params,
        uint256 offset,
        uint256 tokenId
    ) internal pure returns (uint256) {
        return (sliceHex(params, offset) * tokenId) % 255;
    }

    function sliceHex(uint256 param, uint256 offset) internal pure returns (uint256) {
        return uint256(uint8(param >> offset));
    }
}