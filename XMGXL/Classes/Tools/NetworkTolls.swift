//
//  NetworkTolls.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/14.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTolls: AFHTTPSessionManager {

    static let sharedInstance: NetworkTolls = {
       
        let baseURL = NSURL(string: "https://api.weibo.com/")
        let instance = NetworkTolls(baseURL: baseURL! as URL, sessionConfiguration: URLSessionConfiguration.default)
        instance.requestSerializer = AFHTTPRequestSerializer()
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain","application/json","text/json","text/javascript") as? Set<String>
        return instance
    }()
    
    //MARK:-请求微博数据
    ///请求微博数据
    func loadStatuses(finished:@escaping( _ array: [[String: AnyObject]]?,_ error: Error?) -> ()) {
        assert(UserAccount.loadUserAccount() != nil, "没有access_token值")
        //1.准备路径
        let path = "2/statuses/home_timeline.json"
        //2.准备参数
        let parameters = ["access_token" : UserAccount.loadUserAccount()!.access_token!]
        //3.发送请求
        get(path, parameters: parameters, progress: nil, success: { (task, objc) in
            //利用闭包回调，返回数据给调用者
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else{
                finished(nil ,NSError(domain: "com.www.baidu.com", code: 1000, userInfo: ["message" : "没有获取到数据"]))
                return
            }
            finished(arr,nil)
        }) { (task, error) in
            finished(nil,error)
        }
    }
}
