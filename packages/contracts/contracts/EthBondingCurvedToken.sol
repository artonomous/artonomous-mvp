pragma solidity ^0.4.24; //solhint-disable-line compiler-fixed

// via: https://github.com/oed/bonding-curves
// untested

import "tokens/eip20/EIP20.sol";
import "zeppelin/contracts/math/SafeMath.sol";


/// @title  EthBondingCurvedToken - A bonding curve
///         implementation that is backed by ether.
contract EthBondingCurvedToken is EIP20 {

    event Minted(uint256 amount, uint256 totalCost);
    event Burned(uint256 amount, uint256 reward);

    using SafeMath for uint256;

    uint256 public poolBalance;

    /// @dev constructor    Initializes the bonding curve
    /// @param name         The name of the token
    /// @param decimals     The number of decimals to use
    /// @param symbol       The symbol of the token
    constructor(
        string name,
        uint8 decimals,
        string symbol
    ) EIP20(0, name, decimals, symbol) public {}

    /// @dev                Get the price in ether to mint tokens
    /// @param numTokens    The number of tokens to calculate price for
    function priceToMint(uint256 numTokens) public returns(uint256);

    /// @dev                Get the reward in ether to burn tokens
    /// @param numTokens    The number of tokens to calculate reward for
    function rewardForBurn(uint256 numTokens) public returns(uint256);

    /// @dev                Mint new tokens with ether
    /// @param numTokens    The number of tokens you want to mint
    function mint(uint256 numTokens) public payable {
        uint256 priceForTokens = priceToMint(numTokens);
        require(msg.value >= priceForTokens);

        totalSupply = totalSupply.add(numTokens);
        balances[msg.sender] = balances[msg.sender].add(numTokens);
        poolBalance = poolBalance.add(priceForTokens);
        if (msg.value > priceForTokens) {
            msg.sender.transfer(msg.value - priceForTokens);
        }

        emit Minted(numTokens, priceForTokens);
    }

    /// @dev                Burn tokens to receive ether
    /// @param numTokens    The number of tokens that you want to burn
    function burn(uint256 numTokens) public {
        require(balances[msg.sender] >= numTokens);

        uint256 ethToReturn = rewardForBurn(numTokens);
        totalSupply = totalSupply.sub(numTokens);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        poolBalance = poolBalance.sub(ethToReturn);
        msg.sender.transfer(ethToReturn);

        emit Burned(numTokens, ethToReturn);
    }
}
