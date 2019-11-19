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
    
}
