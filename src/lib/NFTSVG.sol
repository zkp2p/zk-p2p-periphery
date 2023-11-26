// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "base64/base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Proof of Venmo NFT
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
                    generateSVGBorderText(idHashStr, params.platform),
                    generateSVGLogo(),
                    params.logo,
                    generateSVGPositionData(
                        params.tokenId.toString(),
                        ownerStr,
                        params.platform
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

    function generateSVGBorderText(string memory idHash, string memory platform) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                platform,
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                platform,
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>',
                '<textPath startOffset="50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                platform,
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s"',
                ' repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                platform,
                unicode' • ',
                idHash,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGLogo() private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g style="transform:translate(65px, 60px)">',
                '<svg transform="scale(0.5)" width="150" height="150" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<g clip-path="url(#clip0_254_2442)">',
                '<rect x="-44.1792" y="-372.537" width="1791.04" height="774.925" fill="#1D1F22"/>',
                '<path d="M243.463 243.349C243.927 243.349 257.605 242.22 263.182 241.224C298.039 232.858 324 201.387 324 163.741C324.066 119.721 288.545 84.0664 244.79 84.0664C244.326 84.0664 243.927 84.0664 243.463 84.0664H244.79H247.778C245.986 84.0664 244.259 84 242.4 84H155.09C131.321 84 112 103.321 112 127.09V300.98C112 321.363 128.532 337.895 148.916 337.895C172.021 337.895 190.811 319.172 190.811 296V250.254C190.811 246.602 193.799 243.614 197.451 243.614H233.769C237.686 243.614 243.463 243.282 243.463 243.282V243.349Z" fill="url(#paint0_linear_254_2442)"/>',
                '<path d="M111 126.736L111.73 284.408C125.201 239.151 156.258 227.803 203.573 239.482C213.527 242.336 221.291 243.265 228.06 243.53H232.705C236.62 243.53 242.393 243.199 242.393 243.199C242.858 243.199 256.528 242.07 262.102 241.075C267.544 239.748 272.786 237.823 277.697 235.434C288.182 229.86 296.743 222.361 302.118 217.318C310.015 208.625 316.053 198.14 319.504 186.593C321.362 179.028 322.358 170.733 322.358 161.774C322.358 158.589 322.225 155.47 322.026 152.418C317.049 116.981 288.978 89.1099 253.542 84.7301C252.347 84.5974 251.153 84.4647 249.892 84.3983C248.897 84.332 247.901 84.2656 246.906 84.2656C244.318 84.1329 241.663 84.0002 238.943 84.0002H154.068C130.377 83.9338 111.133 103.046 111 126.736Z" fill="url(#paint1_linear_254_2442)"/>',
                '<path d="M231.811 216.658C252.103 222.706 267.518 225 279.425 225C286.638 225 292.557 224.156 297.489 222.792C312.581 207.93 322 186.95 322 163.691C322.008 118.623 286.692 82.0867 243.136 82.0867C242.7 82.0867 242.263 82.0946 241.827 82.1025V82.0867H246.146C244.392 82.0315 242.608 82 240.801 82H153.882C130.197 82 111 101.766 111 126.153V216.272C139.761 182.692 184.473 199.178 231.811 216.658Z" fill="url(#paint2_linear_254_2442)"/>',
                '<path d="M231.823 144.218C252.104 150.251 267.496 152.555 279.453 152.555C301.583 152.555 311.558 144.693 318.164 138.254C307.858 105.654 278.131 82.0678 243.12 82.0678C242.657 82.0678 242.261 82.0678 241.798 82.0678H243.12H246.092C244.309 82.0678 242.591 82 240.742 82H153.873C130.223 82 111 101.723 111 125.987V143.88C139.736 110.398 184.459 126.868 231.823 144.286V144.218Z" fill="url(#paint3_linear_254_2442)"/>',
                '<path d="M232.285 101.072C252.259 106.905 267.418 109.134 279.194 109.134C287.522 109.134 293.963 107.954 299.298 106.25C287.262 93.6007 271.192 84.9493 253.04 82.7209C251.869 82.5899 250.698 82.4588 249.461 82.3932C248.485 82.3277 247.51 82.2622 246.534 82.2622C243.996 82.1311 241.394 82 238.726 82H155.513C154.342 82 153.171 82.0655 152 82.1966C175.747 80.7547 203.528 90.7169 232.285 101.138V101.072Z" fill="url(#paint4_linear_254_2442)"/>',
                '</g>',
                '<defs>',
                '<linearGradient id="paint0_linear_254_2442" x1="112" y1="194.818" x2="324" y2="194.818" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#4057CB"/>',
                '<stop offset="0.19697" stop-color="#3C3A9F"/>',
                '<stop offset="0.545455" stop-color="#441571"/>',
                '<stop offset="1" stop-color="#281C3A"/>',
                '</linearGradient>',
                '<linearGradient id="paint1_linear_254_2442" x1="119.006" y1="165.661" x2="330.364" y2="165.661" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#781C7A"/>',
                '<stop offset="1" stop-color="#551671"/>',
                '</linearGradient>',
                '<linearGradient id="paint2_linear_254_2442" x1="111" y1="171.883" x2="322.345" y2="171.883" gradientUnits="userSpaceOnUse">',
                '<stop offset="0.15942" stop-color="#FE8A67"/>',
                '<stop offset="1" stop-color="#D82550"/>',
                '</linearGradient>',
                '<linearGradient id="paint3_linear_254_2442" x1="120.417" y1="111.779" x2="305.608" y2="111.779" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#FCD45F"/>',
                '<stop offset="1" stop-color="#FF8D66"/>',
                '</linearGradient>',
                '<linearGradient id="paint4_linear_254_2442" x1="225.649" y1="82" x2="339.999" y2="82" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#64BA4C"/>',
                '<stop offset="1" stop-color="#186A44"/>',
                '</linearGradient>',
                '<clipPath id="clip0_254_2442">',
                '<rect width="400" height="400" fill="white"/>',
                '</clipPath>',
                '</defs>',
                '</svg>',
                '</g>'
            )
        );
    }

    function generateSVGPositionData(
        string memory tokenId,
        string memory owner,
        string memory platform
    ) private pure returns (string memory svg) {
        uint256 str1length = bytes(tokenId).length + 4;
        uint256 str2length = bytes(owner).length + 10;
        uint256 str3length = bytes(platform).length + 10;
        svg = string(
            abi.encodePacked(
                ' <g style="transform:translate(29px, 384px)">',
                '<rect width="',
                uint256(7 * (str1length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">ID: </tspan>',
                tokenId,
                '</text></g>',
                ' <g style="transform:translate(29px, 414px)">',
                '<rect width="',
                uint256(7 * (str2length + 4)).toString(),
                'px" height="26px" rx="8px" ry="8px" fill="rgba(0,0,0,0.6)" />',
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Owner: </tspan>',
                owner,
                '</text></g>',
                ' <g style="transform:translate(29px, 444px)">',
                '<rect width="',
                uint256(7 * (str3length + 4)).toString(),
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