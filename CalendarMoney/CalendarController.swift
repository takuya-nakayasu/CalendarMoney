//
//  CalendarController.swift
//  CalendarMoney
//
//  Created by 中安拓也 on 2016/06/11.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit

class CalendarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITabBarControllerDelegateプロトコルを実装する
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    // UITabBarControllerDelegateプロトコルを実装する
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
}
