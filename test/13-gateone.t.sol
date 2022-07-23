pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {GatekeeperOne} from "../src/13-gateone.sol";

contract Gateone13Test is Test {
    GatekeeperOne gkone;
    GateCrackOne gcrack;

    function setUp() public {
        emit log_string("🧪 Setup Gateone Test...");
        gkone = new GatekeeperOne();
        gcrack = new GateCrackOne(address(gkone));
    }

    function testGateOne() public {
        emit log_string("🧪 Cracking Gateone ...");

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob, bob);
        payable(gcrack).call.value(1 ether)("");

        bytes8 key = bytes8(uint64(address(bob)));
        bytes8 mask = 0xFFFFFFFF0000FFFF;
        key = key & mask;
        // gasnum cannot give too small
        uint256 gasnum = 8191 * 100;
        uint256 count = gcrack.callGateone.gas(8900 * 1000)(key, gasnum);

        vm.stopPrank();
        emit log_named_address("Entrant Address is:", gkone.entrant());
        emit log_named_uint("Count is:", count);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}

contract GateCrackOne is Test {
    address public addr;

    constructor(address _addr) public {
        addr = _addr;
    }

    function callGateone(bytes8 _bt, uint256 gasnum) public returns (uint256) {
        // this num is got by last failure test
        bool success;
        bytes memory data;
        uint256 count;
        for (count = 0; count < 8191; count++) {
            try IGatekeeperOne(addr).enter.gas(gasnum + count)(_bt) {
                break;
            } catch {}

            // (success, data) = address(addr).call.gas(gasnum + count)(
            //     abi.encodeWithSignature("enter(bytes8)", _bt)
            // );

            // if (success) {
            //     break;
            // }
        }
        return count;
    }

    receive() external payable {}
}

interface IGatekeeperOne {
    function enter(bytes8) external returns (bool);
}
