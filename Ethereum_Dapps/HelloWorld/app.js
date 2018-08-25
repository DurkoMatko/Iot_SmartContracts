(function (Contract) {
    var web3;
    var instance;

    //init of the document initializes new instance of a smart contract
    function init(cb) {
        web3 = new Web3(
            (window.web3 && window.web3.currentProvider) ||
            new Web3.providers.HttpProvider(Contract.endpoint));

        var contract_interface = web3.eth.contract(Contract.abi);
        instance = contract_interface.at(Contract.address);
        cb();
    }

    function getMessage(cb) {
        instance.message(function (error, result) {
            cb(error, result);
        });
    }

    function updateMessage() {
        let newMessage = $('#message-input').val();
        if(newMessage && newMessage.length > 0){
            //setting new value in a contract means writing new data to the blockchain
            //therefore it's a TRANSACTION, so I need gas and my address which Im sending it from
            //third parameter is a callback function which is executed after transaction is send
            instance.update.sendTransaction(newMessage, {from: "0xa48f2e0be8ab5a04a5eb1f86ead1923f03a207fd", gas: 30000000}, function(error, result){
                if(error){
                    console.log("error in sendTransaction");
                }
                else{
                    //this is not 100% correct, I should actually wait for next block to be mined
                    //but here I just wait a second and then hope value is already written to the contract, then read it
                    setTimeout(function(){
                      getMessage(function(error, result){
                        if(error){
                          console.error("Could not get artice:", error);
                          return;
                        }
                        $('#message').html(result);
                      });
                    }, 1000)
                }
            });
        }
        else{
            alert("Newmessage not defined");
        }
    }

    //document init: getMessage gets the message from a contract
    $(document).ready(function () {
        init(function () {
            getMessage(function (error, result) {
                if (error) {
                    console.error("Could not get article:", error);
                    return;
                }
                $('#message').append(result);
            });
        });

        //register click handler for a button
        $("#submitButton").click(function(){
            updateMessage();
        });
    });

})(Contracts['HelloWorld']);
