const Vanity = artifacts.require("Vanity");
let vanityContract;
let x;
contract("Testing Vanity Smart Contract ...",(accounts)=>{
    beforeEach(async ()=>{
        vanityContract= await Vanity.deployed();
        
    });

    it('Should give admin address ',async ()=>{
        let admin = await vanityContract.admin();
        console.log("Contract Address :",vanityContract.address);
        assert.equal(admin,accounts[0]);
    });
    it("Should calculate amount of name ",async ()=>{
        x= await vanityContract.getPrice("Neeraj Choubisa");
        assert.equal(x.toNumber(),20000);
    });
    
    it("user should resgister there name ",async ()=>{
        let title= "Neeraj Choubisa"
        const tx = await vanityContract.registerYourName(title,{from:accounts[2],value:x,gas:'1000000'});
        const y= await vanityContract.stringToOwner(title);
        assert.equal(accounts[2],y);

    });
    it("Should give total number of vanities ",async()=>{
        let y= await vanityContract.numberOfVanity();
        assert.equal(y.toNumber(),1);
    });

    it("Should check vanity is valid ",async ()=>{
        let  isValid = await vanityContract.vanityIsValid(1);
       assert.equal(isValid,true);
    });
    it("Should increase time period of that time ",async ()=>{
        let tx = await vanityContract.extendTime(1,4,{from:accounts[2],value:'4000',gas:'1000000'});// 4 times i have to increase the time so 4 * 30 * 60 = 2700 seconds increase 
        console.log(tx);

    })
})