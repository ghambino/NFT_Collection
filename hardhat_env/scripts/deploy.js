const { ethers } = require("hardhat");
require("dotenv").config({path: ".env"});

const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

const main = async() => {
    const whitelistContract = WHITELIST_CONTRACT_ADDRESS;

    const metadataURL = METADATA_URL;
    //make an abstraction of the contract
    const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

    //deploy the contract abstraction and pass in required variables

    const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
        metadataURL, 
        whitelistContract
    );

    //print the contract address to the console

    console.log("Crypto Devs Contract Address", deployedCryptoDevsContract.address);

}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1)
})