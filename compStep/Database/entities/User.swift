import Realm
import RealmSwift

@objcMembers
class UserEntity: Object, DatabaseObject {
    
    static var counter :Int = 1
    
    dynamic var userId = RealmOptional<Int>(0)
    dynamic var login : String!
    dynamic var password: String!
    
    dynamic var runs = List<RunEntity>()
    
    convenience init(login: String, password: String){
        self.init()
        self.userId = RealmOptional<Int>.init(Self.counter)
        self.login = login
        self.password = password
        self.runs.append(objectsIn: runs)
        Self.counter = Self.counter + 1
    }
    
    func equals(object: UserEntity) -> Bool {
        return self.login == object.login
    }

    func isValid() -> Bool{
    //        let loginSample = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$")
    //        let passwordSample = try NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$")
            let loginSample =  "^[A-Zaa-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,6}$"
            let passwordSample = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,}$"
            return self.login.matches(loginSample) && self.password.matches(passwordSample)
        }
}
