const token = "0x..."; // the address of the token to be distributed
const merkleRoot = "0x..."; // the merkle root generated by scripts/generate-merkle-root.ts
const distributionDuration = "86400"; // the duration of the rewards distribution in seconds

const MerkleDistributor = artifacts.require("MerkleDistributor");

module.exports = (deployer) => {
  deployer.deploy(MerkleDistributor, token, merkleRoot, distributionDuration);
};
