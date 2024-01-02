// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

// 拍卖合约
// 如果产生新的最高出价，则之前的最高出价者将可以回收它们的 token
// 投标期结束后，必须手动调用合约才能让受益人收到他们的 token，合约无法自动调用
contract SimpleAuction {
  address payable public beneficiary;
  uint public auctionEndTime;

  // 当前拍卖状态
  address public highestBidder; // 最高出价者
  uint public highestBid; // 最高出价

  // 记录需要被返回的 token 以及地址
  mapping(address => uint) pendingReturns;

  // 拍卖是否已结束，默认为 false。结束时设置为 true
  bool ended;

  // events
  event HighestBidIncreased(address bidder, uint amount);
  event AuctionEnded(address winner, uint amount);

  // errors
  error AuctionAlreadyEnded(); // 拍卖已结束
  error BidNotHighEnough(uint highestBid); // 已有更高或相等的出价
  error AuctionNotYestEnded(); // 拍卖尚未结束
  error AuctionEndAlreadyCalled(); // 拍卖结束的函数已被调用

  // 构造函数，设置出价时间、收款人地址
  constructor(uint biddingTime, address payable beneficiaryAddress) {
    beneficiary = beneficiaryAddress;
    auctionEndTime = block.timestamp + biddingTime;
  }

  function bid() external payable {
    // 检查拍卖是否已结束
    if (block.timestamp > auctionEndTime) {
      revert AuctionAlreadyEnded();
    }
    // 检查出价
    if (msg.value <= highestBid) {
      revert BidNotHighEnough(highestBid);
    }
    // 产生了新的最高出价，之前最高出价人的出价可以被退回
    if (highestBid != 0) {
      pendingReturns[highestBidder] += highestBid;
    }
    // 更新最高出价信息，并发送事件
    highestBidder = msg.sender;
    highestBid = msg.value;
    emit HighestBidIncreased(msg.sender, msg.value);
  }

  // 撤回已经无效的出价（需要出价人手动调用）
  function withdraw() external returns (bool) {
    uint amount = pendingReturns[msg.sender];
    if (amount > 0) {
      // 这里必须先设置为 0，因为接受者可以在下面 send 返回之前再次调用此函数作为接收调用的一部分
      pendingReturns[msg.sender] = 0;
      if (!payable(msg.sender).send(amount)) {
        // 失败后并不需要 throw，重置金额，让它重试即可
        pendingReturns[msg.sender] = amount;
        return false;
      }
    }
    return true;
  }

  // 拍卖结束
  function auctionEnd() external {
    if (block.timestamp < auctionEndTime)
      revert AuctionNotYestEnded();
    if (ended)
      revert AuctionEndAlreadyCalled();
    ended = true;
    emit AuctionEnded(highestBidder, highestBid);
    beneficiary.transfer(highestBid);
  }
}