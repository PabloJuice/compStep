import Realm
import RealmSwift

class RunService{
    
    private let realm = try! Realm()
    
    func save(_ object: RunEntity) {
        if !checkIfExists(object) {
            try! realm.write{
                realm.add(object)
            }
        }else{
            try! realm.write{
                realm.delete(object)
                save(object)
            }
        }
    }
    
    func delete(_ object: RunEntity) {
        try? realm.write{
            let objects = findAll()
                .compactMap{$0}
                .filter {!object.equals(object: $0) }
            
            deleteAll()
            objects.forEach{realm.add($0)}
        }
    }
    
    func deleteAll() {
        try? realm.write{
            realm.delete(realm.objects(RunEntity.self))
        }
    }
    
    func checkIfExists(_ object: RunEntity) -> Bool {
        return findAll()
            .compactMap{$0}
            .filter {object.equals(object: $0) }
            .count > 0
    }
    
    func findAll() -> Array<RunEntity> {
        return Array<RunEntity>(realm.objects(RunEntity.self))
    }
}
