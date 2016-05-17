//
//  Repository.swift
//  CalendarMoney
//
//  Created by 中安拓也 on 2016/05/17.
//  Copyright © 2016年 l08084. All rights reserved.
//

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
}
