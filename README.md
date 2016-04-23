Canary
------

Blockchain powered warrant canary utlizing a dead mans switch as a contract.

This is a work in progress and as such should not be used for anything even remotely resembling production use. It is expected to contain severe bugs and other issues. It is merely a thought experiment and a way for me to learn smart contract technology at this point in time. If this changes this notice will be removed and an announcement will be made.

### Version

* 0.0.1

### Requirements

* Node 5.0+
* Npm 3.8+


### Install

```
$ npm install -g truffle
```

### Mock blockchain service

It is recommended for testing that you use https://github.com/ethereumjs/testrpc

```
npm install -g ethereumjs-testrpc
testrpc --debug
```

Leave this daemon running and go onto the next steps.

### Public blockchain

Please don't deploy this on a public blockchain unless you have audited it. If you are absolutely sure you would like to proceed instructions are available at http://truffle.readthedocs.org/en/latest/getting_started/client/

### Run

Firstly let's compile and deploy our solidity contracts. Please keep the output of the 'deploy' command as we will need it for later.

```
$ truffle compile
$ truffle deploy
```

Let's start the user interface (don't forget to store the output of the above command safely!)

```
$ truffle serve
```

We can now go to http://127.0.0.1:8080 in a web browser

### Initial setup

We must register all of our contracts with the Top Level CMC (Contract Managing Contract). This only has to happen once and can only be done by the account that deployed the contracts.

### Using the application

Usage instructions go here.

### Acknowledgments

Much of this code is borrowed shamelessly from:

* https://docs.erisindustries.com/tutorials/solidity
* https://github.com/ConsenSys/truffle
* http://ethereum-alarm-clock.com

### Contributors

Please see https://github.com/nickfranklinuk/canary/contributors
