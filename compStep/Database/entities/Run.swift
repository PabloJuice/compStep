import Realm
import RealmSwift
import  Foundation

@objcMembers
class RunEntity: Object, DatabaseObject{

    static var counter : Int = 1
    dynamic var runId = RealmOptional<Int>(0)
    dynamic var ownerId = RealmOptional<Int>(0)
    
    dynamic var distance = RealmOptional<Double>(0)
    dynamic var duration = RealmOptional<Double>(0)
    dynamic var timeStamp : NSDate!
    dynamic let locations = List<Location>()
    
    convenience init(ownerId: Int?, distance: Double?, duration: Double?) {
        self.init()
        self.ownerId = RealmOptional.init(ownerId)
        self.runId = RealmOptional.init(RunEntity.counter)
        self.distance = RealmOptional.init(distance)
        self.duration = RealmOptional.init(duration)
        self.timeStamp = NSDate.init()
        RunEntity.counter += 1
    }
    
    func addToLocation(location: Location){
        self.locations.append(location)
    }
    
    func equals(object: RunEntity) -> Bool {
        return self.runId == object.runId
    }
//    func incrementID() -> Int {
//        let realm = try! Realm()
//        realm.
//        return (realm.objects(RunEntity.Type).max(by: "runId") as Int? ?? 0) + 1
//    }
    
//    override static func primaryKey() -> String? {
//        return "runId"
//    }
    
}
@objcMembers
class Location : Object{
    var latitude = RealmOptional<Double>(0)
    var longtitude = RealmOptional<Double>(0)
    var timeStamp : NSDate!
    
    init(latitude: Double, longtitude : Double) {
        self.timeStamp = NSDate.init()
        self.latitude = RealmOptional.init(latitude)
        self.longtitude = RealmOptional.init(longtitude)
    
    }
    
    override init(){
        self.timeStamp = NSDate.init()
    }
    
}
