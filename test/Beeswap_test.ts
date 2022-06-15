
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Beeswap", function () {
  it("Should deploy Beeswap", async ()=> {
    const Beeswap = await ethers.getContractFactory("Beeswap");
    const beeswap  = await Beeswap.deploy();

     await beeswap.deployed();

    expect(beeswap.address).exist;
  });
});
