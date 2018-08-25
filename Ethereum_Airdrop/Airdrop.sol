pragma solidity ^0.4.16;

interface KarmaToken{
    function transferFrom(address from, address to, uint tokens);
}

contract Airdrop {
    
    KarmaToken public token;
    address tokenHolder;
    uint amountToTransfer;
    
    function Airdrop (address addressOfToken, address addressOfHolder, uint fixedAmount){
        token = KarmaToken(addressOfToken);
        tokenHolder = addressOfHolder;
        amountToTransfer = fixedAmount;
    }
    
    function drop() public{
        token.transferFrom(tokenHolder, msg.sender, amountToTransfer);
    }
}
