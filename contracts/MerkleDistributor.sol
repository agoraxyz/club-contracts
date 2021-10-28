// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.9;

import "./interfaces/IMerkleDistributor.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleDistributor is IMerkleDistributor, Ownable {
    address public immutable token;
    bytes32 public immutable merkleRoot;
    uint256 public immutable distributionEnd;

    // This is a packed array of booleans.
    mapping(uint256 => uint256) private claimedBitMap;

    constructor(
        address token_,
        bytes32 merkleRoot_,
        uint256 distributionDuration
    ) {
        token = token_;
        merkleRoot = merkleRoot_;
        distributionEnd = block.timestamp + distributionDuration;
    }

    function isClaimed(uint256 index) public view returns (bool) {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        uint256 claimedWord = claimedBitMap[claimedWordIndex];
        uint256 mask = (1 << claimedBitIndex);
        return claimedWord & mask == mask;
    }

    function _setClaimed(uint256 index) private {
        uint256 claimedWordIndex = index / 256;
        uint256 claimedBitIndex = index % 256;
        claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
    }

    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        require(block.timestamp <= distributionEnd, "Distribution period ended");
        require(!isClaimed(index), "Drop already claimed");

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof");

        // Mark it claimed and send the token.
        _setClaimed(index);
        require(IERC20(token).transfer(account, amount), "Transfer failed");

        emit Claimed(index, account, amount);
    }

    // Allows the owner to reclaim the tokens deposited in this contract
    function withdraw(address recipient) external onlyOwner {
        require(block.timestamp > distributionEnd, "Distribution period did not end");
        require(IERC20(token).transfer(recipient, IERC20(token).balanceOf(address(this))), "Withdraw transfer failed");
        emit Withdrawn(recipient, IERC20(token).balanceOf(address(this)));
    }
}