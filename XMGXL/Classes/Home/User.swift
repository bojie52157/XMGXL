//
//  User.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/22.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class User: NSObject {

    ///字符串型的用户UID
    @objc var idstr: String?
    ///用户昵称
    @objc var screen_name: String?
    ///用户头像字符串地址(中图)
    @objc var profile_image_url: String?
//        {
//        didSet{
//            icon_url = URL(string: profile_image_url ?? "")
//           }
//    }
//    ///用户头像地址
//    @objc var icon_url: URL?
    ///用户认证类型, -1没有认证， 0认证用户， 2、3、5企业认证，220达人
    @objc var verified_type: Int = -1
//        {
//        didSet{
//                switch verified_type {
//                case 0:
//                    verified_image = UIImage(named:"avatar_vip")
//                case 2:
//                    verified_image = UIImage(named:"avatar_enterprise_vip")
//                case 3:
//                    verified_image = UIImage(named:"avatar_enterprise_vip")
//                case 5:
//                    verified_image = UIImage(named:"avatar_enterprise_vip")
//                case 220:
//                    verified_image = UIImage(named:"avatar_grassroot")
//                default:
//                    verified_image = nil
//                }
//            }
//    }
//    ///用户认证图片
//    @objc var verified_image:UIImage?
    ///会员等级，取值范围1-6
    @objc var mbrank: Int = -1
//        {
////        didSet{
////               if mbrank >= 1 && mbrank <= 6{
////                   mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
////               }else{
////                   mbrankImage = nil
////               }
////        }
//    }
//    ///会员图片
//    @objc var mbrankImage: UIImage?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        ///这句话很关键,一定要有
        super.setValue(value, forKey: key)
    }
    //模型与数据不一一对应，重写此方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //重写父类description方法，输出模型中的内容
    override var description: String{
        let property = ["idstr","screen_name","profile_image_url","verified_type","mbrank"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
