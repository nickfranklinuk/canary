import "Base.sol";
import "CanaryDb.sol";

// The Canary
contract Canary is AviaryEnabled {

    // Let's create a canary
    function create(address userAddr, uint canaryType) returns (bool res) {
        if (!isAviary()){
            return false;
        }
        address canarydb = ContractProvider(TLC).contracts("canarydb");
        if ( canarydb == 0x0 ){
            // If the user sent money, we should return it if we can't deposit.
            msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the canary contract. We pass msg.value along as well.
        bool success = CanaryDb(canarydb).create.value(msg.value)(userAddr, canaryType);

        // If the transaction failed, return the Ether to the caller.
        if (!success) {
            msg.sender.send(msg.value);
        }
        return success;
    }

    // Let's perform a single heartbeat
    function heartbeat(address userAddr) returns (bool res) {
        if (!isAviary()){
            return false;
        }
        address canarydb = ContractProvider(TLC).contracts("canarydb");
        if ( canarydb == 0x0 ) {
            // Contract not setup: canarydb
            return false;
        }
        // Use the interface to call on the canary contract. We pass msg.value along as well.
        bool success = CanaryDb(canarydb).heartbeat(userAddr);
        return success;
    }

    // Let's kill a canary
    function kill(address userAddr) returns (bool res) {
        if (!isAviary()){
            return false;
        }
        address canarydb = ContractProvider(TLC).contracts("canarydb");
        if ( canarydb == 0x0 ){
            // Contract not setup: canarydb
            return false;
        }

        // Use the interface to call on the canary contract. We pass msg.value along as well.
        bool success = CanaryDb(canarydb).kill(userAddr);
        return success;
    }

    // Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(address userAddr, uint amount) returns (bool res) {
        if (!isAviary()){
            return false;
        }
        address canarydb = ContractProvider(TLC).contracts("canarydb");
        if ( canarydb == 0x0 ){
            // Contract not setup: canarydb
            return false;
        }

        // Use the interface to call on the canary contract.
        bool success = CanaryDb(canarydb).withdraw(userAddr, amount);

        // If the transaction succeeded, pass the Ether on to the caller.
        if (success){
            userAddr.send(amount);
        }
        return success;
    }
}