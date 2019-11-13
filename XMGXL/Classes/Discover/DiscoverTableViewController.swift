//
//  DiscoverTableViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/9/29.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            visitorView?.setupVisitorInfo(imageName: "visitordiscover_image_message", title: "登陆后，最新最热门尽在掌握")
        }
       
    }
}
