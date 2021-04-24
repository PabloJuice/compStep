import Realm
import RealmSwift

@objcMembers
class RunEntity: Object, DatabaseObject{
    static var counter = 0
    
    dynamic var runId : Int!
    dynamic var ownerId : Int!
    
    dynamic var distance : Double!
    dynamic var duration : Double!
    dynamic var timeStamp : Date!
    dynamic var locations : Array<Location>!
    
    convenience init(ownerId: Int, distance: Double, duration: Double, locations : Array<Location>) {
        self.init()
        self.ownerId = ownerId
        self.runId = Self.counter
        self.distance = distance
        self.duration = duration
        self.locations = locations
        Self.counter = Self.counter + 1
    }
    
}
class Location{
    var latitude : Double!
    var longtitude : Double!
    var timeStamp : Date!
    
    init(latitude: Double, longtitude : Double) {
        self.latitude = latitude
        self.longtitude = longtitude
        self.timeStamp = Date()
    }
    
}
