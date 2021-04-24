import Realm
import RealmSwift

@objcMembers
class User: Object, DatabaseObject {
    
    static var counter = 0
    
    dynamic var userId : Int!
    dynamic var login : String!
    dynamic var password: String!
    
    dynamic var runs: Array<RunEntity>!
    
    convenience init(login: String, password: String, runs: Array<RunEntity>){
        self.init()
        self.userId = Self.counter
        self.login = login
        self.password = password
        self.runs = runs
        Self.counter = Self.counter + 1
    }
}
