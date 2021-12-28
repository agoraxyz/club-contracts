# Seed Club smart contracts

The smart contracts in this repository are being used by [Seed Club](https://seedclub.xyz).

## Requirements

To run the project you need:

- [Node.js](https://nodejs.org) development environment.
- [Truffle](https://www.trufflesuite.com/truffle) for compiling, deploying and testing (installed globally via npm).
- (optional) [Ganache](https://www.trufflesuite.com/ganache) for local testing (installed globally via npm).
- (optional) A file named `.env`

Your `.env` file should contain the following:

- Your 12-word MetaMask seedphrase for deploying:
  `MNEMONIC='seedphrase'`
- Your [Infura](https://infura.io) project ID for deploying to Ethereum networks:
  `INFURA_ID='id'`
- Your [Etherscan API key](https://etherscan.io/myapikey) for verification the source code:
  `ETHERSCAN_API_KEY='api key'`

## Tasks before deployment, usage

Pull the repository from GitHub, then install its dependencies by executing this command:

```bash
npm install
```

### Merkle distributor contract

First you need to generate a Merkle tree. See section **Generating a Merkle tree** below.

Open _migrations/3_deploy_distributor.js_. Notice the top three constants:

```javascript
const token = "0x..."; // the address of the token to be distributed
const merkleRoot = "0x..."; // the merkle root generated by scripts/generate-merkle-root.ts
const distributionDuration = "86400"; // the duration of the rewards distribution in seconds
```

Edit them according to your needs.  
You can find the Merkle root in the previously generated json file.

### Merkle vesting contract

Open _migrations/4_deploy_vesting.js_. Edit the constant at the top according to your needs:

```javascript
const token = "0x..."; // the address of the token to be distributed
```

To add a new cohort to a deployed contract, you need to generate a Merkle tree. See section **Generating a Merkle tree** below.

### Generating a Merkle tree

First, you'll need a .json file with the addresses you wish to ditribute rewards to and the respective token amounts in hexadecimal format. For help, take a look at the _example.json_ file in the _scripts_ folder.  
Create a similarly structured file and place it next to the example file.  
When you're ready, open a terminal in the project's directory and run this command (replace _[filename]_ with the relative path and name of your file):

```bash
npm run generate-merkle-root -- -i [filename]
```

If the script succeeded, you should see a file named _result.json_ in the _scripts_ folder, containing the Merkle root and the data needed for individual users to claim their tokens.

#### Note

If you exported a csv from a software like Google Sheets, with amounts in a more human readable form (decimal form, whole tokens (not "wei")), you can easily convert that to the json needed by the above script. You only need to run this command:

```bash
npm run csv-to-json -- -i [filename]
```

If the script succeeded, you should see a file named _readyInput.json_ in the _scripts_ folder.

## Deployment

To deploy the smart contracts to a network, replace _[networkName]_ in this command:

```bash
truffle migrate --network [networkName]
```

Networks can be configured in _truffle-config.js_. We've preconfigured the following:

- `development` (for local testing)
- `ethereum` (Ethereum Mainnet)
- `goerli` (Görli Ethereum Testnet)
- `kovan` (Kovan Ethereum Testnet)
- `ropsten` (Ropsten Ethereum Testnet)
- `bsc` (Binance Smart Chain)
- `bsctest` (Binance Smart Chain Testnet)
- `polygon` (Polygon Mainnet (formerly Matic))
- `mumbai` (Matic Mumbai Testnet)

### Note

The above procedure deploys all the contracts. If you want to deploy only specific contracts, you can run only the relevant script(s) via the below command:

```bash
truffle migrate -f [start] --to [end] --network [name]
```

Replace _[start]_ with the number of the first and _[end]_ with the number of the last migration script you wish to run. To run only one script, _[start]_ and _[end]_ should match. The numbers of the scripts are:

- 1 - Migrations
- 2 - Seed Club Mint
- 3 - Merkle distributor
- 4 - Merkle vesting
- 5 - Staking Rewards

If the script fails before starting the deployment, you might need to run the first one, too.

## Verification

For automatic verification you can use [truffle plugin verify](https://github.com/rkalis/truffle-plugin-verify).

```bash
truffle run verify [contractName] --network [networkName]
```

## Tests

To run the unit tests written for this project, execute this command in a terminal:

```bash
npm test
```
