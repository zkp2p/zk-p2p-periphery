// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "base64/base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Proof of Venmo NFT
library NFTSVG {
    using Strings for uint256;

    struct SVGParams {
        bytes32 venmoIdHash;
        uint256 tokenId;
        string color0;
        string color1;
        string color2;
        string color3;
        string x1;
        string y1;
        string x2;
        string y2;
        string x3;
        string y3;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory svg) {
        string memory venmoIdHashStr = bytes32ToString(params.venmoIdHash);
        
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGBorderText(venmoIdHashStr),
                    generateSVGCardMantle(),
                    generateSVGPositionData(
                        params.tokenId.toString()
                    ),
                    '</svg>'
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="290" height="500" viewBox="0 0 290 500" xmlns="http://www.w3.org/2000/svg"',
                " xmlns:xlink='http://www.w3.org/1999/xlink'>",
                '<defs>',
                '<filter id="f1"><feImage result="p0" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><rect width='290px' height='500px' fill='#",
                            params.color0,
                            "'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p1" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x1,
                            "' cy='",
                            params.y1,
                            "' r='120px' fill='#",
                            params.color1,
                            "'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p2" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x2,
                            "' cy='",
                            params.y2,
                            "' r='120px' fill='#",
                            params.color2,
                            "'/></svg>"
                        )
                    )
                ),
                '" />',
                '<feImage result="p3" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='500' viewBox='0 0 290 500' xmlns='http://www.w3.org/2000/svg'><circle cx='",
                            params.x3,
                            "' cy='",
                            params.y3,
                            "' r='100px' fill='#",
                            params.color3,
                            "'/></svg>"
                        )
                    )
                ),
                '" /><feBlend mode="overlay" in="p0" in2="p1" /><feBlend mode="exclusion" in2="p2" /><feBlend mode="overlay" in2="p3" result="blendOut" /><feGaussianBlur ',
                'in="blendOut" stdDeviation="42" /></filter> <clipPath id="corners"><rect width="290" height="500" rx="42" ry="42" /></clipPath>',
                '<path id="text-path-a" d="M40 12 H250 A28 28 0 0 1 278 40 V460 A28 28 0 0 1 250 488 H40 A28 28 0 0 1 12 460 V40 A28 28 0 0 1 40 12 z" />',
                '<path id="minimap" d="M234 444C234 457.949 242.21 463 253 463" />',
                '<filter id="top-region-blur"><feGaussianBlur in="SourceGraphic" stdDeviation="24" /></filter>',
                '<linearGradient id="grad-up" x1="1" x2="0" y1="1" y2="0"><stop offset="0.0" stop-color="white" stop-opacity="1" />',
                '<stop offset=".9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<linearGradient id="grad-down" x1="0" x2="1" y1="0" y2="1"><stop offset="0.0" stop-color="white" stop-opacity="1" /><stop offset="0.9" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-up" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-up)" /></mask>',
                '<mask id="fade-down" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-down)" /></mask>',
                '<mask id="none" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="white" /></mask>',
                '<linearGradient id="grad-symbol"><stop offset="0.7" stop-color="white" stop-opacity="1" /><stop offset=".95" stop-color="white" stop-opacity="0" /></linearGradient>',
                '<mask id="fade-symbol" maskContentUnits="userSpaceOnUse"><rect width="290px" height="200px" fill="url(#grad-symbol)" /></mask></defs>',
                '<g clip-path="url(#corners)">',
                '<rect fill="',
                params.color0,
                '" x="0px" y="0px" width="290px" height="500px" />',
                '<rect style="filter: url(#f1)" x="0px" y="0px" width="290px" height="500px" />',
                ' <g style="filter:url(#top-region-blur); transform:scale(1.5); transform-origin:center top;">',
                '<rect fill="none" x="0px" y="0px" width="290px" height="500px" />',
                '<ellipse cx="50%" cy="0px" rx="180px" ry="120px" fill="#000" opacity="0.85" /></g>',
                '<rect x="0" y="0" width="290" height="500" rx="42" ry="42" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" /></g>'
            )
        );
    }

    function generateSVGBorderText(string memory venmoIdHash) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Venmo',
                unicode' • ',
                venmoIdHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Venmo',
                unicode' • ',
                venmoIdHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>',
                '<textPath startOffset="50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Venmo',
                unicode' • ',
                venmoIdHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"',
                ' repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Venmo',
                unicode' • ',
                venmoIdHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGCardMantle() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g style="transform:translate(87px, 130px)"><svg xmlns="http://www.w3.org/2000/svg" width="240" height="120" fill="#3d95ce"><path d="M29.793 21.444c.608 1.004.882 2.037.882 3.343 0 4.165-3.555 9.575-6.44 13.374h-6.6L15 22.356l5.77-.548 1.398 11.247c1.306-2.127 2.917-5.47 2.917-7.75 0-1.248-.214-2.097-.548-2.797zm7.48 6.96c1.062 0 3.735-.486 3.735-2.005 0-.73-.516-1.094-1.124-1.094-1.064 0-2.46 1.276-2.612 3.1zm-.122 3c0 1.855 1.032 2.583 2.4 2.583 1.5 0 2.915-.364 4.77-1.306l-.698 4.74c-1.306.638-3.34 1.064-5.317 1.064-5 0-6.805-3.04-6.805-6.838 0-4.924 2.917-10.153 8.932-10.153 3.3 0 5.163 1.855 5.163 4.44 0 4.165-5.345 5.44-8.444 5.47zm25.1-6.25c0 .608-.092 1.5-.184 2.066l-1.733 10.94h-5.62l1.58-10.03.122-1.124c0-.73-.456-.912-1.004-.912-.728 0-1.458.334-1.944.578l-1.792 11.5h-5.65l2.582-16.383h4.9l.062 1.308c1.154-.76 2.673-1.58 4.83-1.58 2.856 0 3.86 1.46 3.86 3.65zm16.68-1.856c1.6-1.154 3.13-1.793 5.224-1.793 2.885 0 3.9 1.46 3.9 3.65 0 .608-.092 1.5-.184 2.066l-1.73 10.94H80.5l1.6-10.243.092-.82c0-.822-.456-1.004-1.004-1.004-.698 0-1.396.304-1.914.578l-1.8 11.5h-5.62l1.6-10.243.1-.82c0-.822-.456-1.004-1.002-1.004-.73 0-1.458.334-1.944.578l-1.793 11.5h-5.65l2.58-16.383h4.83l.152 1.368c1.124-.82 2.642-1.64 4.677-1.64 1.762-.001 2.916.76 3.494 1.793zm20.296 4.772c0-1.337-.334-2.25-1.336-2.25-2.218 0-2.673 3.92-2.673 5.926 0 1.522.426 2.463 1.427 2.463 2.096 0 2.582-4.135 2.582-6.14zm-9.72 3.435c0-5.167 2.733-10 9.022-10 4.74 0 6.47 2.797 6.47 6.658 0 5.107-2.704 10.395-9.144 10.395-4.77 0-6.35-3.13-6.35-7.052z"/></svg></g>'
            )
        );
    }

    function generateSVGPositionData(
        string memory tokenId
    ) private pure returns (string memory svg) {
        uint256 str1length = bytes(tokenId).length + 4;
        svg = string(
            abi.encodePacked(
                ' <g style="transform:translate(29px, 414px)">',
                '<rect width="',
                uint256(7 * (str1length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">ID: </tspan>',
                tokenId,
                '</text></g>'
            )
        );
    }

    function bytes32ToString(bytes32 hashedId) internal pure returns (string memory) {
        return (uint256(hashedId)).toHexString(32);
    }
}