
import { expect } from "chai";
import { assert } from "console";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("Beeswap", function () {
  let testToken1: Contract;
  let testToken2: Contract;
  let beeswap: Contract;
  const testAmount: Number = 50;
  const swapRouter: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  const deployingAddress: string = "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266";


  beforeEach(async () => {
    // token0
    const TestToken1 = await ethers.getContractFactory("TestToken1");
    testToken1 = await TestToken1.deploy(500);
    await testToken1.deployed();

    // token1
    const TestToken2 = await ethers.getContractFactory("TestToken2");
    testToken2 = await TestToken2.deploy(50);
    await testToken2.deployed();

    // deploy beeswap contract
    const Beeswap = await ethers.getContractFactory("Beeswap");
    beeswap = await Beeswap.deploy(swapRouter, testToken1.address, testToken1.address, 0, 10);

    await beeswap.deployed();
  });

  it("Should deploy Beeswap", async () => {

    expect(testToken1.address).exist;
    expect(testToken1.address).exist;

    expect(beeswap.address).exist;

  });

  it("should return the maximum amount of token1 in swap", async () => {
    // first load the balance of the deploying contract with at least 50
    expect(await testToken1.balanceOf(deployingAddress)).equals(500)

    // approve beeswap to spend tokens
    // testToken1.approve(beeswap.address, testAmount);

    await beeswap.swapExactInput(testAmount);

    // assert(result !== null);
  })
});
