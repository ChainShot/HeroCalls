//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;

contract Storage {
    address public owner;
    address public behavior;
    bool public isSuperCharged;
    bool public isInitialized;
}

// TODO: ensure the Hero can still superCharge, but can't be hacked!
contract Hero is Storage {
    constructor(address _owner, address _behavior) {
        behavior = _behavior;
        (bool success, ) = behavior.delegatecall(abi.encodeWithSignature(
            "initialize(address)", _owner
        ));

        require(success);
    }

    fallback() external {
        if(msg.data.length > 0) {
            // proxy to behavior methods
            (bool success, ) = behavior.delegatecall(msg.data);
            require(success);
        }
    }
}

contract Behavior is Storage {
    // just a constructor function 
    function initialize(address _owner) external {
        require(!isInitialized);
        isInitialized = true;
        owner = _owner;
    }

    function superCharge() external {
        isSuperCharged = true;
    }
}
