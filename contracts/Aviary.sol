import "Base.sol";
import "Canary.sol";
import "Permissions.sol";
import "PermissionsDb.sol";

// The fund manager
contract Aviary is TlcEnabled {

    // We still want an owner.
    address owner;

    // Constructor
    function Aviary(){
        owner = msg.sender;
    }

    // Attempt to create a canary of the specified type
    // with the specified initial balance.
    function create(uint canaryType) returns (bool res){
        if (msg.value == 0){
            // TODO: this means a canary can't have an initial value of
            // zero, is this what we want?
            return false;
        }
        address canary = ContractProvider(TLC).contracts("aviary");
        address permsdb = ContractProvider(TLC).contracts("permsdb");

        if ( canary == 0x0 || permsdb == 0x0 || PermissionsDb(permsdb).perms(msg.sender) < 1) {
            // If the user sent money, we should return it if we can't deposit.
            msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the canary contract. We pass msg.value along as well.
        bool success = Canary(canary).create.value(msg.value)(msg.sender, canaryType);

        // If the transaction failed, return the Ether to the caller.
        if (!success) {
            msg.sender.send(msg.value);
        }
        return success;

    }

    // Attempt to withdraw the given 'amount' of Ether from the account.
    function withdraw(uint amount) returns (bool res) {
        if (amount == 0){
            return false;
        }
        address canary = ContractProvider(TLC).contracts("canary");
        address permsdb = ContractProvider(TLC).contracts("permsdb");
        if ( canary == 0x0 || permsdb == 0x0 || PermissionsDb(permsdb).perms(msg.sender) < 1) {
            // If the user sent money, we should return it if we can't deposit.
            msg.sender.send(msg.value);
            return false;
        }

        // Use the interface to call on the canary contract.
        bool success = Canary(canary).withdraw(msg.sender, amount);

        // If the transaction succeeded, pass the Ether on to the caller.
        if (success) {
            msg.sender.send(amount);
        }
        return success;
    }

    // Set the permissions for a given address.
    function setPermission(address addr, uint8 permLvl) returns (bool res) {
        if (msg.sender != owner){
            return false;
        }
        address perms = ContractProvider(TLC).contracts("perms");
        if ( perms == 0x0 ) {
            return false;
        }
        return Permissions(perms).setPermission(addr,permLvl);
    }

}