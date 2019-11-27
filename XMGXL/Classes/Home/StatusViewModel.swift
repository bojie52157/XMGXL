//
//  StatusViewModel.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/26.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    ///模型对象
    var status: Status
    
    init(status:Status) {
        self.status = status
        //处理头像
        icon_url = URL(string:status.user?.profile_image_url ?? "")
        //处理会员图标
        if status.user!.mbrank >= 1 && status.user!.mbrank <= 6{
            mbrankImage = UIImage(named: "common_icon_membership_level\(self.status.user!.mbrank)")
        }else{
            mbrankImage = nil
        }
        //处理认证图片
        switch self.status.user?.verified_type ?? -1 {
        case 0:
            verified_image = UIImage(named:"avatar_vip")
        case 2:
            verified_image = UIImage(named:"avatar_enterprise_vip")
        case 3:
            verified_image = UIImage(named:"avatar_enterprise_vip")
        case 5:
            verified_image = UIImage(named:"avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named:"avatar_grassroot")
        default:
            verified_image = nil
        }
        //处理来源
        if let timeStr = status.created_at, timeStr != "" {
          //1.将服务器返回的时间格式化NSDate
          let createDate = NSDate.createDate(timeStr: timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
          //2.生成发布微博时间对应的字符串
          created_Time = createDate.descriptionStr()
      }
        //处理来源
        if let sourceStr: NSString = status.source as NSString?, sourceStr != ""{
            //5.1获取从什么地方开始截取
            let startIndex = sourceStr.range(of: ">").location + 1
            //5.2获取截取的长度
            let length = sourceStr.range(of: "<", options: NSString.CompareOptions.backwards).location - startIndex
            //5.3截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            //赋值
            source_Text = "来自" + rest
        }
        
        ///处理配图url
        //2.从模型中取出配图数组
        if let picurls = status.pic_urls{
            thumbnail_pic = [URL]()
           //2.遍历配图数组下载图片
           for dict in picurls {
            //2.1取出图片URL字符串
            guard let urlStr = dict["thumbnail_pic"] as? String else {
                continue
            }
            //2.2根据字符串创建URL
            let url = URL(string: urlStr)!
            thumbnail_pic?.append(url)
           }
        }
       
    }
    
    ///用户认证图片
    @objc var verified_image:UIImage?
    ///会员图片
    @objc var mbrankImage: UIImage?
    ///用户头像地址
    @objc var icon_url: URL?
    /// 微博格式化之后的创建时间
    @objc var created_Time: String = ""
    ///微博格式化之后的来源
      @objc var source_Text: String = ""
    ///保存所有配图的url
    @objc var thumbnail_pic: [URL]?
}
