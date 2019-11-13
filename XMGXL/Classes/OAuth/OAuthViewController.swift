//
//  OAuthViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/13.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    ///网页容器
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.创建字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=3117451778&redirect_uri=http://www.baidu.com"
        //2.创建URL
        guard  let url = NSURL(string: urlStr) else{
            return
        }
        //3.创建Request
        let request = NSURLRequest(url: url as URL)
        //4.加载登录界面
        customWebView.loadRequest(request as URLRequest)
    }

}
