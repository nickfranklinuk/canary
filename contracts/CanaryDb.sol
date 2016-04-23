import "Base.sol";
// The canary database
contract CanaryDb is TlcEnabled {

    // When did the user last stimulate their canary?
    mapping (address => uint) public lastStimulated;
    // When was the canary birthed?
    mapping (address => uint) public aliveSince;
    // Canary types:
    // 0 : Does not die from hearbeat timeout
    // 1 - 99 : Dies of natural causes after n days of inactivity.
    // >= 100 : Not used at this time, reserved for future use.
    mapping (address => uint) public canaryTypes;
    // Canary status:
    // 0 : Created
    // 1 : Activated
    // 2 : Killed
    // 3 : Died (lack of stimulation)
    // 4 : Invalid (past valid until date)
    mapping (address => uint) public canaryStatuses;
    mapping (address => uint) public canaryBalances;
    mapping (address => uint) public canaryExpiries;

    function create(address addr, uint canaryType) returns (bool res) {
        if(TLC != 0x0){
            address canary = ContractProvider(TLC).contracts("canary");
            if (msg.sender == canary ){
                // Check we have received a valid canary type.
                if (canaryTypes[addr] < 100){
                    canaryStatuses[addr] = 0;
                    canaryTypes[addr] = canaryType;
                    canaryBalances[addr] = msg.value;
                    return true;
                }
            }
        }
        // Return if deposit cannot be made.
        msg.sender.send(msg.value);
        return false;
    }

    function birth(address addr) returns (bool res){
        if(canaryStatuses[addr] == 0){
            // Liiiiive!!!
            canaryStatuses[addr] = 1;
            aliveSince[addr] = now;
            return true;
        }
        return false;
    }

    function stimulate(address addr) returns (bool res){
        // Check if canary is alive.
        if(canaryStatuses[addr] == 1){
            // Store time of stimulation.
            lastStimulated[addr] = now;
            return true;
        }
        // You cannot stimulate that which is not alive.
        return false;
    }

    function heartbeat(address addr) returns (bool res){
        // Check if canary is alive.
        if(canaryStatuses[addr] == 1){
            // Check canary can die from lack of stimulation.
            if(canaryTypes[addr] >= 1) {
                // Death by lack of stimulation.
                canaryStatuses[addr] = 3;
                return false;
            }
            // TODO: check this code, are we using the right data type?
            if(canaryExpiries[addr] <= now){
                // Invalid / Expired canary.
                canaryStatuses[addr] = 4;
                return false;
            }

        }
        // Things that are not alive do not have a heartbeat.
        return true;
    }

    function kill(address addr) returns (bool res){
        // Check if canary is alive.
        if(canaryStatuses[addr] == 1){
            // Kill it.
            canaryStatuses[addr] = 2;
        }
        // You cannot kill that which is not alive.
        return false;
    }

    // TODO: should we be checking if the canary is killed or dead here
    // or should we do it on the Canary contract? I think this is wrong.
    function withdraw(address addr, uint amount) returns (bool res) {
        // Check if TLC has been registered.
        if(TLC != 0x0){
            // Check if canary is killed or dead.
            if(canaryStatuses[addr] >= 2){
                address canary = ContractProvider(TLC).contracts("canary");
                if (msg.sender == canary ){
                    uint oldBalance = canaryBalances[addr];
                    if(oldBalance >= amount){
                        msg.sender.send(amount);
                        canaryBalances[addr] = oldBalance - amount;
                        return true;
                    }
                }
            }
        }
        return false;
    }

}
