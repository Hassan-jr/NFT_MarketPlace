const networkConfig = {
    default: {
        name: "hardhat", 
    },
    4: {
        name: "rinkeby",
    },
    31337: {
        name : "locahost",
    }
}

const developmentChains = ["hardhat", "localhost"];

module.exports = {
    networkConfig,
    developmentChains
}