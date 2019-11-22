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
    var idstr: String?
    ///用户昵称
    var screen_name: String?
    ///用户头像地址(中图)
    var profile_image_url: String?
    ///用户认证类型
    var verified_type: Int = -1
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    //模型与数据不一一对应，重写此方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //重写父类description方法，输出模型中的内容
    override var description: String{
        let property = ["idstr","screen_name","profile_image_url","verified_type"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
