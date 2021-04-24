import Realm
import RealmSwift

class RunService: DatabaseService {
    
    private let realm = try! Realm()
    
    func findAll() -> Array<RunEntity> {
//        return Array<RunEntity>(realm.objects(RunEntity.self))
    }
    
    func save(_ object: RunEntity) {
//        if !checkIfExists(object) {
//            try? realm.write{
//                realm.add(object)
//            }
//        }else{
//            update(object)
//        }
    }
    
    func update(_ object: RunEntity) {
        
    }
    
    func delete(_ object: RunEntity) {
        <#code#>
    }
    
    func deleteAll() {
        <#code#>
    }
    
    func checkIfExists(_ object: RunEntity) -> Bool {
        <#code#>
    }
    
    
}
