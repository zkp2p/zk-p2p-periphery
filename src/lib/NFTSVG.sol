// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "base64/base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a ZKP2P NFT
/// Modified from Uniswap V3 NFTs https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/NFTSVG.sol
library NFTSVG {
    using Strings for uint256;

    struct SVGParams {
        address owner;
        bytes32 idHash;
        uint256 tokenId;
        string platform;
        string logo;
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
        string memory idHashStr = bytes32ToString(params.idHash);
        string memory ownerStr = addressToString(params.owner);

        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGBorderText(idHashStr, ownerStr),
                    generateSVGLogo(),
                    params.logo,
                    generateSVGPositionData(
                        params.tokenId.toString(),
                        params.platform
                    ),
                    '</svg>'
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="290" height="420" viewBox="0 0 290 420" xmlns="http://www.w3.org/2000/svg"',
                " xmlns:xlink='http://www.w3.org/1999/xlink'>",
                '<defs>',
                '<filter id="f1"><feImage result="p0" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='420' viewBox='0 0 290 420' xmlns='http://www.w3.org/2000/svg'><rect width='290px' height='420px' fill='#",
                            params.color0,
                            "'/></svg>"
                        )
                    )
                ),
                '"/><feImage result="p1" xlink:href="data:image/svg+xml;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "<svg width='290' height='420' viewBox='0 0 290 420' xmlns='http://www.w3.org/2000/svg'><circle cx='",
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
                            "<svg width='290' height='420' viewBox='0 0 290 420' xmlns='http://www.w3.org/2000/svg'><circle cx='",
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
                            "<svg width='290' height='420' viewBox='0 0 290 420' xmlns='http://www.w3.org/2000/svg'><circle cx='",
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
                'in="blendOut" stdDeviation="42" /></filter> <clipPath id="corners"><rect width="290" height="420" rx="42" ry="42" /></clipPath>',
                '<path id="text-path-a" d="M40 12 H250 A28 28 0 0 1 278 40 V380 A28 28 0 0 1 250 408 H40 A28 28 0 0 1 12 380 V40 A28 28 0 0 1 40 12 z" />',
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
                '" x="0px" y="0px" width="290px" height="420px" />',
                '<rect style="filter: url(#f1)" x="0px" y="0px" width="290px" height="420px" />',
                ' <g style="filter:url(#top-region-blur); transform:scale(1.5); transform-origin:center top;">',
                '<rect fill="none" x="0px" y="0px" width="290px" height="420px" />',
                '<ellipse cx="50%" cy="0px" rx="180px" ry="120px" fill="#000" opacity="0.85" /></g>',
                '<rect x="0" y="0" width="290" height="420" rx="42" ry="42" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" /></g>'
            )
        );
    }

    function generateSVGBorderText(string memory idHash, string memory owner) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Hash',
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Hash',
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>',
                '<textPath startOffset="50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Owner',
                unicode' • ',
                owner,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"',
                ' repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">Owner',
                unicode' • ',
                owner,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGLogo() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g style="transform:translate(105px, 70px)">',
                '<svg width="85" height="85" viewBox="0 0 192 192" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<path d="M113.746 118.396C114.067 118.396 123.521 117.616 127.376 116.928C151.471 111.145 169.416 89.3912 169.416 63.3691C169.462 32.9412 144.908 8.29589 114.664 8.29589C114.342 8.29589 114.067 8.29589 113.746 8.29589H114.664H116.729C115.49 8.29589 114.297 8.25 113.011 8.25H52.6604C36.2303 8.25 22.875 21.6053 22.875 38.0354V158.233C22.875 172.322 34.3027 183.75 48.3923 183.75C64.3635 183.75 77.3516 170.808 77.3516 154.791V123.169C77.3516 120.645 79.4168 118.58 81.941 118.58H107.045C109.753 118.58 113.746 118.351 113.746 118.351V118.396Z" fill="url(#paint0_linear_254_2679)"/>',
                '<path d="M22.5 37.7579L23.0038 146.625C32.3013 115.376 53.736 107.541 86.3919 115.605C93.262 117.575 98.6206 118.217 103.292 118.4H106.498C109.201 118.4 113.185 118.171 113.185 118.171C113.506 118.171 122.941 117.392 126.788 116.705C130.544 115.788 134.162 114.46 137.551 112.81C144.788 108.961 150.696 103.784 154.406 100.301C159.856 94.2991 164.024 87.0597 166.406 79.0871C167.688 73.8636 168.375 68.1362 168.375 61.9506C168.375 59.7512 168.283 57.5977 168.146 55.49C164.711 31.0224 145.337 11.7782 120.88 8.75413C120.055 8.66249 119.231 8.57086 118.361 8.52504C117.674 8.47922 116.987 8.4334 116.3 8.4334C114.513 8.34176 112.681 8.25012 110.804 8.25012H52.2246C35.8738 8.2043 22.5916 21.4203 22.5 37.7579Z" fill="url(#paint1_linear_254_2679)"/>',
                '<path d="M106.667 99.3628C120.804 103.455 131.543 105.007 139.839 105.007C144.864 105.007 148.988 104.436 152.423 103.513C162.938 93.4572 169.5 79.2613 169.5 63.5237C169.505 33.0301 144.901 8.30868 114.557 8.30868C114.253 8.30868 113.949 8.31402 113.645 8.31935V8.30868H116.654C115.432 8.27134 114.189 8.25 112.93 8.25H52.3748C35.8743 8.25 22.5 21.6243 22.5 38.1248V99.1014C42.5375 76.3805 73.6873 87.5356 106.667 99.3628Z" fill="url(#paint2_linear_254_2679)"/>',
                '<path d="M106.485 50.2529C120.582 54.3251 131.281 55.8808 139.592 55.8808C154.974 55.8808 161.908 50.5732 166.5 46.2265C159.337 24.2184 138.673 8.29575 114.337 8.29575C114.015 8.29575 113.74 8.29575 113.418 8.29575H114.337H116.403C115.163 8.29575 113.969 8.25 112.684 8.25H52.301C35.8622 8.25 22.5 21.5647 22.5 37.9449V50.0242C42.4745 27.4213 73.5612 38.5397 106.485 50.2987V50.2529Z" fill="url(#paint3_linear_254_2679)"/>',
                '<path d="M107.621 21.4334C121.427 25.4654 131.905 27.0057 140.045 27.0057C145.802 27.0057 150.254 26.1903 153.942 25.0124C145.622 16.2688 134.514 10.2887 121.967 8.74834C121.157 8.65773 120.348 8.56713 119.493 8.52182C118.819 8.47652 118.144 8.43121 117.469 8.43121C115.716 8.34061 113.917 8.25 112.073 8.25H54.5535C53.744 8.25 52.9345 8.2953 52.125 8.38591C68.5398 7.38923 87.7429 14.2754 107.621 21.4787V21.4334Z" fill="url(#paint4_linear_254_2679)"/>',
                '<defs>',
                '<linearGradient id="paint0_linear_254_2679" x1="22.875" y1="84.8508" x2="169.416" y2="84.8508" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#4057CB"/>',
                '<stop offset="0.19697" stop-color="#3C3A9F"/>',
                '<stop offset="0.545455" stop-color="#441571"/>',
                '<stop offset="1" stop-color="#281C3A"/>',
                '</linearGradient>',
                '<linearGradient id="paint1_linear_254_2679" x1="28.0256" y1="64.634" x2="173.901" y2="64.634" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#781C7A"/>',
                '<stop offset="1" stop-color="#551671"/>',
                '</linearGradient>',
                '<linearGradient id="paint2_linear_254_2679" x1="22.5" y1="69.0665" x2="169.74" y2="69.0665" gradientUnits="userSpaceOnUse">',
                '<stop offset="0.15942" stop-color="#FE8A67"/>',
                '<stop offset="1" stop-color="#D82550"/>',
                '</linearGradient>',
                '<linearGradient id="paint3_linear_254_2679" x1="29.0455" y1="28.3533" x2="157.773" y2="28.3533" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#FCD45F"/>',
                '<stop offset="1" stop-color="#FF8D66"/>',
                '</linearGradient>',
                '<linearGradient id="paint4_linear_254_2679" x1="103.033" y1="8.25" x2="182.075" y2="8.25" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#64BA4C"/>',
                '<stop offset="1" stop-color="#186A44"/>',
                '</linearGradient>',
                '</defs>',
                '</svg>',
                '</g>'
            )
        );
    }

    function generateSVGPositionData(
        string memory tokenId,
        string memory platform
    ) private pure returns (string memory svg) {
        uint256 str1length = bytes(tokenId).length + 4;
        uint256 str2length = bytes(platform).length + 10;
        svg = string(
            abi.encodePacked(
                ' <g style="transform:translate(29px, 334px)">',
                '<rect width="',
                uint256(7 * (str1length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">ID: </tspan>',
                tokenId,
                '</text></g>',
                ' <g style="transform:translate(29px, 364px)">',
                '<rect width="',
                uint256(7 * (str2length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Platform: </tspan>',
                platform,
                '</text></g>'
            )
        );
    }

    function bytes32ToString(bytes32 hashedId) internal pure returns (string memory) {
        return (uint256(hashedId)).toHexString(32);
    }

    function addressToString(address addr) internal pure returns (string memory) {
        return (uint256(uint160(addr))).toHexString(20);
    }
}