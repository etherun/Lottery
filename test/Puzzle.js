const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Puzzle", function () {
  let Puzzle;
  let owner;
  let otherAccount;

  beforeEach(async function () {
    [owner, otherAccount] = await ethers.getSigners();
    const MyContractFactory = await ethers.getContractFactory("Puzzle");
    const encodedData = ethers.AbiCoder.defaultAbiCoder().encode(
      ["uint256", "uint256"],
      [987463829, 23]
    );
    const hash = ethers.keccak256(encodedData);
    Puzzle = await MyContractFactory.deploy(hash);
    // await myContract.deployed();
  });

  describe("Commit_1", function () {
    it("should be 23", async function () {
      await Puzzle.connect(otherAccount).commit(23);
      expect(await Puzzle.closed()).to.equal(true);
    });
  });
});
