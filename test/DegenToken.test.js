const { expect } = require("chai");

describe("ShoeToken", function () {
  let ShoeToken, shoeToken, owner, addr1, addr2;

  beforeEach(async function () {
    // Deploy a new contract instance before each test
    [owner, addr1, addr2] = await ethers.getSigners();
    ShoeToken = await ethers.getContractFactory("ShoeToken");
    shoeToken = await ShoeToken.deploy();
    await shoeToken.deployed();
  });

  it("Should deploy the contract and check initial values", async function () {
    expect(await shoeToken.name()).to.equal("ShoeToken");
    expect(await shoeToken.symbol()).to.equal("SHOE");
    expect(await shoeToken.decimals()).to.equal(18);
  });

  it("Should allow the owner to mint tokens", async function () {
    await shoeToken.mint(addr1.address, ethers.utils.parseUnits("1000", 18));
    expect(await shoeToken.balanceOf(addr1.address)).to.equal(ethers.utils.parseUnits("1000", 18));
  });

  it("Should allow users to purchase shoe items", async function () {
    await shoeToken.mint(addr1.address, ethers.utils.parseUnits("1000", 18));
    await shoeToken.connect(addr1).purchaseShoeItem(0, 2); // Buying 2 of item ID 0
    expect(await shoeToken.balanceOf(addr1.address)).to.equal(ethers.utils.parseUnits("800", 18)); // After purchase
    expect(await shoeToken.userShoeBalances(addr1.address, 0)).to.equal(2);
  });

  it("Should allow users to redeem shoe items", async function () {
    await shoeToken.mint(addr1.address, ethers.utils.parseUnits("1000", 18));
    await shoeToken.connect(addr1).purchaseShoeItem(0, 2);
    await shoeToken.connect(addr1).redeemShoeItem(0, 1); // Redeeming 1 of item ID 0
    expect(await shoeToken.balanceOf(addr1.address)).to.equal(ethers.utils.parseUnits("900", 18)); // After redeeming
    expect(await shoeToken.userShoeBalances(addr1.address, 0)).to.equal(1);
  });

  it("Should only allow the owner to add shoe items", async function () {
    await shoeToken.addShoeItem("Formal Shoes", ethers.utils.parseUnits("250", 18));
    const item = await shoeToken.shoeItems(3); // ID 3 for the new item
    expect(item.name).to.equal("Formal Shoes");
    expect(item.price).to.equal(ethers.utils.parseUnits("250", 18));
    expect(item.available).to.be.true;
  });

  it("Should allow the owner to set shoe item availability", async function () {
    await shoeToken.setShoeItemAvailability(0, false);
    const item = await shoeToken.shoeItems(0);
    expect(item.available).to.be.false;
  });
});
