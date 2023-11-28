// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test, console2 } from "forge-std/Test.sol";
import { IRamp } from "../src/interfaces/IRamp.sol";
import { MockRamp } from "../src/mocks/MockRamp.sol";
import { ProofOfVenmoNFT } from "../src/ProofOfVenmoNFT.sol";

contract ProofOfVenmoNFTTest is Test {
    ProofOfVenmoNFT public proofOfVenmoNFT;
    MockRamp public ramp;

    function setUp() public {
        ramp = new MockRamp();

        // Register user 0x1
        ramp.setAccountInfo(
            address(1),
            IRamp.AccountInfo({
                venmoIdHash: bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf),
                deposits: new uint256[](0)
            })
        );

        proofOfVenmoNFT = new ProofOfVenmoNFT(ramp);
    }
    
    function test_Mint() public {
        bool prevMinted = proofOfVenmoNFT.minted(bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf));
        assertFalse(prevMinted);

        vm.startPrank(address(1));
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();
        
        uint256 tokenId = proofOfVenmoNFT.currentTokenId();
        assertEq(tokenId, 1);

        address owner = proofOfVenmoNFT.ownerOf(tokenId);
        assertEq(owner, address(1));

        uint256 balance = proofOfVenmoNFT.balanceOf(address(1));
        assertEq(balance, 1);

        bool currMinted = proofOfVenmoNFT.minted(bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf));
        assertTrue(currMinted);

        string memory tokenURI = proofOfVenmoNFT.tokenURI(tokenId);
        string memory expectedTokenURI = "data:application/json;base64,eyJuYW1lIjoiWktQMlAgLSBQcm9vZiBvZiBQMlAiLCAiZGVzY3JpcHRpb24iOiJUaGlzIHNvdWxib3VuZCBORlQgcmVwcmVzZW50cyBwcm9vZiB0aGF0IHlvdSBhcmUgYSB1bmlxdWVWZW5tbyB1c2VyLiBNaW50IHRoaXMgYnkgZ2VuZXJhdGluZyBhIHplcm8ga25vd2xlZGdlIHByb29mIG9mIGEgcGF5bWVudCBjb25maXJtYXRpb24gaW4gWktQMlAuIFlvdXIgaWRlbnRpZmllciBpcyBoYXNoZWQsIHNvIG5vIG9uZSBrbm93cyB3aG8geW91IGFyZSAtLSBvbmx5IHRoYXQgeW91IGFyZSBhbiB1c2VyIVxuSGFzaGVkIElEOiAweDA3NDE3MjhlM2FhZTcyZWRhNDg0ZThjY2JmMDBmODQzYzM4ZWFlOWMzOTliOWJkN2ZiMmI1ZWU3YTA1NWI2YmZcblxuIiwgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjNhV1IwYUQwaU1qa3dJaUJvWldsbmFIUTlJalV3TUNJZ2RtbGxkMEp2ZUQwaU1DQXdJREk1TUNBMU1EQWlJSGh0Ykc1elBTSm9kSFJ3T2k4dmQzZDNMbmN6TG05eVp5OHlNREF3TDNOMlp5SWdlRzFzYm5NNmVHeHBibXM5SjJoMGRIQTZMeTkzZDNjdWR6TXViM0puTHpFNU9Ua3ZlR3hwYm1zblBqeGtaV1p6UGp4bWFXeDBaWElnYVdROUltWXhJajQ4Wm1WSmJXRm5aU0J5WlhOMWJIUTlJbkF3SWlCNGJHbHVhenBvY21WbVBTSmtZWFJoT21sdFlXZGxMM04yWnl0NGJXdzdZbUZ6WlRZMExGQklUakphZVVJellWZFNNR0ZFTUc1TmFtdDNTbmxDYjFwWGJHNWhTRkU1U25wVmQwMURZMmRrYld4c1pEQktkbVZFTUc1TlEwRjNTVVJKTlUxRFFURk5SRUZ1U1Vob2RHSkhOWHBRVTJSdlpFaFNkMDlwT0haa00yUXpURzVqZWt4dE9YbGFlVGg1VFVSQmQwd3pUakphZVdNclVFaEtiRmt6VVdka01teHJaRWRuT1VwNlNUVk5TRUkwU25sQ2IxcFhiRzVoU0ZFNVNucFZkMDFJUWpSS2VVSnRZVmQ0YzFCVFkycE5WRTE0VVZSS1FrcDVPQ3RRUXpsNlpHMWpLeUl2UGp4bVpVbHRZV2RsSUhKbGMzVnNkRDBpY0RFaUlIaHNhVzVyT21oeVpXWTlJbVJoZEdFNmFXMWhaMlV2YzNabkszaHRiRHRpWVhObE5qUXNVRWhPTWxwNVFqTmhWMUl3WVVRd2JrMXFhM2RLZVVKdldsZHNibUZJVVRsS2VsVjNUVU5qWjJSdGJHeGtNRXAyWlVRd2JrMURRWGRKUkVrMVRVTkJNVTFFUVc1SlNHaDBZa2MxZWxCVFpHOWtTRkozVDJrNGRtUXpaRE5NYm1ONlRHMDVlVnA1T0hsTlJFRjNURE5PTWxwNVl5dFFSMDV3WTIxT2MxcFRRbXBsUkRCdVRWUkJlVXA1UW1wbFZEQnVUVlJCZDBwNVFubFFVMk40VFdwQ2QyVkRZMmRhYld4ellrUXdia2t3V2tST2VrcEhVbWxqZGxCcWQzWmpNMXB1VUdjOVBTSXZQanhtWlVsdFlXZGxJSEpsYzNWc2REMGljRElpSUhoc2FXNXJPbWh5WldZOUltUmhkR0U2YVcxaFoyVXZjM1puSzNodGJEdGlZWE5sTmpRc1VFaE9NbHA1UWpOaFYxSXdZVVF3YmsxcWEzZEtlVUp2V2xkc2JtRklVVGxLZWxWM1RVTmpaMlJ0Ykd4a01FcDJaVVF3YmsxRFFYZEpSRWsxVFVOQk1VMUVRVzVKU0doMFlrYzFlbEJUWkc5a1NGSjNUMms0ZG1RelpETk1ibU42VEcwNWVWcDVPSGxOUkVGM1RETk9NbHA1WXl0UVIwNXdZMjFPYzFwVFFtcGxSREJ1VFdwUk5VcDVRbXBsVkRCdVRWUkJkMHA1UW5sUVUyTjRUV3BDZDJWRFkyZGFiV3h6WWtRd2JrbDZRVFJOUlVsNFRWTmpkbEJxZDNaak0xcHVVR2M5UFNJZ0x6NDhabVZKYldGblpTQnlaWE4xYkhROUluQXpJaUI0YkdsdWF6cG9jbVZtUFNKa1lYUmhPbWx0WVdkbEwzTjJaeXQ0Yld3N1ltRnpaVFkwTEZCSVRqSmFlVUl6WVZkU01HRkVNRzVOYW10M1NubENiMXBYYkc1aFNGRTVTbnBWZDAxRFkyZGtiV3hzWkRCS2RtVkVNRzVOUTBGM1NVUkpOVTFEUVRGTlJFRnVTVWhvZEdKSE5YcFFVMlJ2WkVoU2QwOXBPSFprTTJRelRHNWpla3h0T1hsYWVUaDVUVVJCZDB3elRqSmFlV01yVUVkT2NHTnRUbk5hVTBKcVpVUXdiazVVYTI1SlIwNDFVRk5qZUUxRVFXNUpTRWs1U25wRmQwMUlRalJLZVVKdFlWZDRjMUJUWTJwU2ExcEhVbXRhUjBwNU9DdFFRemw2Wkcxakt5SWdMejQ4Wm1WQ2JHVnVaQ0J0YjJSbFBTSnZkbVZ5YkdGNUlpQnBiajBpY0RBaUlHbHVNajBpY0RFaUlDOCtQR1psUW14bGJtUWdiVzlrWlQwaVpYaGpiSFZ6YVc5dUlpQnBiakk5SW5BeUlpQXZQanhtWlVKc1pXNWtJRzF2WkdVOUltOTJaWEpzWVhraUlHbHVNajBpY0RNaUlISmxjM1ZzZEQwaVlteGxibVJQZFhRaUlDOCtQR1psUjJGMWMzTnBZVzVDYkhWeUlHbHVQU0ppYkdWdVpFOTFkQ0lnYzNSa1JHVjJhV0YwYVc5dVBTSTBNaUlnTHo0OEwyWnBiSFJsY2o0Z1BHTnNhWEJRWVhSb0lHbGtQU0pqYjNKdVpYSnpJajQ4Y21WamRDQjNhV1IwYUQwaU1qa3dJaUJvWldsbmFIUTlJalV3TUNJZ2NuZzlJalF5SWlCeWVUMGlORElpSUM4K1BDOWpiR2x3VUdGMGFENDhjR0YwYUNCcFpEMGlkR1Y0ZEMxd1lYUm9MV0VpSUdROUlrMDBNQ0F4TWlCSU1qVXdJRUV5T0NBeU9DQXdJREFnTVNBeU56Z2dOREFnVmpRMk1DQkJNamdnTWpnZ01DQXdJREVnTWpVd0lEUTRPQ0JJTkRBZ1FUSTRJREk0SURBZ01DQXhJREV5SURRMk1DQldOREFnUVRJNElESTRJREFnTUNBeElEUXdJREV5SUhvaUlDOCtQSEJoZEdnZ2FXUTlJbTFwYm1sdFlYQWlJR1E5SWsweU16UWdORFEwUXpJek5DQTBOVGN1T1RRNUlESTBNaTR5TVNBME5qTWdNalV6SURRMk15SWdMejQ4Wm1sc2RHVnlJR2xrUFNKMGIzQXRjbVZuYVc5dUxXSnNkWElpUGp4bVpVZGhkWE56YVdGdVFteDFjaUJwYmowaVUyOTFjbU5sUjNKaGNHaHBZeUlnYzNSa1JHVjJhV0YwYVc5dVBTSXlOQ0lnTHo0OEwyWnBiSFJsY2o0OGJHbHVaV0Z5UjNKaFpHbGxiblFnYVdROUltZHlZV1F0ZFhBaUlIZ3hQU0l4SWlCNE1qMGlNQ0lnZVRFOUlqRWlJSGt5UFNJd0lqNDhjM1J2Y0NCdlptWnpaWFE5SWpBdU1DSWdjM1J2Y0MxamIyeHZjajBpZDJocGRHVWlJSE4wYjNBdGIzQmhZMmwwZVQwaU1TSWdMejQ4YzNSdmNDQnZabVp6WlhROUlpNDVJaUJ6ZEc5d0xXTnZiRzl5UFNKM2FHbDBaU0lnYzNSdmNDMXZjR0ZqYVhSNVBTSXdJaUF2UGp3dmJHbHVaV0Z5UjNKaFpHbGxiblErUEd4cGJtVmhja2R5WVdScFpXNTBJR2xrUFNKbmNtRmtMV1J2ZDI0aUlIZ3hQU0l3SWlCNE1qMGlNU0lnZVRFOUlqQWlJSGt5UFNJeElqNDhjM1J2Y0NCdlptWnpaWFE5SWpBdU1DSWdjM1J2Y0MxamIyeHZjajBpZDJocGRHVWlJSE4wYjNBdGIzQmhZMmwwZVQwaU1TSWdMejQ4YzNSdmNDQnZabVp6WlhROUlqQXVPU0lnYzNSdmNDMWpiMnh2Y2owaWQyaHBkR1VpSUhOMGIzQXRiM0JoWTJsMGVUMGlNQ0lnTHo0OEwyeHBibVZoY2tkeVlXUnBaVzUwUGp4dFlYTnJJR2xrUFNKbVlXUmxMWFZ3SWlCdFlYTnJRMjl1ZEdWdWRGVnVhWFJ6UFNKdlltcGxZM1JDYjNWdVpHbHVaMEp2ZUNJK1BISmxZM1FnZDJsa2RHZzlJakVpSUdobGFXZG9kRDBpTVNJZ1ptbHNiRDBpZFhKc0tDTm5jbUZrTFhWd0tTSWdMejQ4TDIxaGMycytQRzFoYzJzZ2FXUTlJbVpoWkdVdFpHOTNiaUlnYldGemEwTnZiblJsYm5SVmJtbDBjejBpYjJKcVpXTjBRbTkxYm1ScGJtZENiM2dpUGp4eVpXTjBJSGRwWkhSb1BTSXhJaUJvWldsbmFIUTlJakVpSUdacGJHdzlJblZ5YkNnalozSmhaQzFrYjNkdUtTSWdMejQ4TDIxaGMycytQRzFoYzJzZ2FXUTlJbTV2Ym1VaUlHMWhjMnREYjI1MFpXNTBWVzVwZEhNOUltOWlhbVZqZEVKdmRXNWthVzVuUW05NElqNDhjbVZqZENCM2FXUjBhRDBpTVNJZ2FHVnBaMmgwUFNJeElpQm1hV3hzUFNKM2FHbDBaU0lnTHo0OEwyMWhjMnMrUEd4cGJtVmhja2R5WVdScFpXNTBJR2xrUFNKbmNtRmtMWE41YldKdmJDSStQSE4wYjNBZ2IyWm1jMlYwUFNJd0xqY2lJSE4wYjNBdFkyOXNiM0k5SW5kb2FYUmxJaUJ6ZEc5d0xXOXdZV05wZEhrOUlqRWlJQzgrUEhOMGIzQWdiMlptYzJWMFBTSXVPVFVpSUhOMGIzQXRZMjlzYjNJOUluZG9hWFJsSWlCemRHOXdMVzl3WVdOcGRIazlJakFpSUM4K1BDOXNhVzVsWVhKSGNtRmthV1Z1ZEQ0OGJXRnpheUJwWkQwaVptRmtaUzF6ZVcxaWIyd2lJRzFoYzJ0RGIyNTBaVzUwVlc1cGRITTlJblZ6WlhKVGNHRmpaVTl1VlhObElqNDhjbVZqZENCM2FXUjBhRDBpTWprd2NIZ2lJR2hsYVdkb2REMGlNakF3Y0hnaUlHWnBiR3c5SW5WeWJDZ2paM0poWkMxemVXMWliMndwSWlBdlBqd3ZiV0Z6YXo0OEwyUmxabk0rUEdjZ1kyeHBjQzF3WVhSb1BTSjFjbXdvSTJOdmNtNWxjbk1wSWo0OGNtVmpkQ0JtYVd4c1BTSXhNekZCTWtFaUlIZzlJakJ3ZUNJZ2VUMGlNSEI0SWlCM2FXUjBhRDBpTWprd2NIZ2lJR2hsYVdkb2REMGlOVEF3Y0hnaUlDOCtQSEpsWTNRZ2MzUjViR1U5SW1acGJIUmxjam9nZFhKc0tDTm1NU2tpSUhnOUlqQndlQ0lnZVQwaU1IQjRJaUIzYVdSMGFEMGlNamt3Y0hnaUlHaGxhV2RvZEQwaU5UQXdjSGdpSUM4K0lEeG5JSE4wZVd4bFBTSm1hV3gwWlhJNmRYSnNLQ04wYjNBdGNtVm5hVzl1TFdKc2RYSXBPeUIwY21GdWMyWnZjbTA2YzJOaGJHVW9NUzQxS1RzZ2RISmhibk5tYjNKdExXOXlhV2RwYmpwalpXNTBaWElnZEc5d095SStQSEpsWTNRZ1ptbHNiRDBpYm05dVpTSWdlRDBpTUhCNElpQjVQU0l3Y0hnaUlIZHBaSFJvUFNJeU9UQndlQ0lnYUdWcFoyaDBQU0kxTURCd2VDSWdMejQ4Wld4c2FYQnpaU0JqZUQwaU5UQWxJaUJqZVQwaU1IQjRJaUJ5ZUQwaU1UZ3djSGdpSUhKNVBTSXhNakJ3ZUNJZ1ptbHNiRDBpSXpBd01DSWdiM0JoWTJsMGVUMGlNQzQ0TlNJZ0x6NDhMMmMrUEhKbFkzUWdlRDBpTUNJZ2VUMGlNQ0lnZDJsa2RHZzlJakk1TUNJZ2FHVnBaMmgwUFNJMU1EQWlJSEo0UFNJME1pSWdjbms5SWpReUlpQm1hV3hzUFNKeVoySmhLREFzTUN3d0xEQXBJaUJ6ZEhKdmEyVTlJbkpuWW1Fb01qVTFMREkxTlN3eU5UVXNNQzR5S1NJZ0x6NDhMMmMrUEhSbGVIUWdkR1Y0ZEMxeVpXNWtaWEpwYm1jOUltOXdkR2x0YVhwbFUzQmxaV1FpUGp4MFpYaDBVR0YwYUNCemRHRnlkRTltWm5ObGREMGlMVEV3TUNVaUlHWnBiR3c5SW5kb2FYUmxJaUJtYjI1MExXWmhiV2xzZVQwaUowTnZkWEpwWlhJZ1RtVjNKeXdnYlc5dWIzTndZV05sSWlCbWIyNTBMWE5wZW1VOUlqRXdjSGdpSUhoc2FXNXJPbWh5WldZOUlpTjBaWGgwTFhCaGRHZ3RZU0krU0dGemFDRGlnS0lnTUhnd056UXhOekk0WlROaFlXVTNNbVZrWVRRNE5HVTRZMk5pWmpBd1pqZzBNMk16T0dWaFpUbGpNems1WWpsaVpEZG1ZakppTldWbE4yRXdOVFZpTm1KbUlEeGhibWx0WVhSbElHRmtaR2wwYVhabFBTSnpkVzBpSUdGMGRISnBZblYwWlU1aGJXVTlJbk4wWVhKMFQyWm1jMlYwSWlCbWNtOXRQU0l3SlNJZ2RHODlJakV3TUNVaUlHSmxaMmx1UFNJd2N5SWdaSFZ5UFNJek1ITWlJSEpsY0dWaGRFTnZkVzUwUFNKcGJtUmxabWx1YVhSbElpQXZQand2ZEdWNGRGQmhkR2crSUR4MFpYaDBVR0YwYUNCemRHRnlkRTltWm5ObGREMGlNQ1VpSUdacGJHdzlJbmRvYVhSbElpQm1iMjUwTFdaaGJXbHNlVDBpSjBOdmRYSnBaWElnVG1WM0p5d2diVzl1YjNOd1lXTmxJaUJtYjI1MExYTnBlbVU5SWpFd2NIZ2lJSGhzYVc1ck9taHlaV1k5SWlOMFpYaDBMWEJoZEdndFlTSStTR0Z6YUNEaWdLSWdNSGd3TnpReE56STRaVE5oWVdVM01tVmtZVFE0TkdVNFkyTmlaakF3WmpnME0yTXpPR1ZoWlRsak16azVZamxpWkRkbVlqSmlOV1ZsTjJFd05UVmlObUptSUR4aGJtbHRZWFJsSUdGa1pHbDBhWFpsUFNKemRXMGlJR0YwZEhKcFluVjBaVTVoYldVOUluTjBZWEowVDJabWMyVjBJaUJtY205dFBTSXdKU0lnZEc4OUlqRXdNQ1VpSUdKbFoybHVQU0l3Y3lJZ1pIVnlQU0l6TUhNaUlISmxjR1ZoZEVOdmRXNTBQU0pwYm1SbFptbHVhWFJsSWlBdlBpQThMM1JsZUhSUVlYUm9QangwWlhoMFVHRjBhQ0J6ZEdGeWRFOW1abk5sZEQwaU5UQWxJaUJtYVd4c1BTSjNhR2wwWlNJZ1ptOXVkQzFtWVcxcGJIazlJaWREYjNWeWFXVnlJRTVsZHljc0lHMXZibTl6Y0dGalpTSWdabTl1ZEMxemFYcGxQU0l4TUhCNElpQjRiR2x1YXpwb2NtVm1QU0lqZEdWNGRDMXdZWFJvTFdFaVBrOTNibVZ5SU9LQW9pQXdlREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURFZ1BHRnVhVzFoZEdVZ1lXUmthWFJwZG1VOUluTjFiU0lnWVhSMGNtbGlkWFJsVG1GdFpUMGljM1JoY25SUFptWnpaWFFpSUdaeWIyMDlJakFsSWlCMGJ6MGlNVEF3SlNJZ1ltVm5hVzQ5SWpCeklpQmtkWEk5SWpNd2N5SWdjbVZ3WldGMFEyOTFiblE5SW1sdVpHVm1hVzVwZEdVaUlDOCtQQzkwWlhoMFVHRjBhRDQ4ZEdWNGRGQmhkR2dnYzNSaGNuUlBabVp6WlhROUlpMDFNQ1VpSUdacGJHdzlJbmRvYVhSbElpQm1iMjUwTFdaaGJXbHNlVDBpSjBOdmRYSnBaWElnVG1WM0p5d2diVzl1YjNOd1lXTmxJaUJtYjI1MExYTnBlbVU5SWpFd2NIZ2lJSGhzYVc1ck9taHlaV1k5SWlOMFpYaDBMWEJoZEdndFlTSStUM2R1WlhJZzRvQ2lJREI0TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01EQXdNREF3TURBd01TQThZVzVwYldGMFpTQmhaR1JwZEdsMlpUMGljM1Z0SWlCaGRIUnlhV0oxZEdWT1lXMWxQU0p6ZEdGeWRFOW1abk5sZENJZ1puSnZiVDBpTUNVaUlIUnZQU0l4TURBbElpQmlaV2RwYmowaU1ITWlJR1IxY2owaU16QnpJaUJ5WlhCbFlYUkRiM1Z1ZEQwaWFXNWtaV1pwYm1sMFpTSWdMejQ4TDNSbGVIUlFZWFJvUGp3dmRHVjRkRDQ4WnlCemRIbHNaVDBpZEhKaGJuTm1iM0p0T25SeVlXNXpiR0YwWlNneE1EVndlQ3dnTnpCd2VDa2lQanh6ZG1jZ2QybGtkR2c5SWpnMUlpQm9aV2xuYUhROUlqZzFJaUIyYVdWM1FtOTRQU0l3SURBZ01Ua3lJREU1TWlJZ1ptbHNiRDBpYm05dVpTSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNDhjR0YwYUNCa1BTSk5NVEV6TGpjME5pQXhNVGd1TXprMlF6RXhOQzR3TmpjZ01URTRMak01TmlBeE1qTXVOVEl4SURFeE55NDJNVFlnTVRJM0xqTTNOaUF4TVRZdU9USTRRekUxTVM0ME56RWdNVEV4TGpFME5TQXhOamt1TkRFMklEZzVMak01TVRJZ01UWTVMalF4TmlBMk15NHpOamt4UXpFMk9TNDBOaklnTXpJdU9UUXhNaUF4TkRRdU9UQTRJRGd1TWprMU9Ea2dNVEUwTGpZMk5DQTRMakk1TlRnNVF6RXhOQzR6TkRJZ09DNHlPVFU0T1NBeE1UUXVNRFkzSURndU1qazFPRGtnTVRFekxqYzBOaUE0TGpJNU5UZzVTREV4TkM0Mk5qUklNVEUyTGpjeU9VTXhNVFV1TkRrZ09DNHlPVFU0T1NBeE1UUXVNamszSURndU1qVWdNVEV6TGpBeE1TQTRMakkxU0RVeUxqWTJNRFJETXpZdU1qTXdNeUE0TGpJMUlESXlMamczTlNBeU1TNDJNRFV6SURJeUxqZzNOU0F6T0M0d016VTBWakUxT0M0eU16TkRNakl1T0RjMUlERTNNaTR6TWpJZ016UXVNekF5TnlBeE9ETXVOelVnTkRndU16a3lNeUF4T0RNdU56VkROalF1TXpZek5TQXhPRE11TnpVZ056Y3VNelV4TmlBeE56QXVPREE0SURjM0xqTTFNVFlnTVRVMExqYzVNVll4TWpNdU1UWTVRemMzTGpNMU1UWWdNVEl3TGpZME5TQTNPUzQwTVRZNElERXhPQzQxT0NBNE1TNDVOREVnTVRFNExqVTRTREV3Tnk0d05EVkRNVEE1TGpjMU15QXhNVGd1TlRnZ01URXpMamMwTmlBeE1UZ3VNelV4SURFeE15NDNORFlnTVRFNExqTTFNVll4TVRndU16azJXaUlnWm1sc2JEMGlkWEpzS0NOd1lXbHVkREJmYkdsdVpXRnlYekkxTkY4eU5qYzVLU0l2UGp4d1lYUm9JR1E5SWsweU1pNDFJRE0zTGpjMU56bE1Nak11TURBek9DQXhORFl1TmpJMVF6TXlMak13TVRNZ01URTFMak0zTmlBMU15NDNNellnTVRBM0xqVTBNU0E0Tmk0ek9URTVJREV4TlM0Mk1EVkRPVE11TWpZeUlERXhOeTQxTnpVZ09UZ3VOakl3TmlBeE1UZ3VNakUzSURFd015NHlPVElnTVRFNExqUklNVEEyTGpRNU9FTXhNRGt1TWpBeElERXhPQzQwSURFeE15NHhPRFVnTVRFNExqRTNNU0F4TVRNdU1UZzFJREV4T0M0eE56RkRNVEV6TGpVd05pQXhNVGd1TVRjeElERXlNaTQ1TkRFZ01URTNMak01TWlBeE1qWXVOemc0SURFeE5pNDNNRFZETVRNd0xqVTBOQ0F4TVRVdU56ZzRJREV6TkM0eE5qSWdNVEUwTGpRMklERXpOeTQxTlRFZ01URXlMamd4UXpFME5DNDNPRGdnTVRBNExqazJNU0F4TlRBdU5qazJJREV3TXk0M09EUWdNVFUwTGpRd05pQXhNREF1TXpBeFF6RTFPUzQ0TlRZZ09UUXVNams1TVNBeE5qUXVNREkwSURnM0xqQTFPVGNnTVRZMkxqUXdOaUEzT1M0d09EY3hRekUyTnk0Mk9EZ2dOek11T0RZek5pQXhOamd1TXpjMUlEWTRMakV6TmpJZ01UWTRMak0zTlNBMk1TNDVOVEEyUXpFMk9DNHpOelVnTlRrdU56VXhNaUF4TmpndU1qZ3pJRFUzTGpVNU56Y2dNVFk0TGpFME5pQTFOUzQwT1VNeE5qUXVOekV4SURNeExqQXlNalFnTVRRMUxqTXpOeUF4TVM0M056Z3lJREV5TUM0NE9DQTRMamMxTkRFelF6RXlNQzR3TlRVZ09DNDJOakkwT1NBeE1Ua3VNak14SURndU5UY3dPRFlnTVRFNExqTTJNU0E0TGpVeU5UQTBRekV4Tnk0Mk56UWdPQzQwTnpreU1pQXhNVFl1T1RnM0lEZ3VORE16TkNBeE1UWXVNeUE0TGpRek16UkRNVEUwTGpVeE15QTRMak0wTVRjMklERXhNaTQyT0RFZ09DNHlOVEF4TWlBeE1UQXVPREEwSURndU1qVXdNVEpJTlRJdU1qSTBOa016TlM0NE56TTRJRGd1TWpBME15QXlNaTQxT1RFMklESXhMalF3TURNZ01qSXVOU0F6Tnk0M05UYzVXaUlnWm1sc2JEMGlkWEpzS0NOd1lXbHVkREZmYkdsdVpXRnlYekkxTkY4eU5qYzVLU0l2UGp4d1lYUm9JR1E5SWsweE1EWXVOalkzSURrNUxqTTJNamhETVRJd0xqZ3dOQ0F4TURNdU5EVTFJREV6TVM0MU5ETWdNVEExTGpBd055QXhNemt1T0RNNUlERXdOUzR3TURkRE1UUTBMamcyTkNBeE1EVXVNREEzSURFME9DNDVPRGdnTVRBMExqUXpOaUF4TlRJdU5ESXpJREV3TXk0MU1UTkRNVFl5TGprek9DQTVNeTQwTlRjeUlERTJPUzQxSURjNUxqSTJNVE1nTVRZNUxqVWdOak11TlRJek4wTXhOamt1TlRBMUlETXpMakF6TURFZ01UUTBMamt3TVNBNExqTXdPRFk0SURFeE5DNDFOVGNnT0M0ek1EZzJPRU14TVRRdU1qVXpJRGd1TXpBNE5qZ2dNVEV6TGprME9TQTRMak14TkRBeUlERXhNeTQyTkRVZ09DNHpNVGt6TlZZNExqTXdPRFk0U0RFeE5pNDJOVFJETVRFMUxqUXpNaUE0TGpJM01UTTBJREV4TkM0eE9Ea2dPQzR5TlNBeE1USXVPVE1nT0M0eU5VZzFNaTR6TnpRNFF6TTFMamczTkRNZ09DNHlOU0F5TWk0MUlESXhMall5TkRNZ01qSXVOU0F6T0M0eE1qUTRWams1TGpFd01UUkROREl1TlRNM05TQTNOaTR6T0RBMUlEY3pMalk0TnpNZ09EY3VOVE0xTmlBeE1EWXVOalkzSURrNUxqTTJNamhhSWlCbWFXeHNQU0oxY213b0kzQmhhVzUwTWw5c2FXNWxZWEpmTWpVMFh6STJOemtwSWk4K1BIQmhkR2dnWkQwaVRURXdOaTQwT0RVZ05UQXVNalV5T1VNeE1qQXVOVGd5SURVMExqTXlOVEVnTVRNeExqSTRNU0ExTlM0NE9EQTRJREV6T1M0MU9USWdOVFV1T0Rnd09FTXhOVFF1T1RjMElEVTFMamc0TURnZ01UWXhMamt3T0NBMU1DNDFOek15SURFMk5pNDFJRFEyTGpJeU5qVkRNVFU1TGpNek55QXlOQzR5TVRnMElERXpPQzQyTnpNZ09DNHlPVFUzTlNBeE1UUXVNek0zSURndU1qazFOelZETVRFMExqQXhOU0E0TGpJNU5UYzFJREV4TXk0M05DQTRMakk1TlRjMUlERXhNeTQwTVRnZ09DNHlPVFUzTlVneE1UUXVNek0zU0RFeE5pNDBNRE5ETVRFMUxqRTJNeUE0TGpJNU5UYzFJREV4TXk0NU5qa2dPQzR5TlNBeE1USXVOamcwSURndU1qVklOVEl1TXpBeFF6TTFMamcyTWpJZ09DNHlOU0F5TWk0MUlESXhMalUyTkRjZ01qSXVOU0F6Tnk0NU5EUTVWalV3TGpBeU5ESkROREl1TkRjME5TQXlOeTQwTWpFeklEY3pMalUyTVRJZ016Z3VOVE01TnlBeE1EWXVORGcxSURVd0xqSTVPRGRXTlRBdU1qVXlPVm9pSUdacGJHdzlJblZ5YkNnamNHRnBiblF6WDJ4cGJtVmhjbDh5TlRSZk1qWTNPU2tpTHo0OGNHRjBhQ0JrUFNKTk1UQTNMall5TVNBeU1TNDBNek0wUXpFeU1TNDBNamNnTWpVdU5EWTFOQ0F4TXpFdU9UQTFJREkzTGpBd05UY2dNVFF3TGpBME5TQXlOeTR3TURVM1F6RTBOUzQ0TURJZ01qY3VNREExTnlBeE5UQXVNalUwSURJMkxqRTVNRE1nTVRVekxqazBNaUF5TlM0d01USTBRekUwTlM0Mk1qSWdNVFl1TWpZNE9DQXhNelF1TlRFMElERXdMakk0T0RjZ01USXhMamsyTnlBNExqYzBPRE0wUXpFeU1TNHhOVGNnT0M0Mk5UYzNNeUF4TWpBdU16UTRJRGd1TlRZM01UTWdNVEU1TGpRNU15QTRMalV5TVRneVF6RXhPQzQ0TVRrZ09DNDBOelkxTWlBeE1UZ3VNVFEwSURndU5ETXhNakVnTVRFM0xqUTJPU0E0TGpRek1USXhRekV4TlM0M01UWWdPQzR6TkRBMk1TQXhNVE11T1RFM0lEZ3VNalVnTVRFeUxqQTNNeUE0TGpJMVNEVTBMalUxTXpWRE5UTXVOelEwSURndU1qVWdOVEl1T1RNME5TQTRMakk1TlRNZ05USXVNVEkxSURndU16ZzFPVEZETmpndU5UTTVPQ0EzTGpNNE9USXpJRGczTGpjME1qa2dNVFF1TWpjMU5DQXhNRGN1TmpJeElESXhMalEzT0RkV01qRXVORE16TkZvaUlHWnBiR3c5SW5WeWJDZ2pjR0ZwYm5RMFgyeHBibVZoY2w4eU5UUmZNalkzT1NraUx6NDhaR1ZtY3o0OGJHbHVaV0Z5UjNKaFpHbGxiblFnYVdROUluQmhhVzUwTUY5c2FXNWxZWEpmTWpVMFh6STJOemtpSUhneFBTSXlNaTQ0TnpVaUlIa3hQU0k0TkM0NE5UQTRJaUI0TWowaU1UWTVMalF4TmlJZ2VUSTlJamcwTGpnMU1EZ2lJR2R5WVdScFpXNTBWVzVwZEhNOUluVnpaWEpUY0dGalpVOXVWWE5sSWo0OGMzUnZjQ0J6ZEc5d0xXTnZiRzl5UFNJak5EQTFOME5DSWk4K1BITjBiM0FnYjJabWMyVjBQU0l3TGpFNU5qazNJaUJ6ZEc5d0xXTnZiRzl5UFNJak0wTXpRVGxHSWk4K1BITjBiM0FnYjJabWMyVjBQU0l3TGpVME5UUTFOU0lnYzNSdmNDMWpiMnh2Y2owaUl6UTBNVFUzTVNJdlBqeHpkRzl3SUc5bVpuTmxkRDBpTVNJZ2MzUnZjQzFqYjJ4dmNqMGlJekk0TVVNelFTSXZQand2YkdsdVpXRnlSM0poWkdsbGJuUStQR3hwYm1WaGNrZHlZV1JwWlc1MElHbGtQU0p3WVdsdWRERmZiR2x1WldGeVh6STFORjh5TmpjNUlpQjRNVDBpTWpndU1ESTFOaUlnZVRFOUlqWTBMall6TkNJZ2VESTlJakUzTXk0NU1ERWlJSGt5UFNJMk5DNDJNelFpSUdkeVlXUnBaVzUwVlc1cGRITTlJblZ6WlhKVGNHRmpaVTl1VlhObElqNDhjM1J2Y0NCemRHOXdMV052Ykc5eVBTSWpOemd4UXpkQklpOCtQSE4wYjNBZ2IyWm1jMlYwUFNJeElpQnpkRzl3TFdOdmJHOXlQU0lqTlRVeE5qY3hJaTgrUEM5c2FXNWxZWEpIY21Ga2FXVnVkRDQ4YkdsdVpXRnlSM0poWkdsbGJuUWdhV1E5SW5CaGFXNTBNbDlzYVc1bFlYSmZNalUwWHpJMk56a2lJSGd4UFNJeU1pNDFJaUI1TVQwaU5qa3VNRFkyTlNJZ2VESTlJakUyT1M0M05DSWdlVEk5SWpZNUxqQTJOalVpSUdkeVlXUnBaVzUwVlc1cGRITTlJblZ6WlhKVGNHRmpaVTl1VlhObElqNDhjM1J2Y0NCdlptWnpaWFE5SWpBdU1UVTVORElpSUhOMGIzQXRZMjlzYjNJOUlpTkdSVGhCTmpjaUx6NDhjM1J2Y0NCdlptWnpaWFE5SWpFaUlITjBiM0F0WTI5c2IzSTlJaU5FT0RJMU5UQWlMejQ4TDJ4cGJtVmhja2R5WVdScFpXNTBQanhzYVc1bFlYSkhjbUZrYVdWdWRDQnBaRDBpY0dGcGJuUXpYMnhwYm1WaGNsOHlOVFJmTWpZM09TSWdlREU5SWpJNUxqQTBOVFVpSUhreFBTSXlPQzR6TlRNeklpQjRNajBpTVRVM0xqYzNNeUlnZVRJOUlqSTRMak0xTXpNaUlHZHlZV1JwWlc1MFZXNXBkSE05SW5WelpYSlRjR0ZqWlU5dVZYTmxJajQ4YzNSdmNDQnpkRzl3TFdOdmJHOXlQU0lqUmtORU5EVkdJaTgrUEhOMGIzQWdiMlptYzJWMFBTSXhJaUJ6ZEc5d0xXTnZiRzl5UFNJalJrWTRSRFkySWk4K1BDOXNhVzVsWVhKSGNtRmthV1Z1ZEQ0OGJHbHVaV0Z5UjNKaFpHbGxiblFnYVdROUluQmhhVzUwTkY5c2FXNWxZWEpmTWpVMFh6STJOemtpSUhneFBTSXhNRE11TURNeklpQjVNVDBpT0M0eU5TSWdlREk5SWpFNE1pNHdOelVpSUhreVBTSTRMakkxSWlCbmNtRmthV1Z1ZEZWdWFYUnpQU0oxYzJWeVUzQmhZMlZQYmxWelpTSStQSE4wYjNBZ2MzUnZjQzFqYjJ4dmNqMGlJelkwUWtFMFF5SXZQanh6ZEc5d0lHOW1abk5sZEQwaU1TSWdjM1J2Y0MxamIyeHZjajBpSXpFNE5rRTBOQ0l2UGp3dmJHbHVaV0Z5UjNKaFpHbGxiblErUEM5a1pXWnpQand2YzNablBqd3ZaejQ4WnlCemRIbHNaVDBpZEhKaGJuTm1iM0p0T25SeVlXNXpiR0YwWlNnNE4zQjRMQ0F4T0RWd2VDa2lQanh6ZG1jZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWlCM2FXUjBhRDBpTWpRd0lpQm9aV2xuYUhROUlqRXlNQ0lnWm1sc2JEMGlJek5rT1RWalpTSStQSEJoZEdnZ1pEMGlUVEk1TGpjNU15QXlNUzQwTkRSakxqWXdPQ0F4TGpBd05DNDRPRElnTWk0d016Y3VPRGd5SURNdU16UXpJREFnTkM0eE5qVXRNeTQxTlRVZ09TNDFOelV0Tmk0ME5DQXhNeTR6TnpSb0xUWXVOa3d4TlNBeU1pNHpOVFpzTlM0M055MHVOVFE0SURFdU16azRJREV4TGpJME4yTXhMak13TmkweUxqRXlOeUF5TGpreE55MDFMalEzSURJdU9URTNMVGN1TnpVZ01DMHhMakkwT0MwdU1qRTBMVEl1TURrM0xTNDFORGd0TWk0M09UZDZiVGN1TkRnZ05pNDVObU14TGpBMk1pQXdJRE11TnpNMUxTNDBPRFlnTXk0M016VXRNaTR3TURVZ01DMHVOek10TGpVeE5pMHhMakE1TkMweExqRXlOQzB4TGpBNU5DMHhMakEyTkNBd0xUSXVORFlnTVM0eU56WXRNaTQyTVRJZ015NHhlbTB0TGpFeU1pQXpZekFnTVM0NE5UVWdNUzR3TXpJZ01pNDFPRE1nTWk0MElESXVOVGd6SURFdU5TQXdJREl1T1RFMUxTNHpOalFnTkM0M055MHhMak13Tm13dExqWTVPQ0EwTGpjMFl5MHhMak13Tmk0Mk16Z3RNeTR6TkNBeExqQTJOQzAxTGpNeE55QXhMakEyTkMwMUlEQXROaTQ0TURVdE15NHdOQzAyTGpnd05TMDJMamd6T0NBd0xUUXVPVEkwSURJdU9URTNMVEV3TGpFMU15QTRMamt6TWkweE1DNHhOVE1nTXk0eklEQWdOUzR4TmpNZ01TNDROVFVnTlM0eE5qTWdOQzQwTkNBd0lEUXVNVFkxTFRVdU16UTFJRFV1TkRRdE9DNDBORFFnTlM0ME4zcHRNalV1TVMwMkxqSTFZekFnTGpZd09DMHVNRGt5SURFdU5TMHVNVGcwSURJdU1EWTJiQzB4TGpjek15QXhNQzQ1TkdndE5TNDJNbXd4TGpVNExURXdMakF6TGpFeU1pMHhMakV5TkdNd0xTNDNNeTB1TkRVMkxTNDVNVEl0TVM0d01EUXRMamt4TWkwdU56STRJREF0TVM0ME5UZ3VNek0wTFRFdU9UUTBMalUzT0d3dE1TNDNPVElnTVRFdU5XZ3ROUzQyTld3eUxqVTRNaTB4Tmk0ek9ETm9OQzQ1YkM0d05qSWdNUzR6TURoak1TNHhOVFF0TGpjMklESXVOamN6TFRFdU5UZ2dOQzQ0TXkweExqVTRJREl1T0RVMklEQWdNeTQ0TmlBeExqUTJJRE11T0RZZ015NDJOWHB0TVRZdU5qZ3RNUzQ0TlRaak1TNDJMVEV1TVRVMElETXVNVE10TVM0M09UTWdOUzR5TWpRdE1TNDNPVE1nTWk0NE9EVWdNQ0F6TGprZ01TNDBOaUF6TGprZ015NDJOU0F3SUM0Mk1EZ3RMakE1TWlBeExqVXRMakU0TkNBeUxqQTJObXd0TVM0M015QXhNQzQ1TkVnNE1DNDFiREV1TmkweE1DNHlORE11TURreUxTNDRNbU13TFM0NE1qSXRMalExTmkweExqQXdOQzB4TGpBd05DMHhMakF3TkMwdU5qazRJREF0TVM0ek9UWXVNekEwTFRFdU9URTBMalUzT0d3dE1TNDRJREV4TGpWb0xUVXVOakpzTVM0MkxURXdMakkwTXk0eExTNDRNbU13TFM0NE1qSXRMalExTmkweExqQXdOQzB4TGpBd01pMHhMakF3TkMwdU56TWdNQzB4TGpRMU9DNHpNelF0TVM0NU5EUXVOVGM0YkMweExqYzVNeUF4TVM0MWFDMDFMalkxYkRJdU5UZ3RNVFl1TXpnemFEUXVPRE5zTGpFMU1pQXhMak0yT0dNeExqRXlOQzB1T0RJZ01pNDJOREl0TVM0Mk5DQTBMalkzTnkweExqWTBJREV1TnpZeUxTNHdNREVnTWk0NU1UWXVOellnTXk0ME9UUWdNUzQzT1RONmJUSXdMakk1TmlBMExqYzNNbU13TFRFdU16TTNMUzR6TXpRdE1pNHlOUzB4TGpNek5pMHlMakkxTFRJdU1qRTRJREF0TWk0Mk56TWdNeTQ1TWkweUxqWTNNeUExTGpreU5pQXdJREV1TlRJeUxqUXlOaUF5TGpRMk15QXhMalF5TnlBeUxqUTJNeUF5TGpBNU5pQXdJREl1TlRneUxUUXVNVE0xSURJdU5UZ3lMVFl1TVRSNmJTMDVMamN5SURNdU5ETTFZekF0TlM0eE5qY2dNaTQzTXpNdE1UQWdPUzR3TWpJdE1UQWdOQzQzTkNBd0lEWXVORGNnTWk0M09UY2dOaTQwTnlBMkxqWTFPQ0F3SURVdU1UQTNMVEl1TnpBMElERXdMak01TlMwNUxqRTBOQ0F4TUM0ek9UVXROQzQzTnlBd0xUWXVNelV0TXk0eE15MDJMak0xTFRjdU1EVXllaUl2UGp3dmMzWm5Qand2Wno0Z1BHY2djM1I1YkdVOUluUnlZVzV6Wm05eWJUcDBjbUZ1YzJ4aGRHVW9Namx3ZUN3Z05ERTBjSGdwSWo0OGNtVmpkQ0IzYVdSMGFEMGlOak53ZUNJZ2FHVnBaMmgwUFNJeU5uQjRJaUJ5ZUQwaU9IQjRJaUJ5ZVQwaU9IQjRJaUJtYVd4c1BTSnlaMkpoS0RBc01Dd3dMREF1TmlraUlDOCtQSFJsZUhRZ2VEMGlNVEp3ZUNJZ2VUMGlNVGR3ZUNJZ1ptOXVkQzFtWVcxcGJIazlJaWREYjNWeWFXVnlJRTVsZHljc0lHMXZibTl6Y0dGalpTSWdabTl1ZEMxemFYcGxQU0l4TW5CNElpQm1hV3hzUFNKM2FHbDBaU0krUEhSemNHRnVJR1pwYkd3OUluSm5ZbUVvTWpVMUxESTFOU3d5TlRVc01DNDJLU0krU1VRNklEd3ZkSE53WVc0K01Ud3ZkR1Y0ZEQ0OEwyYytJRHhuSUhOMGVXeGxQU0owY21GdWMyWnZjbTA2ZEhKaGJuTnNZWFJsS0RJNWNIZ3NJRFEwTkhCNEtTSStQSEpsWTNRZ2QybGtkR2c5SWpFek0zQjRJaUJvWldsbmFIUTlJakkyY0hnaUlISjRQU0k0Y0hnaUlISjVQU0k0Y0hnaUlHWnBiR3c5SW5KblltRW9NQ3d3TERBc01DNDJLU0lnTHo0OGRHVjRkQ0I0UFNJeE1uQjRJaUI1UFNJeE4zQjRJaUJtYjI1MExXWmhiV2xzZVQwaUowTnZkWEpwWlhJZ1RtVjNKeXdnYlc5dWIzTndZV05sSWlCbWIyNTBMWE5wZW1VOUlqRXljSGdpSUdacGJHdzlJbmRvYVhSbElqNDhkSE53WVc0Z1ptbHNiRDBpY21kaVlTZ3lOVFVzTWpVMUxESTFOU3d3TGpZcElqNVFiR0YwWm05eWJUb2dQQzkwYzNCaGJqNVdaVzV0Ynp3dmRHVjRkRDQ4TDJjK1BDOXpkbWMrIn0=";
        assertEq(tokenURI, expectedTokenURI);
    }

    function test_MintTwo() public {
        vm.startPrank(address(1));
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();

        // Register user 0x2
        ramp.setAccountInfo(
            address(2),
            IRamp.AccountInfo({
                venmoIdHash: bytes32(uint256(2)),
                deposits: new uint256[](0)
            })
        );
        vm.startPrank(address(2));
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();
        
        uint256 currTokenId = proofOfVenmoNFT.currentTokenId();
        assertEq(currTokenId, 2);

        address ownerOne = proofOfVenmoNFT.ownerOf(1);
        assertEq(ownerOne, address(1));

        uint256 balanceOne = proofOfVenmoNFT.balanceOf(address(1));
        assertEq(balanceOne, 1);

        bool mintedOne = proofOfVenmoNFT.minted(bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf));
        assertTrue(mintedOne);

        address ownerTwo = proofOfVenmoNFT.ownerOf(2);
        assertEq(ownerTwo, address(2));

        uint256 balanceTwo = proofOfVenmoNFT.balanceOf(address(2));
        assertEq(balanceTwo, 1);

        bool mintedTwo = proofOfVenmoNFT.minted(bytes32(uint256(2)));
        assertTrue(mintedTwo);
    }

    function test_RevertMintNotRegistered() public {
        vm.startPrank(address(0xd3ad));
        vm.expectRevert("Not registered");
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();
    }

    function test_RevertMintNullified() public {
        vm.startPrank(address(1));
        proofOfVenmoNFT.mintSBT();
        vm.expectRevert("Already minted for ID Hash");
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();
    }

    function test_RevertMintNullifiedDifferentAddress() public {
        vm.startPrank(address(1));
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();

        // Register user 0x2
        ramp.setAccountInfo(
            address(2),
            IRamp.AccountInfo({
                venmoIdHash: bytes32(0x0741728e3aae72eda484e8ccbf00f843c38eae9c399b9bd7fb2b5ee7a055b6bf),
                deposits: new uint256[](0)
            })
        );

        vm.startPrank(address(2));
        vm.expectRevert("Already minted for ID Hash");
        proofOfVenmoNFT.mintSBT();
        vm.stopPrank();
    }

    function test_RevertTransfers() public {
        vm.startPrank(address(1));
        proofOfVenmoNFT.mintSBT();
        
        vm.expectRevert("ERC721 public transferFrom not allowed");
        proofOfVenmoNFT.transferFrom(address(1), address(2), 1);

        vm.expectRevert("ERC721 public safeTransferFrom not allowed");
        proofOfVenmoNFT.safeTransferFrom(address(1), address(2), 1);

        vm.expectRevert("ERC721 public safeTransferFrom not allowed");
        proofOfVenmoNFT.safeTransferFrom(address(1), address(2), 1, "");
        vm.stopPrank();
    }
}
