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
        
        //1.全局外观
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        //2.注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewController(notifi: )), name: NSNotification.Name(rawValue: "XMGRooterViewController"), object: nil)
        
//       //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //2.设置根控制器
        window?.rootViewController = defaultViewController()
        //3.显示window
        window?.makeKeyAndVisible()
        
        return true;
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension AppDelegate{
    
    ///切换根控制器
    @objc func changeRootViewController(notifi:Notification) {
        if notifi.object as! Bool {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }else{
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }
    }
    
    /// 用于返回默认界面
    private func defaultViewController() -> UIViewController{
        //1.判断是否登录
        if UserAccount.isLoginWB() {
            //2.判断是否有新版本
            if isNewVersion(){
                let sb = UIStoryboard(name: "Newfeature", bundle: nil)
                return sb.instantiateInitialViewController()!
            }else{
                let sb = UIStoryboard(name: "Welcome", bundle: nil)
                return sb.instantiateInitialViewController()!
            }
        }
        //没有登录
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    ///判断是否有新版本
    private func isNewVersion() -> Bool{
        //1.加载info.plist,获取当前软件的版本号
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //2.获取以前软件的版本号
        let defaults = UserDefaults.standard
        let sanboxVersion = (defaults.object(forKey: "xxoo") as? String) ?? "0.0"
        //3.用当前的版本号和以前的版本号进行比较,如果大于有新版本
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending {
            SZXLog(message: "有新版本")
            defaults.set(currentVersion, forKey: "xxoo")
            return true
        }
        SZXLog(message: "没有新版本")
        return false
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
