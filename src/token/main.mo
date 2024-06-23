import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    Debug.print("Token Actor is running");
    let owner : Principal = Principal.fromText("xnsp4-lzlwf-ulvqi-tfqhd-fumq6-4wl4u-mduwo-kcbos-arwmb-po32o-kae");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "KASH";

    private stable var balanceEntries : [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); // this is a map of all account balances. The key is the account holder's principal and the value is the balance. The initial balance of the owner is set to the total supply.

    if (balances.size() < 1) {

        balances.put(owner, totalSupply);
    };

    // This function allows the owner to transfer tokens to another account. The owner's balance is reduced by the amount transferred and the recipient's balance is increased by the same amount.
    public query func balanceOf(who : Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    // Thi functin allows users to see the symbol of the token
    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared (msg) func payOut() : async Text {
        // This function pays out the owner of the contract
        Debug.print(debug_show (msg.caller));
        if (balances.get(msg.caller) == null) {

            let amount = 10000;
            let result = await transfer(msg.caller, amount);
            return result;
        } else {
            return "already Claimed";
        };
    };

    // This function allows the owner to transfer tokens to another account. The owner's balance is reduced by the amount transferred and the recipient's balance is increased by the same amount.
    public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
        let fromBlance = await balanceOf(msg.caller);
        if (fromBlance > amount) {
            let newFromBalance : Nat = fromBlance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await balanceOf(to);
            let newToBalance : Nat = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success";

        } else {
            return "Insufficient Balance";
        };

    };
    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);

        if (balances.size() < 1) {

            balances.put(owner, totalSupply);
        };
    };

};
