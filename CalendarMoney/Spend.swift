
import RealmSwift

class Spend: Object {
    
    dynamic var id = 0
    dynamic var spendMoney = 0
    dynamic var spendDate = NSDate()
    dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
