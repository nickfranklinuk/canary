// Base class for contracts that are used in a doug system.
contract TlcEnabled {
    address TLC;

    function setTlcAddress(address tlcAddr) returns (bool result){
        // Once the tlc address is set, don't allow it to be set again, except by the
        // Tlc contract itself.
        if(TLC != 0x0 && msg.sender != TLC){
            return false;
        }
        TLC = tlcAddr;
        return true;
    }

    // Makes it so that Tlc is the only contract that may kill it.
    function remove(){
        if(msg.sender == TLC){
            suicide(TLC);
        }
    }

}

// Base class for contracts that only allow the aviary to call them.
// Note that it inherits from TlcEnabled
contract AviaryEnabled is TlcEnabled {

    // Makes it easier to check that fundmanager is the caller.
    function isAviary() constant returns (bool) {
        if(TLC != 0x0){
            address fm = ContractProvider(TLC).contracts("aviary");
            return msg.sender == fm;
        }
        return false;
    }
}

// Interface for getting contracts from Tlc
contract ContractProvider {
    function contracts(bytes32 name) returns (address addr) {}
}

contract Base {

}