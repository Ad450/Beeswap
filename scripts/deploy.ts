// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import hre from "hardhat"

async function main() {

  const swapRouter: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  // token0
  const TestToken1 = await ethers.getContractFactory("TestToken1");
  const testToken1 = await TestToken1.deploy("500");
  await testToken1.deployed();

  // token1
  const TestToken2 = await ethers.getContractFactory("TestToken2");
  const testToken2 = await TestToken2.deploy("500");
  await testToken2.deployed();

  // deploy beeswap contract
  const Beeswap = await ethers.getContractFactory("Beeswap");
  const beeswap = await Beeswap.deploy(swapRouter, testToken1.address, testToken2.address, 0, 2000);

  // bee
  const Bee = await ethers.getContractFactory("Bee");
  const bee = await Bee.deploy();

  // example 
  const Example = await ethers.getContractFactory("Bee");
  const example = await Example.deploy();


  console.log("beeswap deployed to:", beeswap.address);
  console.log("Bee deployed to ", bee.address);
  console.log(example.address);


  // await hre.tenderly.persistArtifacts({
  //   name: "Beeswap",
  //   address: beeswap.address,
  // })



  await hre.tenderly.persistArtifacts({
    name: "Beeswap",
    address: beeswap.address,
  })
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
