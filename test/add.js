const { expect } = require("chai")

describe("Add", function () {
    it("should return the sum of two numbers", async function () {
        const addFactory = await ethers.getContractFactory("Add");
        const add = await addFactory.deploy();

        const result = await add.add(2023, 2024);
        expect(result).to.equal(4047);
    })
})
