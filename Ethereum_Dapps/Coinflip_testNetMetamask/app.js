(function (Contract) {
    var web3_instance;
    var instance;
    var accounts;

    function init(cb) {
        web3_instance = new Web3(
            (window.web3 && window.web3.currentProvider) ||
            new Web3.providers.HttpProvider(Contract.endpoint));

        accounts = web3.eth.accounts;
        var contract_interface = web3_instance.eth.contract(Contract.abi);
        instance = contract_interface.at(Contract.address);
        cb();
    }

    function getBalance() {
        instance.getBalance(function (error, result) {
            if(error){
                alert("error");
            } else {
                $("#balance").html(result.toString());
            }
        });
    }

    function waitForReceipt(txHash, cb){
        web3_instance.eth.getTransactionReceipt(txHash, function(error, receipt){
            if(error){
                alert(error);
            } 
            else if (receipt !== null){
                cb(receipt);
            } 
            //we havent got neither an error nor receipt - means transaction hasn't been send yet
            //so I call wait for receipt again recursively
            else {
                window.setTimeout(function(){
                    waitForReceipt(txHash, cb);
                })
            }
        });
    }

    function getResult(){
        instance.getLastFlip(accounts[0], function(error, result){
            if(result){
                //I WON;
                $("#result").html("You WON!!");
            } else {
                //I LOST
                $("#result").html("You LOST!!");
            }
        });
    }

    function flip(){
        let val = $("#bet").val();
        //accounts[0] is my address
        instance.flip.sendTransaction({from:accounts[0],gas:100000, value: val}, function(error, txHash){
            if(error){
                alert("Error during transaction");
            } else {
                //this will take a while because transaction needs to be confirmed (therefore is waitForReceipt fcn recursive)
                waitForReceipt(txHash, function(receipt){
                    if (receipt.status === "0x1"){
                        getResult();
                        getBalance();
                    }
                });
            }
        });
    }

    $(document).ready(function () {
        init(function () {
            getBalance();
        });

        $("#submit").click(function(){
            flip();
        })
    });
})(Contracts['Coinflip']);
