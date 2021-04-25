import Foundation
import Realm
import RealmSwift

@objcMembers
class Race: Object, DatabaseObject{
    dynamic var participants: List<User>!
    dynamic var distance: RealmOptional<Int>!
}
