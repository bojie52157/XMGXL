//
//  UserAccount.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/15.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import AFNetworking
class UserAccount: NSObject,NSCoding{
    //MARK:-属性
    ///令牌
    @objc var access_token: String?
    ///从授权开始一刻开始，多少秒之后过期
    @objc var expires_in: Int = 0
    ///真正过期时间
    @objc var expires_Date: NSDate?
    ///用户ID
    @objc var uid: String?
    @objc var isRealName : Bool = true
    @objc var remind_in : String?
    ///用户头像
    @objc var avatar_large: String?
    ///用户昵称
    @objc var screen_name: String?
    
    
    //MARK:- 生命周期方法
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
        SZXLog(message: self.access_token) 
    }
    //当KVC发现没有对应的key时就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        super.setValue(value, forUndefinedKey: key)
    }
 
    //MARK:- 外部控制方法
    ///归档对象
    func saveAccount()->Bool{
        //3.归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    ///定义属性保存授权模型
    static var account: UserAccount?
    static var filePath:String = "/useraccount.plist".cacheDir()
    ///解档对象,判断是否加载过
    class func loadUserAccount() -> UserAccount? {
        //1.判断是否已经加载过了
        if UserAccount.account != nil {
            SZXLog(message: "已经加载过")
            SZXLog(message: filePath)
            return UserAccount.account
        }
        //2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount else {
            SZXLog(message: filePath)
            return nil
        }
        //3.校验是否过期
        account.expires_Date = NSDate(timeIntervalSinceNow: TimeInterval(account.expires_in))
        guard let date = account.expires_Date else{
            return nil
        }
        if date.compare(NSDate() as Date) == ComparisonResult.orderedAscending {
            return nil
        }
        
        UserAccount.account = account
        return UserAccount.account
    }
    
    ///获取用户信息
    func loadUserInfo(finished:@escaping(_ account: UserAccount?, _ error:Error?)->()) {
        //断言
        //断言access_token一定不等于nil，如果运行时access_token为nil，则程序崩溃
        assert(access_token != nil, "使用该方法必须先授权")
        //1.准备路径
        let path = "2/users/show.json"
        //2.准备参数
        let parameters = ["access_token":access_token,"uid":uid]
        //3.发送get请求
       NetworkTolls.sharedInstance.get(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, dict:Any?) in
            let dict = dict as! [String : AnyObject]
            //1.取出用户信息
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            //2.保存用户授权信息
            finished(self, nil)
        }) { (task:URLSessionDataTask?,error: Error) in
            finished(nil,error)
        }
    }
    
    ///判断用户是否登录
    class func isLoginWB()->Bool {
        return (UserAccount.loadUserAccount() != nil)
    }

    //MARK: -NSCoding
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expires_in, forKey: "expires_in")
        coder.encode(uid, forKey: "uid")
        coder.encode(expires_Date, forKey: "expires_Date")
        coder.encode(remind_in, forKey: "remind_in")
        coder.encode(isRealName, forKey: "isRealName")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")
    }
    required init?(coder aDecoder: NSCoder)
     {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in") as Int
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? NSDate
        self.remind_in = aDecoder.decodeObject(forKey: "remind_in") as? String
        self.isRealName = aDecoder.decodeBool(forKey: "isRealName")
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
     }
}

