pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Elevator} from "../src/11-elevator.sol";

// interfact is not contract, contract can have another logci
contract Elevator11Test is Test {
    Elevator elev;
    Building bld;

    function setUp() public {
        emit log_string("🧪 Setup ElevatorTest...");
        elev = new Elevator();
        bld = new Building(address(elev));
    }

    function testElevator() public {
        emit log_string("🧪 Cracking Elevator...");

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob);
        bld.goto(15);
        emit log_named_uint("Floor is:", elev.floor());
        emit log_named_string("Top or not:", elev.top() ? "true" : "false");
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

contract Building {
    bool public flip;
    address public addr;

    constructor(address _addr) public {
        flip = false;
        addr = _addr;
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        if (flip == false) {
            flip = true;
            return false;
        } else {
            flip = false;
            return true;
        }
    }

    function goto(uint256 _floor) public {
        IElevator(addr).goTo(_floor);
    }
}

interface IElevator {
    function goTo(uint256 _floor) external;
}
