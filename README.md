# Degen Token (ERC-20): Unlocking the Future of Gaming

Degen Token is a unique ERC-20 token designed by Degen Gaming 🎮, a renowned game studio, to reward players and enhance their gaming experience. Built on the Avalanche blockchain, this token can be earned by players in the game and exchanged for rewards in the in-game store. It aims to increase player loyalty and retention.

## Description

Degen Token is an ERC-20 token deployed on the Avalanche blockchain. This token is designed for a virtual reality clothing platform, where users can earn tokens by participating in the game, transfer tokens to others, redeem tokens for virtual clothing items, and check their token balance at any time. The project showcases the integration of blockchain technology in a gaming environment to enhance user engagement and create a seamless in-game economy.

## Getting Started

### Prerequisites

- Node.js
- npm (Node Package Manager)
- Hardhat
- Metamask
- Avalanche Fuji Testnet faucet for test AVAX

### Installing

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/qeewpi/DegenToken.git
   cd DegenToken
   ```

2. **Install Dependencies:**

   ```bash
   npm install
   ```

3. **Configure Environment Variables:**

   Create a `.env` file in the project root and add your private key and Snowtrace API key:

   ```plaintext
   PRIVATE_KEY=your_private_key
   ```

### Executing Program

1. **Compile the Smart Contract:**

   ```bash
   npx hardhat compile
   ```

2. **Run Tests:**

   ```bash
   npx hardhat test
   ```

3. **Deploy to Avalanche Fuji Testnet:**

   ```bash
   npx hardhat run scripts/deploy.js --network fuji
   ```

4. **Verify the Smart Contract on Snowtrace:**

   ```bash
   npx hardhat verify --network fuji <deployed_contract_address>
   ```

## Help

If you encounter issues related to insufficient funds, make sure your wallet has enough test AVAX from the Avalanche Fuji Testnet faucet. If there are issues with the deployment, ensure the network configuration and private keys are correctly set in the .env file.

```bash
npx hardhat help
```

## Authors

- **Allen Kyle Sabilala** - [GitHub](https://github.com/Kycehhh)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.






