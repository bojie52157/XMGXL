//
//  OAuthViewController.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/5.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    /// 网页容器
    @IBOutlet weak var customWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=3117451778&redirect_uri=http://www.baidu.com"
        // 2.创建URL
        guard let url = NSURL(string: urlStr) else
        {
            return
        }
        // 3.创建Request
        let request = NSURLRequest(url: url as URL)
        
        // 4.加载登录界面
        
        customWebView.loadRequest(request as URLRequest)
        customWebView.delegate = self
    }

  
    
    }
extension OAuthViewController: UIWebViewDelegate{
    // 该方法每次请求都会调用
      // 如果返回false代表不允许请求, 如果返回true代表允许请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    /*
        登录界面: https://api.weibo.com/oauth2/authorize?client_id=4129759360&redirect_uri=http://www.520it.com
        输入账号密码之后: https://api.weibo.com/oauth2/authorize
        取消授权: http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        授权:http://www.520it.com/?code=c2796542e264da89367f993131e6c904
        通过观察
        1.如果是授权成功获取失败都会跳转到授权回调页面
        2.如果授权回调页面包含code=就代表授权成功, 需要截取code=后面字符串
        3.而且如果是授权回调页面不需要显示给用户看, 返回false
        */
        // 1.判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else
        {
            return false
        }
        if !urlStr.hasPrefix("http://www.baidu.com/")
        {
            NSLog("不是授权回调页面")
            return true
        }
        
        NSLog("是授权回调页面")
        // 2.判断授权回调地址中是否包含code=
        // URL的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
        let key = "code="
        if urlStr.contains(key)
        {
            let code = (request.url!.query?.substring(from: key.endIndex))
            NSLog(code!)
            return false
        }
        NSLog("授权失败")
        return false
    }
}
