const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Tests", function () {
  it("Should test everything", async function () {
    const Wall = await ethers.getContractFactory("Wall");
    const wall = await Wall.deploy();
    await wall.deployed();

    const accounts = await ethers.getSigners();
    const owner = accounts[0];

    await wall.safeMint(owner.address);
    console.log(await wall.balanceOf(owner.address));

    let tx = await (await wall.write("0x932f3c1b56257ce8539ac269d7aab42550dacf8818d075f0bdf1990562aae3ef")).wait();

    //console.log(tx);

    await wall.setFeesEnabled(true);
    await wall.setFee(10000);
    console.log(await owner.getBalance());
    tx = await (await wall.write("0x932f3c1b56257ce8539ac269d7aab42550dacf8818d075f0bdf1990562aae3ef",{value:ethers.utils.parseUnits("10")})).wait();
    //console.log(tx);

    console.log(await owner.getBalance());

    await wall.collectFees();

    console.log(await owner.getBalance());

    console.log(await wall.tokenURI(1));

    await wall.setBaseURI('mywebsite.com/');

    console.log(await wall.tokenURI(1));

  });
});
