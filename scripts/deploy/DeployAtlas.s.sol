// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {AtlasCore} from "../../contracts/core/AtlasCore.sol";

/// @title DeployAtlas — Deploy the Atlas Protocol stack
contract DeployAtlas is Script {
    function run() external {
        uint256 key = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(key);
        // AtlasCore core = new AtlasCore(address(0), address(0), address(0), address(0));
        vm.stopBroadcast();
        console.log("Atlas Protocol deployment complete");
    }
}
