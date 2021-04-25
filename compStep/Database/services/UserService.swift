import Realm
import RealmSwift

class UserService{
    
    
    private let realm = try! Realm()
    
    func save(_ object: UserEntity) {
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
    
    func delete(_ object: UserEntity) {
        try? realm.write{
            let objects = findAll()
                .compactMap{UserEntity(value: $0)}
                .filter {!object.equals(object: $0) }
            
            deleteAll()
            objects.forEach{realm.add($0)}
        }
    }
    
    func deleteAll() {
        try? realm.write{
            realm.delete(realm.objects(UserEntity.self))
        }
    }
    
    func checkIfExists(_ object: UserEntity) -> Bool {
        return findAll()
            .compactMap{UserEntity(value: $0)}
            .filter {object.equals(object: $0) }
            .count > 0
    }
    
    func findAll() -> Array<UserEntity> {
        return Array<UserEntity>(realm.objects(UserEntity.self))
    }
    
    
}
