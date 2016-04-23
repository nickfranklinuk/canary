import "Base.sol";
import "PermissionsDb.sol";
// Permissions
contract Permissions is AviaryEnabled {

    // Set the permissions of an account.
    function setPermission(address addr, uint8 perm) returns (bool res) {
        if (!isAviary()){
            return false;
        }
        address permdb = ContractProvider(TLC).contracts("permsdb");
        if ( permdb == 0x0 ) {
            return false;
        }
        return PermissionsDb(permdb).setPermission(addr, perm);
    }

}