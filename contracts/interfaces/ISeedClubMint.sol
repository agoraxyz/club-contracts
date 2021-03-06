// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A contract that deploys ERC20 token contracts for anyone.
interface ISeedClubMint {
    /// @notice Deploys a new ERC20 token contract.
    /// @param tokenName The token's name.
    /// @param tokenSymbol The token's symbol.
    /// @param tokenDecimals The token's number of decimals.
    /// @param initialSupply The initial amount of tokens to mint.
    /// @param firstOwner The first address to assign ownership/minting rights to (if mintable). The recipient of the initial supply.
    /// @param mintable Whether to create a mintable token.
    /// @param multiOwner If true, use AccessControl, otherwise Ownable (does not apply if the token is not mintable).
    function createToken(
        string calldata tokenName,
        string calldata tokenSymbol,
        uint8 tokenDecimals,
        uint256 initialSupply,
        address firstOwner,
        bool mintable,
        bool multiOwner
    ) external;

    /// @notice Event emitted when creating a token.
    /// @param token The address of the newly created token.
    event TokenDeployed(address token);
}
