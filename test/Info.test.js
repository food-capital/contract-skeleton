const { expect } = require('chai');

// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const FoodCapital = artifacts.require('FoodCapital');

// Start test block
contract('Info', function ([ owner, other ]) {

    beforeEach(async function () {
        this.box = await FoodCapital.new({ from: owner });
    });

    // Test case
    it('Name should be FoodCapital', async function () {
        expect(await this.box.name()).to.equal('FoodCapital');
    });

    it('Symbol should be FC', async function () {
        expect(await this.box.symbol()).to.equal('FC');
    })
});