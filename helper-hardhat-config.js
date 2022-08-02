const networkConfig = {
    default: {
        name: "hardhat",
        interval: "30",
    },
    4: {
        name: "rinkeby",
        vrfCoordinator:"0x6168499c0cFfCaCD319c818142124B7A15E857ab",
        entranceFees:  "100000000000000",
        subscriptionId: "7660",
        gasLane:  "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", //keyhash
        interval: "30",
        callbackGasLimit: "5000000", 
    },
    31337: {
        name : "locahost",
        entranceFees:  "100000000000000",
        gasLane:  "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", //keyhash
        interval: "30",
        callbackGasLimit: "5000000", 

    }
}

const developmentChains = ["hardhat", "localhost"];

module.exports = {
    networkConfig,
    developmentChains
}