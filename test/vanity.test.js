const Vanity = artifacts.require("Vanity");
let vanityContract;
let x;
contract("Testing Vanity Smart Contract ...", (accounts) => {
  beforeEach(async () => {
    vanityContract = await Vanity.deployed();
  });

  it("Should give admin address ", async () => {
    let admin = await vanityContract.admin();
    console.log("Contract Address :", vanityContract.address);
    assert.equal(admin, accounts[0]);
  });
  it("Should calculate amount of name ", async () => {
    x = await vanityContract.getPrice("Neeraj");
    
    // assert.equal(x.toNumber(),);
    console.log(x);
  });

  it("user should resgister there name ", async () => {
    let title = "Neeraj";
    const tx = await vanityContract.registerYourName(title, {
      from: accounts[2],
      value: x,
      gas: "1000000",
    });
    const y = await vanityContract.stringToOwner(title);
    assert.equal(accounts[2], y);
  });
  it("Should give total number of vanities ", async () => {
    let y = await vanityContract.numberOfVanity();
    assert.equal(y.toNumber(), 1);
  });

  it("Should check vanity is valid ", async () => {
    let isValid = await vanityContract.vanityIsValid(1);
    assert.equal(isValid, true);
  });
  it("Should get Vanity ", async () => {
    const tx = await vanityContract.vanities(1);
    console.log(tx);
  });
  it("Should increase time period of that time ", async () => {
      let y = await web3.utils.toWei("1","ether");
    const tx1 = await vanityContract.increaseValidity(1, 1, {
      from: accounts[2],value:y
    });
    let x= await vanityContract.getBal();

    const tx = await vanityContract.vanities(1);
    // console.log(tx);
    console.log(x);
    
  });
});
