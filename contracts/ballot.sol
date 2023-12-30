// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// 选票
contract Ballot {
    struct Voter {
        uint weight; // 权重
        bool voted; // 该选民是否已经投票了
        address delegate; // 被委托给的人
        uint vote; // 已投票的提案 index
    }
    struct Proposal {
        bytes32 name; // 某个具体提案的名称（长度最大为 32bytes）
        uint voteCount; // 累积的票数
    }
    address public chairperson; // 主席

    mapping(address => Voter) public voters;

    // 动态长度的数组
    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            // Proposal({}) 创建一个临时的 Proposal 对象
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    // 赋予给定地址的选民投票的权利
    function giveRightToVote(address voter) external {
        // 只能由主席调用该函数
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    // 将自己的投票委托给投票者 to
    function delegate(address to) external {
        // 分配引用
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        // 检测委托链是否存在循环
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegaation.");
        }

        Voter storage delegate_ = voters[to];
        // to 必须有投票的权重
        require(delegate_.weight >= 1);

        // 由于 sender 是一个引用，因此这些会修改 voters[msg.sender]
        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // to 已投票，则在提案的累积票数上添加当前委托人的权重
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // to 还未投票，则在 to 的权重上添加当前委托人的权重
            delegate_.weight += sender.weight;
        }
    }

    // 投票给 proposal
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote.");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // 如果该提案不在数组中，则会自动 revert 所有的改动
        proposals[proposal].voteCount += sender.weight;
    }

    // 计算获胜的提案
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
