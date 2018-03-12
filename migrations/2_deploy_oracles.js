const USDETHOracle = artifacts.require('./USDETHOracle.sol');

module.exports = (deployer, network) => {
  if (network === 'rinkeby') {
    // admin: 0x1fbeC754f37fC179d5332c2cA9131B19Ce6AE862 [account 2 on mnemomic]
    deployer.deploy(USDETHOracle, '0x1fbeC754f37fC179d5332c2cA9131B19Ce6AE862', 43200);
  } else if (network === 'mainnet') {
    // admin: 0x5deda52dc2b3a565d77e10f0f8d4bd738401d7d3. Ujo MultiSig
    // 60*60*1 = 3600. 1 hours for now on deploy
    // 60*60*24 = 86400 (12 = 43200)
    // start with half day
    deployer.deploy(USDETHOracle, '0x5deda52dc2b3a565d77e10f0f8d4bd738401d7d3', 43200);
  }
};
