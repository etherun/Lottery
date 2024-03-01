// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// import "hardhat/console.sol";

contract Lottery {
    uint256 price = 1 ether;
    address[] public buyers;
    address public winner;
    uint256 public closeTimestamp = block.timestamp + 3600;

    function buy() public payable {
        require(block.timestamp < closeTimestamp);
        require(msg.value == price);
        buyers.push(msg.sender);
    }

    function drawWinner() public {
        require(block.timestamp > closeTimestamp + 300);
        require(winner == address(0));

        bytes32 rand = keccak256(abi.encodePacked(blockhash(block.number - 1)));
        winner = buyers[uint256(rand) % buyers.length];
    }

    function withdraw(address payable addr) public payable {
        require(addr == winner);
        addr.transfer(address(this).balance);
    }

    fallback() external {
        buy();
    }
}
