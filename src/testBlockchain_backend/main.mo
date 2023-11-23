import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Debug "mo:base/Debug";

actor certification {

  private stable var registeredEntries : [(Principal, User)] = [];

  // private stable var savedList : [Principal] = [];

  type HashMap<K, V> = HashMap.HashMap<K, V>;

  stable var registedOnesList : List.List<Principal> = List.nil<Principal>();

  var registedUsersHashmap : HashMap<Principal, User> = HashMap.HashMap<Principal, User>(5, Principal.equal, Principal.hash);

  let certificateHolders : HashMap<Principal, Certification> = HashMap.HashMap<Principal, Certification>(5, Principal.equal, Principal.hash);

  // Registeration
  type User = {
    name : Text;
    isRegistered : Bool;
  };

  type Certification = {
    name : Text;
    issueTimestamp : Int;
    isRevoked : Bool;
  };

  public shared (msg) func registerUser(namee : Text) : async Text {

    let obj : User = { name = namee; isRegistered = true };

    let userId : Principal = msg.caller;

    var iter = Iter.fromList(registedOnesList);

    for (user in iter) {
      if (user == userId) {
        return "you are already registered buddy!";
      };
    };

    registedOnesList := Iter.toList(iter);

    registedUsersHashmap.put(userId, obj);
    registedOnesList := List.push(userId, registedOnesList);

    return "success registering!!";

  };

  public func getCertificate(address : Principal) : async Text {

    var iter = Iter.fromList(registedOnesList);
    var userFound : Bool = false;

    let certiName : Text = "Blockchain Panjab Certificate";

    for (user in iter) {
      if (user == address) {

        let obj : Certification = {
          name = certiName;
          issueTimestamp = Time.now();
          isRevoked = false;
        };

        certificateHolders.put(address, obj);

        Debug.print(certiName # "Certificate has been issued!");
        userFound := true;
        // return "you are already registered buddy!";
      } 
    };

    if(userFound == false){
      return "user has not registered himself";
    };

    registedOnesList := Iter.toList(iter);

    return "Certificate has been issued!";

  };

  public shared(msg) func getId(): async Principal{
    return msg.caller;
  };

  public query func getUsers() : async List.List<Principal> {
    return registedOnesList;
  };

  system func preupgrade() {
    registeredEntries := Iter.toArray(registedUsersHashmap.entries());
  };

  system func postupgrade() {

    registedUsersHashmap := HashMap.fromIter<Principal, User>(registeredEntries.vals(), 1, Principal.equal, Principal.hash);


      
    // if (balances.size() < 1) {
    //   balances.put(owner, totalSupply);
    // };
  };

};