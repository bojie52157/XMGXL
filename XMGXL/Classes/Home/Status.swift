//
//  Status.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/22.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    /// 微博创建时间
    var created_at: String?
    ///字符串型的微博ID
    var idstr: String?
    /// 微博信息内容
    var text: String?
    ///微博来源
    var source: String?
    ///微博作者的用户信息字段
    var user: User?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //KVC的setValuesForKeys方法内部调用setValue方法
    override func setValue(_ value: Any?, forKey key: String) {
        //1.拦截user的赋值操作
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    //模型与数据不一一对应，重写此方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //重写父类description方法，输出模型中的内容
    override var description: String{
        let property = ["created_at","idstr","text","source"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
