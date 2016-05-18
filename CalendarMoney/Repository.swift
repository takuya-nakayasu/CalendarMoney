import RealmSwift

/// DBアクセサクラス
public class Repository {
    
    let realm: Realm
    
    // 初期化処理
    init() {
        
        // デフォルトRealmを取得する
        realm = try! Realm()
        
        // Realmファイルが現在配置されている場所を表示
        print("realm:\(realm.path)")
    }
    
    /// Spendモデルの最大IDを取得
    func findMaxIdInSpend() -> Int {
        
        let maxId = realm.objects(Spend).sorted("id").last?.id ?? 0
        
        return maxId
    }
    
    /// spendモデルの保存
    func saveSpend(spend: Spend) {
        
        try! realm.write {
            
            self.realm.add(spend, update: true)
        }
    }
}
