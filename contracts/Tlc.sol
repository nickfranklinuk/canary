import "Base.sol";
// Keep track of all contracts/components of the system, handle communication
// between these components, and make modular design easier.
// https://docs.erisindustries.com/tutorials/solidity/solidity-1/#tocAnchor-1-9-2

// Top Level CMC (Contract Managing Contract)
contract Tlc {

    address owner;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    // Constructor
    function Tlc(){
        owner = msg.sender;
    }

    // Add a new contract to Doug. This will overwrite an existing contract.
    function addContract(bytes32 name, address addr) returns (bool result) {
        if(msg.sender != owner){
            return false;
        }
        TlcEnabled te = TlcEnabled(addr);
        // Don't add the contract if this does not work.
        if(!te.setTlcAddress(address(this))) {
            return false;
        }
        contracts[name] = addr;
        return true;
    }

    function getContract(bytes32 name) constant returns (address addr) {
        return contracts[name];
    }

    // Remove a contract from Doug. We could also suicide if we want to.
    function removeContract(bytes32 name) returns (bool result) {
        if (contracts[name] == 0x0){
            return false;
        }
        if(msg.sender != owner){
            return;
        }
        contracts[name] = 0x0;
        return true;
    }

    function remove(){

        if(msg.sender == owner){

            address av = contracts["aviary"];
            address perms = contracts["perms"];
            address permsdb = contracts["permsdb"];
            address canary = contracts["canary"];
            address canarydb = contracts["canarydb"];

            // Remove everything.
            if(av != 0x0){ TlcEnabled(av).remove(); }
            if(perms != 0x0){ TlcEnabled(perms).remove(); }
            if(permsdb != 0x0){ TlcEnabled(permsdb).remove(); }
            if(canary != 0x0){ TlcEnabled(canary).remove(); }
            if(canarydb != 0x0){ TlcEnabled(canarydb).remove(); }

            // Finally, remove doug. Doug will now have all the funds of the other contracts,
            // and when suiciding it will all go to the owner.
            suicide(owner);
        }
    }

}
