const hre = require("hardhat");

async function main() {
  const MiPrimerToken = await hre.ethers.getContractFactory("MiPrimerToken");
  const miPrimerToken = await MiPrimerToken.deploy();

  var tx = await miPrimerToken.deployed();
  await tx.deployTransaction.wait(5);

  console.log(`Deploy at ${miPrimerToken.address}`);

  await hre.run("verify:verify", {
    address: miPrimerToken.address,
    constructorArguments: [],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
