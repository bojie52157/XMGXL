//
//  UIButton+Extension.swift
//  XMGWB
//
//  Created by 孙 on 2019/6/20.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

extension UIButton
{
    /*
     构造方法前面没有convenience，代表一个初始化构造方法
     构造方法前面有convenience，代表一个便利构造方法
     区别：构造方法中必须读所有的属性进行初始化
          便利构造方法不用对所有的属性进行初始化，因为便利构造方法依赖于指定构造方法
     一般情况下如果想给系统的类提供一个快速创建的方法，就自定义一个便利构造方法
     */
    convenience init(imageName: String?, backgroundImageName: String?) {
        self.init()//构造函数
        if let name = imageName {
            //设置前景图片
            setImage(UIImage(named: name), for: UIControlState.normal)
            setImage(UIImage(named: name + "_highlighted"), for: UIControlState.highlighted)
        }
        if let backgroundName = backgroundImageName {
            //设置背景图片
            setBackgroundImage(UIImage(named: backgroundName), for: UIControlState.normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), for: UIControlState.highlighted)
        }
        //调整按钮尺寸
        sizeToFit()
    }
}
