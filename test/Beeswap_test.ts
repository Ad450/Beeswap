
import { expect } from "chai";
import { deployContract, MockProvider } from "ethereum-waffle";
import { BigNumber, Contract, Signer } from "ethers";
import Token1Json from "../artifacts/contracts/test_token1.sol/TestToken1.json";
import Token2Json from "../artifacts/contracts/test_token2.sol/TestToken2.json";
import BeeswapV2Json from "../artifacts/contracts/Beeswap/Beewsap_v2.sol/BeeswapV2.json";
import BeeswapV3json from "../artifacts/contracts/Beeswap/Beeswap_v3.sol/BeeswapV3.json";
import { ethers } from "hardhat";
import { BeeswapV2 } from "../typechain";

describe("Beeswap V2", function () {
  const v2Router: string = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const v3Router: string = "0xE592427A0AEce92De3Edee1F18E0157C05861564";
  const signerAddress: string = "0xe57A9202878B529E6D35602faB66a5a0B5143f38";

  const DAI_ADDRESS: string = "0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735";
  const [walletFrom, walletTo] = new MockProvider().getWallets();
  const totalSupply: BigInt = BigInt(500 * 10 ** 18);
  let token1: Contract;
  let token2: Contract;

  let beeswapV2: Contract;
  let beeswapv3: Contract;
  let DAI: any;

  beforeEach(async () => {
    const signer = await ethers.getSigner(signerAddress);

    token1 = await deployContract(walletFrom, Token1Json, [totalSupply]);
    token2 = await deployContract(walletTo, Token2Json, [totalSupply]);
    DAI = await ethers.getContractAt("ERC20Interface", DAI_ADDRESS, signer);

    //  get signer from address 
    beeswapV2 = await deployContract(signer, BeeswapV2Json);

    await token1.deployed();
    await token2.deployed();
    await beeswapV2.deployed();

    console.log(beeswapV2.address);


  });


  it("Beeswapv2 swapETHforTokens", async () => {
    const results = await beeswapV2.swapEthForTokens({ from: signerAddress, value: 2000, gasLimit: 3000000 });
    // console.log(results);
    // expect(await DAI.balanceOf(signerAddress)).equals(BigNumber.from(results));
  }).timeout(80000)


});
