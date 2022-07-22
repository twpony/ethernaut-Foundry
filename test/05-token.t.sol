pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Token} from "../src/05-token.sol";

contract Token05Test is Test {
    Token token;

    function setUp() public {
        emit log_string("🧪 Setup TokenTest...");
    }

    function testToken() public {
        emit log_string("🧪 Cracking Token...");
        address bob = mkaddr("bob");
        vm.startPrank(bob);
        token = new Token(20);
        emit log_named_uint("Balance is: ", token.balanceOf(address(bob)));
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        token.transfer(alice, 21);
        vm.stopPrank();
        emit log_named_uint("Balance is: ", token.balanceOf(address(bob)));
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
