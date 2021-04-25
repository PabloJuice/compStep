import Realm
import RealmSwift

class RouteMapService{
    
    private let realm = try! Realm()
    
    func save(_ object: RouteMap) {
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
    
    func delete(_ object: RouteMap) {
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
            realm.delete(realm.objects(RouteMap.self))
        }
    }
    
    func checkIfExists(_ object: RouteMap) -> Bool {
        return findAll()
            .compactMap{$0}
            .filter {object.equals(object: $0) }
            .count > 0
    }
    
    func findAll() -> Array<RouteMap> {
        return Array<RouteMap>(realm.objects(RouteMap.self))
    }
}
