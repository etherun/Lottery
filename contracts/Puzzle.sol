// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Puzzle {
    uint256 internal salt = 987463829;
    bytes32 internal answerHash;
    bool public closed = false;

    constructor(bytes32 _answerHash) {
        answerHash = _answerHash;
    }

    modifier puzzleNotClosed() {
        require(closed == false, "Puzzle already closed");
        _;
    }

    function commit(uint256 answer) public payable puzzleNotClosed {
        require(
            keccak256(abi.encode(salt, answer)) == answerHash,
            "Answer not right"
        );
        closed = true;
        payable(msg.sender).transfer(address(this).balance);
    }
}
