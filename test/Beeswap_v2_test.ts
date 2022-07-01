
import { expect } from "chai";
import { deployContract, MockProvider } from "ethereum-waffle";
import { BigNumber, Contract, Signer, utils } from "ethers";
import Token1Json from "../artifacts/contracts/test_token1.sol/TestToken1.json";
import Token2Json from "../artifacts/contracts/test_token2.sol/TestToken2.json";
import BeeswapV2Json from "../artifacts/contracts/Beeswap/Beewsap_v2.sol/BeeswapV2.json";
import BeeswapV3json from "../artifacts/contracts/Beeswap/Beeswap_v3.sol/BeeswapV3.json";
import { ethers } from "hardhat";
import { BeeswapV2 } from "../typechain";

describe("Beeswap V2", function () {
  // using ganache address
  const signerAddress: string = "0x0B810Ea5a89A75cEdd3ECaBC4D32c8da48b8E07d";

  const DAI_ADDRESS: string = "0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735";
  const [walletFrom, walletTo] = new MockProvider().getWallets();
  const totalSupply: BigInt = BigInt(500 * 10 ** 18);
  let token1: Contract;
  let token2: Contract;

  let beeswapV2: Contract;
  let beeswapv3: Contract;
  let DAI: any;

  beforeEach(async () => {
    //  get signer from address 
    const signer = await ethers.getSigner(signerAddress);

    token1 = await deployContract(walletFrom, Token1Json, [totalSupply]);
    token2 = await deployContract(walletTo, Token2Json, [totalSupply]);
    DAI = await ethers.getContractAt("ERC20Interface", DAI_ADDRESS, signer);

    beeswapV2 = await deployContract(signer, BeeswapV2Json);

    await token1.deployed();
    await token2.deployed();
    await beeswapV2.deployed();

    console.log(beeswapV2.address);

  });


  it("Beeswapv2 swapETHforTokens", async () => {
    const results = await beeswapV2.swapEthForTokens({ from: signerAddress, value: utils.parseEther("10"), gasLimit: 3000000 });
    // console.log(results);
    // expect(await DAI.balanceOf(signerAddress)).equals(BigNumber.from(results));
    //console.log(await DAI.balanceOf(signerAddress));

  }).timeout(80000)


});
