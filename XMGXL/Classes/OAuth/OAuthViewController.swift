//
//  OAuthViewController.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/5.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    /// 网页容器
    @IBOutlet weak var customWebView: UIWebView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_url)"
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
    //MARK:-内部控制方法
    @IBAction func closeBtnClick() {
        dismiss(animated: true, completion: nil)
      }
    @IBAction func autoBtnClick() {
        //使用js代码自动填充账号
        let jsStr = "document.getElementById('userId').value = '674504183@qq.com'"
        customWebView.stringByEvaluatingJavaScript(from: jsStr)
      }
  
    
    }
extension OAuthViewController: UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //显示提醒
        SVProgressHUD.showInfo(withStatus: "正在加载...", maskType: SVProgressHUDMaskType.black)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //关闭提醒
        SVProgressHUD.dismiss()
    }
    
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
          if !urlStr.hasPrefix("http://www.520it.com/")
          {
              SZXLog(message:"不是授权回调页面")
              return true
          }
          
          SZXLog(message:"是授权回调页面")
          // 2.判断授权回调地址中是否包含code=
          // URL的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
          let key = "code="
    print(urlStr)
    if (request.url?.query?.hasPrefix(key))!
          {
            let code = request.url!.query?.substring(from: key.endIndex)
            loadAccessToken(codeStr: code)
              return false
          }
//          SZXLog(message:"授权失败")
          return false
      }

    ///利用RequestToken换取AccessToken
    private func loadAccessToken(codeStr: String?){
        guard let code = codeStr else {
            return
        }
//        SZXLog(message:"换取token")
        //1.准备路径
        let path = "oauth2/access_token"
        //2.准备参数
        let parameters = ["client_id":WB_App_Key,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_Redirect_url]
        //3.发送请求
        NetworkTolls.sharedInstance.post(path, parameters: parameters, progress: nil, success: { (task:URLSessionDataTask, dict:Any?) in
            //1.将授权信息转换为模型
            let account = UserAccount(dict: dict as! [String : AnyObject])
            //2.获取授权信息
            account.loadUserInfo { (UserAccount, Error) in
                //3.保存用户信息
                account.saveAccount()
                //4跳转到欢迎界面
                /*
                let sb = UIStoryboard(name: "Welcome", bundle: nil)
                let vc = sb.instantiateInitialViewController()!
                UIApplication.shared.keyWindow?.rootViewController = vc
                 */
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XMGRooterViewController"), object: false)
                //关闭界面
                self.closeBtnClick()
            }
        }) { (task:URLSessionDataTask?,error: Error) in
            print(error)
        }
    }

}
