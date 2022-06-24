
import { expect } from "chai";
import { deployContract, MockProvider } from "ethereum-waffle";
import { BigNumber, Contract } from "ethers";
import BeeswapJson from "../artifacts/contracts/Beeswap/Beeswap.sol/Beeswap.json";
import Token1Json from "../artifacts/contracts/test_token1.sol/TestToken1.json";
import Token2Json from "../artifacts/contracts/test_token2.sol/TestToken2.json";
import BeeJson from "../artifacts/contracts/Beeswap/Bee.sol/Bee.json";
import ExampleJson from "../artifacts/contracts/Beeswap/example.sol/SwapExamples.json";

describe("Beeswap", function () {
  const v2Router: string = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const v3Router: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  const [walletFrom, walletTo] = new MockProvider().getWallets();
  const totalSupply: BigInt = BigInt(500 * 10 ** 18);
  let beeswap: Contract;
  let token1: Contract;
  let token2: Contract;
  let bee: Contract;
  let example: Contract;

  beforeEach(async () => {
    token1 = await deployContract(walletFrom, Token1Json, [totalSupply]);
    token2 = await deployContract(walletTo, Token2Json, [totalSupply]);
    beeswap = await deployContract(walletFrom, BeeswapJson, [v3Router, token1.address, token2.address, 0, 5000]);
    bee = await deployContract(walletFrom, BeeJson)
    example = await deployContract(walletFrom, ExampleJson, [v3Router]);
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


    const results = await beeswap.swapExactInput(25, token1.address, token2.address, { from: walletFrom.address, gasLimit: 3000000 });
    expect(await token1.balanceOf(beeswap.address)).equals(25);
    expect(await token1.allowance(beeswap.address, v3Router)).equals(25);


    // console.log(results);


  })

  // it("testing bee", async () => {

  //   const results = await bee.swap(50, { gasLimit: 3000000 });
  //   console.log(results);

  // })

  // it("uniswap example", async () => {
  //   await example.swapExactInputSingle(100, { gasLimit: 3000000 });
  //});
});
