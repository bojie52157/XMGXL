//
//  UIBarButtonItem.swift
//  XMGWB
//
//  Created by 孙 on 2019/6/20.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName),for: UIControlState.normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"),for: UIControlState.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.init(customView: btn)
    }
}
