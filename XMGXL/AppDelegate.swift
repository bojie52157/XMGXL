//
//  AppDelegate.swift
//  XMGXL
//
//  Created by 孙 on 2019/9/29.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        /*
        //1.创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //2.设置根控制器
        window?.rootViewController = MainViewController()
        //3.显示window
        window?.makeKeyAndVisible()
        return true
        */
 
        //全局外观
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        return true;
    }

}
