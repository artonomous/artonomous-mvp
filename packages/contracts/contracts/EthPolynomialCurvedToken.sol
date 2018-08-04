pragma solidity ^0.4.24; //solhint-disable-line compiler-fixed

import "./EthBondingCurvedToken.sol";


/// @title  EthPolynomialCurvedToken - A polynomial bonding curve
///         implementation that is backed by ether.
contract EthPolynomialCurvedToken is EthBondingCurvedToken {

    uint256 constant private PRECISION = 10000000000;

    uint8 public exponent;

    /// @dev constructor        Initializes the bonding curve
    /// @param name             The name of the token
    /// @param decimals         The number of decimals to use
    /// @param symbol           The symbol of the token
    /// @param _exponent        The exponent of the curve
    constructor(
        string name,
        uint8 decimals,
        string symbol,
        uint8 _exponent
    ) EthBondingCurvedToken(name, decimals, symbol) public {
        exponent = _exponent;
    }

    function priceToMint(uint256 numTokens) public returns(uint256) {
        return curveIntegral(totalSupply.add(numTokens)).sub(poolBalance);
    }

    function rewardForBurn(uint256 numTokens) public returns(uint256) {
        return poolBalance.sub(curveIntegral(totalSupply.sub(numTokens)));
    }

    /// @dev        Calculate the integral from 0 to t
    /// @param t    The number to integrate to
    function curveIntegral(uint256 t) internal returns (uint256) {
        uint256 nexp = exponent + 1;
        // Calculate integral of t^exponent
        return PRECISION.div(nexp).mul(t ** nexp).div(PRECISION);
    }
}
