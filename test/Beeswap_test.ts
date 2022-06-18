
import { expect } from "chai";
import { assert } from "console";
import { deployContract, MockProvider } from "ethereum-waffle";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import BeeswapJson from "../artifacts/contracts/Beeswap/Beeswap.sol/Beeswap.json";
import Token1Json from "../artifacts/contracts/test_token1.sol/TestToken1.json";
import Token2Json from "../artifacts/contracts/test_token2.sol/TestToken2.json";

describe("Beeswap", function () {
  const swapRouter: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  const [walletFrom, walletTo] = new MockProvider().getWallets();
  let beeswap: Contract;
  let token1: Contract;
  let token2: Contract;

  beforeEach(async () => {
    token1 = await deployContract(walletFrom, Token1Json, [500]);
    token2 = await deployContract(walletTo, Token2Json, [500]);
    beeswap = await deployContract(walletFrom, BeeswapJson, [swapRouter, token1.address, token2.address, 0, 10]);


  });

  it("should deploy beeswap", async () => {
    expect(beeswap.address).exist;
  })


});
