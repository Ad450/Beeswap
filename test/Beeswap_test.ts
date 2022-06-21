
import { expect } from "chai";
import { deployContract, MockProvider } from "ethereum-waffle";
import { BigNumber, Contract } from "ethers";
import BeeswapJson from "../artifacts/contracts/Beeswap/Beeswap.sol/Beeswap.json";
import Token1Json from "../artifacts/contracts/test_token1.sol/TestToken1.json";
import Token2Json from "../artifacts/contracts/test_token2.sol/TestToken2.json";

describe("Beeswap", function () {
  const swapRouter: string = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const [walletFrom, walletTo] = new MockProvider().getWallets();
  const totalSupply: BigInt = BigInt(500 * 10 ** 18);
  let beeswap: Contract;
  let token1: Contract;
  let token2: Contract;


  beforeEach(async () => {
    token1 = await deployContract(walletFrom, Token1Json, [totalSupply]);
    token2 = await deployContract(walletTo, Token2Json, [500]);
    beeswap = await deployContract(walletFrom, BeeswapJson, [swapRouter, token1.address, token2.address, 0, 10]);


  });

  it("should deploy beeswap", async () => {
    expect(beeswap.address).exist;
  })

  it("should return 500 token1 for walletFrom", async () => {
    //expect(await token1.balanceOf(walletFrom.address)).equals(500);
    console.log(beeswap.address);

  })

  // test swap functionality without LPs, load Beeswap with some token2
  it("should swap token1 and token2", async () => {

    await token1.approve(beeswap.address, 300, { from: walletFrom.address });

    const results = await beeswap.swapTokensForTokens(25, { from: walletFrom.address });


    // expect(await token1.balanceOf(beeswap.address)).equals(25);
    // expect(await token1.allowance(beeswap.address, swapRouter)).equals(25);

    console.log(results);


  })
});
