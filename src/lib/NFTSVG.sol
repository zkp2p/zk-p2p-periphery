// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "base64/base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Proof of Venmo NFT
library NFTSVG {
    using Strings for uint256;

    string constant curve1 = 'M1 1C41 41 105 105 145 145';
    string constant curve2 = 'M1 1C33 49 97 113 145 145';
    string constant curve3 = 'M1 1C33 57 89 113 145 145';
    string constant curve4 = 'M1 1C25 65 81 121 145 145';
    string constant curve5 = 'M1 1C17 73 73 129 145 145';
    string constant curve6 = 'M1 1C9 81 65 137 145 145';
    string constant curve7 = 'M1 1C1 89 57.5 145 145 145';
    string constant curve8 = 'M1 1C1 97 49 145 145 145';

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
                    // generageSVGCurve(params.venmoIdHash),
                    generateSVGPositionData(
                        params.tokenId.toString(),
                        venmoIdHashStr
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
                // '<g mask="url(#fade-symbol)"><rect fill="none" x="0px" y="0px" width="290px" height="200px" /> <text y="70px" x="32px" fill="white" font-family="\'Courier New\', monospace" font-weight="200" font-size="36px">',
                // quoteTokenSymbol,
                // '/',
                // baseTokenSymbol,
                // '</text><text y="115px" x="32px" fill="white" font-family="\'Courier New\', monospace" font-weight="200" font-size="36px">',
                // feeTier,
                // '</text></g>',
                '<g inkscape:label="Layer 1" inkscape:groupmode="layer" id="layer1" transform="translate(-5.7593441,-130.66032)"><g style="fill:none" id="g838" transform="matrix(0.9244437,0,0,0.89314785,5.7593441,129.92613)"><path id="path815" d="m 34.5771,0.822021 c 1.4203,2.345309 2.0606,4.760989 2.0606,7.812489 0,9.73269 -8.31,22.37619 -15.0545,31.25429 H 6.17825 L 0,2.95296 13.4887,1.67258 16.7552,27.9548 c 3.0522,-4.9714 6.8186,-12.7838 6.8186,-18.11027 0,-2.91551 -0.4995,-4.90135 -1.2803,-6.53647 z" inkscape:connector-curvature="0" style="fill:#008cff" /><path id="path817" d="m 52.0595,17.0887 c 2.4822,0 8.7312,-1.1353 8.7312,-4.6863 0,-1.7051 -1.2059,-2.55564 -2.627,-2.55564 -2.4861,0 -5.7487,2.98074 -6.1042,7.24194 z m -0.2844,7.0327 c 0,4.3359 2.4114,6.037 5.6083,6.037 3.4813,0 6.8145,-0.8506 11.1469,-3.0519 l -1.6318,11.0787 c -3.0525,1.4911 -7.8097,2.4861 -12.4272,2.4861 -11.7129,0 -15.9049,-7.102 -15.9049,-15.9805 0,-11.5074 6.8189,-23.7262 20.8772,-23.7262 7.7401,0 12.0681,4.33553 12.0681,10.3725 7e-4,9.7324 -12.4929,12.7139 -19.7366,12.7843 z" inkscape:connector-curvature="0" style="fill:#008cff" /><path id="path819" d="m 110.439,9.34835 c 0,1.42035 -0.215,3.48055 -0.43,4.82695 l -4.047,25.5721 H 92.8275 l 3.6921,-23.4415 c 0.07,-0.6358 0.2852,-1.9158 0.2852,-2.626 0,-1.7052 -1.0655,-2.1306 -2.3465,-2.1306 -1.7015,0 -3.407,0.7805 -4.5428,1.3504 l -4.1877,26.848 H 72.5195 L 78.5537,1.46185 h 11.4318 l 0.1447,3.05588 c 2.697,-1.77549 6.2483,-3.695708 11.2868,-3.695708 6.676,-7.3e-4 9.022,3.409878 9.022,8.526328 z" inkscape:connector-curvature="0" style="fill:#008cff" /><path id="path821" d="m 149.432,5.15577 c 3.762,-2.69641 7.314,-4.19117 12.211,-4.19117 6.744,0 9.09,3.41061 9.09,8.52707 0,1.42043 -0.215,3.48063 -0.429,4.82703 l -4.043,25.572 h -13.138 l 3.763,-23.9369 c 0.069,-0.6399 0.215,-1.4204 0.215,-1.9155 0,-1.9199 -1.066,-2.3457 -2.347,-2.3457 -1.631,0 -3.262,0.7102 -4.473,1.3504 l -4.187,26.8481 H 132.96 l 3.762,-23.937 c 0.069,-0.6398 0.211,-1.4203 0.211,-1.9154 0,-1.9199 -1.067,-2.3457 -2.343,-2.3457 -1.705,0 -3.407,0.7805 -4.543,1.3504 l -4.191,26.8481 h -13.204 l 6.034,-38.28598 h 11.292 l 0.355,3.19624 c 2.627,-1.91548 6.175,-3.835703 10.932,-3.835703 4.119,-0.001458 6.815,1.774393 8.167,4.189713 z" inkscape:connector-curvature="0" style="fill:#008cff" /><path id="path823" d="m 196.869,16.3076 c 0,-3.1255 -0.782,-5.2564 -3.123,-5.2564 -5.183,0 -6.248,9.1621 -6.248,13.8491 0,3.5557 0.995,5.7563 3.336,5.7563 4.899,0 6.035,-9.6624 6.035,-14.349 z m -22.719,8.0269 c 0,-12.0737 6.389,-23.371121 21.088,-23.371121 11.076,0 15.125,6.536471 15.125,15.558621 0,11.9336 -6.32,24.292 -21.374,24.292 -11.147,0 -14.839,-7.317 -14.839,-16.4795 z" inkscape:connector-curvature="0"style="fill:#008cff" /></g></g>',
                '<rect x="16" y="16" width="258" height="468" rx="26" ry="26" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" />'
            )
        );
    }

    // function generageSVGCurve(
    //     bytes32 venmoIdHash
    // ) private pure returns (string memory svg) {
    //     string memory curve = getCurve(tickLower, tickUpper, tickSpacing);
    //     svg = string(
    //         abi.encodePacked(
    //             '<g mask="url(',
    //             fade,
    //             ')"',
    //             ' style="transform:translate(72px,189px)">'
    //             '<rect x="-16px" y="-16px" width="180px" height="180px" fill="none" />'
    //             '<path d="',
    //             curve,
    //             '" stroke="rgba(0,0,0,0.3)" stroke-width="32px" fill="none" stroke-linecap="round" />',
    //             '</g><g mask="url(',
    //             fade,
    //             ')"',
    //             ' style="transform:translate(72px,189px)">',
    //             '<rect x="-16px" y="-16px" width="180px" height="180px" fill="none" />',
    //             '<path d="',
    //             curve,
    //             '" stroke="rgba(255,255,255,1)" fill="none" stroke-linecap="round" /></g>',
    //             generateSVGCurveCircle(overRange)
    //         )
    //     );
    // }

    // function getCurve(
    //     int24 tickLower,
    //     int24 tickUpper,
    //     int24 tickSpacing
    // ) internal pure returns (string memory curve) {
    //     int24 tickRange = (tickUpper - tickLower) / tickSpacing;
    //     if (tickRange <= 4) {
    //         curve = curve1;
    //     } else if (tickRange <= 8) {
    //         curve = curve2;
    //     } else if (tickRange <= 16) {
    //         curve = curve3;
    //     } else if (tickRange <= 32) {
    //         curve = curve4;
    //     } else if (tickRange <= 64) {
    //         curve = curve5;
    //     } else if (tickRange <= 128) {
    //         curve = curve6;
    //     } else if (tickRange <= 256) {
    //         curve = curve7;
    //     } else {
    //         curve = curve8;
    //     }
    // }

    // function generateSVGCurveCircle(int8 overRange) internal pure returns (string memory svg) {
    //     string memory curvex1 = '73';
    //     string memory curvey1 = '190';
    //     string memory curvex2 = '217';
    //     string memory curvey2 = '334';
    //     if (overRange == 1 || overRange == -1) {
    //         svg = string(
    //             abi.encodePacked(
    //                 '<circle cx="',
    //                 overRange == -1 ? curvex1 : curvex2,
    //                 'px" cy="',
    //                 overRange == -1 ? curvey1 : curvey2,
    //                 'px" r="4px" fill="white" /><circle cx="',
    //                 overRange == -1 ? curvex1 : curvex2,
    //                 'px" cy="',
    //                 overRange == -1 ? curvey1 : curvey2,
    //                 'px" r="24px" fill="none" stroke="white" />'
    //             )
    //         );
    //     } else {
    //         svg = string(
    //             abi.encodePacked(
    //                 '<circle cx="',
    //                 curvex1,
    //                 'px" cy="',
    //                 curvey1,
    //                 'px" r="4px" fill="white" />',
    //                 '<circle cx="',
    //                 curvex2,
    //                 'px" cy="',
    //                 curvey2,
    //                 'px" r="4px" fill="white" />'
    //             )
    //         );
    //     }
    // }

    function generateSVGPositionData(
        string memory tokenId,
        string memory venmoIdHashStr
    ) private pure returns (string memory svg) {
        uint256 str1length = bytes(tokenId).length + 4;
        uint256 str2length = bytes(venmoIdHashStr).length + 10;
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
                '<text x="12px" y="17px" font-family="\'Courier New\', monospace" font-size="12px" fill="white"><tspan fill="rgba(255,255,255,0.6)">Venmo ID Hash: </tspan>',
                venmoIdHashStr,
                '</text></g>'
            )
        );
    }

    function bytes32ToString(bytes32 hashedId) internal pure returns (string memory) {
        return (uint256(hashedId)).toHexString(32);
    }
}