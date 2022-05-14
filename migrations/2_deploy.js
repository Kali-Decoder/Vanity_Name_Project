const Vanity = artifacts.require("Vanity");

module.exports= function(deployer,accounts){
    console.log("Accounts:",accounts);
    deployer.deploy(Vanity);
}