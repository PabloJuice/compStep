import Realm
import RealmSwift

@objcMembers
class UserEntity: Object, DatabaseObject {
    
    static var counter = 0
    
    dynamic var userId : Int!
    dynamic var login : String!
    dynamic var password: String!
    
    //dynamic var runs: List<RunEntity>!
    
    convenience init(login: String, password: String){
        self.init()
        self.userId = Self.counter
        self.login = login
        self.password = password
        //self.runs.append(objectsIn: runs)
        Self.counter = Self.counter + 1
    }
    
    func equals(object: UserEntity) -> Bool {
        return self.userId == object.userId
    }
}
