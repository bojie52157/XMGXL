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

        
//        //1.创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //2.设置根控制器
        let sb = UIStoryboard(name: "Welcome", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        window?.rootViewController = vc
        //3.显示window
        window?.makeKeyAndVisible()
//        return true
        
 
        //全局外观
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        
        
        return true;
    }

}

/*
打印LOG的弊端:
1.非常消耗性能
2.如果app部署到AppStore之后用户是看不到LOG的

所以
开发阶段: 显示LOG
部署阶段: 隐藏LOG
*/
func SZXLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
//    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}
