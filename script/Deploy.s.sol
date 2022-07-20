// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";

import {Fallback} from "src/01-fallback.sol";

/// @notice A very simple deployment script
contract Deploy is Script {
    /// @notice The main script entrypoint
    /// @return fback The deployed contract
    function run() external returns (Fallback fback) {
        vm.startBroadcast();
        fback = new Fallback();
        vm.stopBroadcast();
    }
}
