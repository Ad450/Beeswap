
import { expect } from "chai";
import { assert } from "console";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("Beeswap", function () {
  let testToken0: Contract;
  let testToken1: Contract;
  let beeswap: Contract;
  let swapRouter: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";

  beforeEach(async () => {
    // token0
    const TestToken0 = await ethers.getContractFactory("TestToken0");
    testToken0 = await TestToken0.deploy("500");
    await testToken0.deployed();

    // token1
    const TestToken1 = await ethers.getContractFactory("TestToken1");
    testToken1 = await TestToken0.deploy("500");
    await testToken0.deployed();

    // deploy beeswap contract
    const Beeswap = await ethers.getContractFactory("Beeswap");
    beeswap = await Beeswap.deploy(swapRouter, testToken0.address, testToken1.address, 0, 2000);

    await beeswap.deployed();
  });

  it("Should deploy Beeswap", async () => {

    expect(testToken0.address).exist;
    expect(testToken1.address).exist;

    expect(beeswap.address).exist;

  });

  it("should return the maximum amount of token1 in swap", async () => {
    testToken0.balanceOf()

    // const result = await beeswap.swapExactInput(3000);

    //assert(result !== null);
  })
});
