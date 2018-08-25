pragma solidity ^0.4.16;

interface KarmaToken {
    function transfer(address receiver, uint amount);
}

contract Crowdsale {

    address beneficiary;
    uint public fundingGoal;
    uint public totalAmountRaised;
    uint public crowdsaleDeadline;
    uint public tokenPrice;
    KarmaToken public token;   //reference to my KarmaToken contract
    mapping(address => uint) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdSaleClosed = false;
    
    /**
     * Constructor
     * ifSuccessfulSendTo: Address where funds should be sent if sale reaches target
     * goalInEther: What is the target goal for the crowdsale in ethers.
     * durationInMinutes: How long will the crowdsale be running.
     * tokenPriceInEther: How much does each token cost
     * addressOfToken: Where is the token contract deployed.
     */
    function Crowdsale(
        address ifSuccessfulSendTo,
        uint goalInEther,
        uint durationInMinutes,
        uint tokenPriceInEther,
        address addressOfToken
    ) {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = goalInEther;
        crowdsaleDeadline = now + durationInMinutes * 1 minutes;
        tokenPrice = tokenPriceInEther * 1 ether;
        token = KarmaToken(addressOfToken);
    }

    /**
     * Fallback function
     *
     * Default function which gets called when someone sends money to the contract. Will be used for joining sale.
     */
    function () payable {
        require(!crowdSaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        totalAmountRaised += amount;
        token.transfer(msg.sender, amount/tokenPrice);
    }

    /**
     * Modifier used to check if deadline for crowdsale has passed
     */
    modifier afterDeadline() {
        if(now > crowdsaleDeadline) {
            _;   //continue execution
        }
    }

    /**
     * Check if the funding goal was reached. Will only be checked if afterDeadline modifier above is true.
     *
     */
    function checkGoalReached() afterDeadline {
        if(totalAmountRaised >= fundingGoal) {
            fundingGoalReached = true;
        }
        crowdSaleClosed = true;
    }


    /**
     * Withdraw the funds
     *
     * Will withdraw the money after the deadline has been reached. If the goal was reached, only the owner can withdraw money to the beneficiary account.
     * If you goal was not reached, everyone who participated can withdraw their share (but they have to call this funtion?).
     */
    function safeWithdrawal() afterDeadline {
        if (fundingGoalReached){
            
        } else {
            //sending it correctly to prevent a double send attack
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if(amount > 0){
                if(!msg.sender.send(amount)) {
                    //send was not successful so I restore the balance Fallback
                    balanceOf[msg.sender] = amount;
                }
            }
            if (msg.sender == beneficiary && fundingGoalReached) {
                if(!beneficiary.send(totalAmountRaised)){
                    //if beneficiary is not able to withdraw the funds, 
                    //let's set the fundingGoalReached to false so people can get their moneey back
                    fundingGoalReached = false;
                }
            }
        }
    }
}
