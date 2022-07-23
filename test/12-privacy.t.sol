pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Privacy} from "../src/12-privacy.sol";

// interfact is not contract, contract can have another logci
contract Privacy12Test is Test {
    Privacy pry;

    function setUp() public {
        emit log_string("🧪 Setup Privacy Test...");
        bytes32[3] memory pdata = [
            keccak256(abi.encodePacked("privacyA")),
            keccak256(abi.encodePacked("privacyB")),
            keccak256(abi.encodePacked("privacyC"))
        ];
        pry = new Privacy(pdata);
    }

    function testPrivacy() public {
        emit log_string("🧪 Cracking Privacy...");

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob);

        bytes32 key = vm.load(address(pry), bytes32(uint256(5)));

        pry.unlock(bytes16(key));
        emit log_named_string(
            "Locked or not:",
            pry.locked() ? "true" : "false"
        );
        emit log_named_bytes32(
            "data[2] is:",
            keccak256(abi.encodePacked("privacyC"))
        );
        emit log_named_bytes32("Key is: ", bytes32(bytes16(key)));
        vm.stopPrank();
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
