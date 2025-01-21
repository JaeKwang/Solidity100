const {buildModule} = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule('Token_A', (m) => {
    const con = m.contract("TOKENA");
    return {con};
})
