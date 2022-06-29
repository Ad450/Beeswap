import { deployContract } from "ethereum-waffle";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import BeeswapV3Json from "../artifacts/contracts/Beeswap/Beeswap_v3.sol/BeeswapV3.json";


describe("Beeswap V3", async () => {
    // using ganache address
    const signerAddress: string = "0x284D0f54B00c5CEd7435BCD5E4b7f0a4DE492d63";
    let beeswapV3: Contract;


    beforeEach(async () => {
        const signer = await ethers.getSigner(signerAddress);
        beeswapV3 = await deployContract(signer, BeeswapV3Json);

        await beeswapV3.deployed();
    });

    it("should deploy contract BeeswapV3", async () => {
        console.log(beeswapV3.address);

    });
});