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
    @objc var created_at: String?
//        {
//        didSet{
//            if let timeStr = created_at, timeStr != "" {
//                //1.将服务器返回的时间格式化NSDate
//                let createDate = NSDate.createDate(timeStr: timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
//                //2.生成发布微博时间对应的字符串
//                created_Time = createDate.descriptionStr()
//            }
//        }
//    }
    /// 微博格式化之后的创建时间
//    @objc var created_Time: String = ""
    ///字符串型的微博ID
    @objc var idstr: String?
    /// 微博信息内容
    @objc var text: String?
    ///微博来源
    @objc var source: String?
//        {
//        didSet{
//            if let sourceStr: NSString = source as NSString?, sourceStr != ""{
//            //5.1获取从什么地方开始截取
//                let startIndex = sourceStr.range(of: ">").location + 1
//            //5.2获取截取的长度
//                let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
//            //5.3截取字符串
//                let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
//            //赋值
//                source_Text = "来自" + rest
//            }
//        }
//    }
    ///微博格式化之后的来源
//    @objc var source_Text: String = ""
    ///微博作者的用户信息字段
    @objc var user: User?
    ///配图数组
    @objc var pic_urls: [[String : AnyObject]]?
    
    
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
