(function (Contract) {
    var web3;
    var instance;

    function init(cb) {
        web3 = new Web3(
            (window.web3 && window.web3.currentProvider) ||
            new Web3.providers.HttpProvider(Contract.endpoint));

        var contract_interface = web3.eth.contract(Contract.abi);
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
        web3.eth.getTransactionReceipt(txHash, function(error, receipt){
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

    function flip(){
        let val = $("bet").val();
        instance.flip.sendTransaction({from:"0xa48f2e0be8ab5a04a5eb1f86ead1923f03a207fd",gas:100000, value: val}, function(error, txHash){
            if(error){
                alert("Error during transaction");
            } else {
                //this will take a while because transaction needs to be confirmed (therefore is waitForReceipt fcn recursive)
                waitForReceipt(txHash, function(receipt){
                    if (receipt.status === "0x1"){
                        
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
