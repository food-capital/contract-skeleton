const { expect } = require('chai');

// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const FoodCapital = artifacts.require('FoodCapital');

// Start test block
contract('WaitingList', function ([ owner, other ]) {
    beforeEach(async function () {
        this.box = await FoodCapital.new({ from: owner });
    });

    // Test case
    it('Owner should add waiting list', async function () {
        await this.box.addToWaitingList(other, { from: owner });
        expect(await this.box.hasWaitingList(other)).to.equal(true);
    });

    it('Owner should remove waiting list', async function () {
        await this.box.addToWaitingList(other, { from: owner });
        await this.box.removeFromWaitingList(other, { from: owner });
        expect(await this.box.hasWaitingList(other)).to.equal(false);
    });

    it('Other should not add waiting list', async function () {
        await expectRevert(
            this.box.addToWaitingList(other, { from: other }),
            'Ownable: caller is not the owner'
        );

        expect(await this.box.hasWaitingList(other)).to.equal(false);
    });

    it('Other should not remove waiting list', async function () {
        await expectRevert(
            this.box.removeFromWaitingList(other, { from: other }),
            'Ownable: caller is not the owner'
        );

        expect(await this.box.hasWaitingList(other)).to.equal(false);
    });

    it('Owner should use safe mint for waiting list', async function () {
        const tokenURI = 'https://example.com';
        const tokenId = new BN(1);

        await this.box.addToWaitingList(other, { from: owner });
        await this.box.safeMint(other, tokenId, tokenURI, { from: owner });

        expect(await this.box.ownerOf(tokenId)).to.equal(other);
    });
});