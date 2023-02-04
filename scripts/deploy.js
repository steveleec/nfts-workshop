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

async function deployCuyes() {
  var CuyMoches = await hre.ethers.getContractFactory("CuyMoches");
  var vuyMoches = await CuyMoches.deploy();
  var tx = await vuyMoches.deployed();
  await tx.deployTransaction.wait(5);
  console.log("Address:", vuyMoches.address);

  console.log("Empezo la verificaion");
  // script para verificacion del contrato
  await hre.run("verify:verify", {
    address: vuyMoches.address,
    constructorArguments: [],
  });
}

// main()
deployCuyes()
  //
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
