// SPDX-License-Identifier: UNLICENSE-2.0
pragma solidity ^0.8.24;

contract RecurringLottery {
    struct Entry {
        address payable buyerAddress;
        uint256 quantity;
    }
    struct Round {
        uint256 quantity;
        address winner;
        Entry[] entries;
        uint8 buyersCount;
        uint256 balance;
    }

    mapping(uint256 => Round) rounds;
    uint256 public currentRound;
    uint public constant TICKET_PRICE = 1 ether;

    constructor() {
        currentRound = 0;
        rounds[currentRound].buyersCount = 10;
    }

    function drawwinner() public payable {
        if (
            rounds[currentRound].buyersCount ==
            rounds[currentRound].entries.length &&
            rounds[currentRound].winner == address(0)
        ) {
            bytes32 rand = keccak256(
                abi.encodePacked(blockhash(block.number - 1))
            );
            Entry memory winner = rounds[currentRound].entries[
                uint256(rand) % rounds[currentRound].entries.length
            ];
            rounds[currentRound].winner = winner.buyerAddress;
            winner.buyerAddress.transfer(rounds[currentRound].balance);
            currentRound += 1;
            rounds[currentRound].buyersCount = 10;
        }
    }

    function buy() public payable {
        drawwinner();
        require(msg.value % TICKET_PRICE == 0);
        uint256 _quantity = msg.value / TICKET_PRICE;
        rounds[currentRound].entries.push(
            Entry(payable(msg.sender), _quantity)
        );
        rounds[currentRound].buyersCount += 1;
        rounds[currentRound].quantity += _quantity;
        rounds[currentRound].balance += msg.value;
        drawwinner();
    }

    fallback() external {
        buy();
    }
}
