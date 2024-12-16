[![](https://raw.githubusercontent.com/antitokens/tachyon-oracle/main/.github/badge.svg?v=12345)](https://github.com/antitokens/tachyon-oracle/actions/workflows/test.yml)

## Setup

#### 1. [Install Foundry](https://getfoundry.sh/)
`curl -L https://foundry.paradigm.xyz | bash && source ~/.bashrc && foundryup`

#### 2. [Install Forge]
`forge install foundry-rs/forge-std --no-commit --no-git`

#### 3. [Install Chainlink Factory]
`forge install smartcontractkit/chainlink-brownie-contracts --no-commit --no-git`

#### 3a. [Docker for Apple M1/M2]
`docker pull smartcontract/chainlink:2.19.0 --platform linux/amd64`
