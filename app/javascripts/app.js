var accounts;
var account;
var balance;

function setStatus(message) {
  var status = document.getElementById("status");
  status.innerHTML = message;
};

function getContract() {
  var name = document.getElementById("name").value;
  var tlc = Tlc.deployed();

  tlc.getContract(name, {from: account}).then(function(value) {
    var balance_element = document.getElementById("registered");
    balance_element.innerHTML = value;
    console.log(name);
    console.log(value);
  }).catch(function(e) {
    console.log(e);
    setStatus("Error getting contract; see log.");
  });
};

function registerContract(name, address) {
  var tlc = Tlc.deployed();

  setStatus("Initiating transaction... (please wait)");

  tlc.addContract(name, address, {from: account}).then(function(tx_id) {
    setStatus(tx_id);
    console.log(name)
    console.log(address)
    console.log(tx_id)
  }).catch(function(e) {
    console.log(e);
    setStatus("Error sending registering contract; see log.");
  });
};

function registerContracts() {
    var aviary = document.getElementById("aviary").value;
    var perms = document.getElementById("perms").value;
    var permsdb = document.getElementById("permsdb").value;
    var canary = document.getElementById("canary").value;
    var canarydb = document.getElementById("canarydb").value;
    registerContract('aviary', aviary);
    registerContract('perms', perms);
    registerContract('permsdb', permsdb);
    registerContract('canary', canary);
    registerContract('canarydb', canarydb)
}

window.onload = function() {
  web3.eth.getAccounts(function(err, accs) {
    if (err != null) {
      alert("There was an error fetching your accounts.");
      return;
    }

    if (accs.length == 0) {
      alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
      return;
    }

    accounts = accs;
    account = accounts[0];
  });
}
