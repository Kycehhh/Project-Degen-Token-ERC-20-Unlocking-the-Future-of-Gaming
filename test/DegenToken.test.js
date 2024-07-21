const { expect } = require("chai");

describe("DegenToken", function () {
  let DegenToken, degenToken, owner, addr1, addr2;

  beforeEach(async function () {
    // Deploy a new contract instance before each test
    [owner, addr1, addr2] = await ethers.getSigners();
    DegenToken = await ethers.getContractFactory("DegenToken");
    degenToken = await DegenToken.deploy();
    await degenToken.deployed();
  });

  it("Should deploy the contract and check initial values", async function () {
    expect(await degenToken.name()).to.equal("Degen");
    expect(await degenToken.symbol()).to.equal("DGN");
    expect(await degenToken.decimals()).to.equal(0);
  });

  it("Should allow the owner to mint tokens", async function () {
    await degenToken.mint(addr1.address, 1000);
    expect(await degenToken.balanceOf(addr1.address)).to.equal(1000);
  });

  it("Should allow users to buy clothing items", async function () {
    await degenToken.mint(addr1.address, 1000);
    await degenToken.connect(addr1).buyClothingItem(0, 2); // Buying 2 of item ID 0
    expect(await degenToken.balanceOf(addr1.address)).to.equal(800); // After purchase
    expect(await degenToken.getUserClothingBalance(addr1.address, 0)).to.equal(2);
  });

  it("Should allow users to redeem clothing items", async function () {
    await degenToken.mint(addr1.address, 1000);
    await degenToken.connect(addr1).buyClothingItem(0, 2);
    await degenToken.connect(addr1).redeemClothingItem(0, 1); // Redeeming 1 of item ID 0
    expect(await degenToken.balanceOf(addr1.address)).to.equal(900); // After redeeming
    expect(await degenToken.getUserClothingBalance(addr1.address, 0)).to.equal(1);
  });

  it("Should only allow the owner to add clothing items", async function () {
    await degenToken.addClothingItem("Virtual Jacket", 250);
    const item = await degenToken.getClothingItem(3); // ID 3 for the new item
    expect(item[0]).to.equal("Virtual Jacket");
    expect(item[1]).to.equal(250);
    expect(item[2]).to.be.true;
  });

  it("Should allow the owner to set clothing item availability", async function () {
    await degenToken.setClothingItemAvailability(0, false);
    const item = await degenToken.getClothingItem(0);
    expect(item[2]).to.be.false;
  });
});
