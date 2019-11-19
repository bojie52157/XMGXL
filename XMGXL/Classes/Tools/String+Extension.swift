//
//  String+Extension.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/18.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

extension String{
    
    ///快速生成缓存路径
    func cacheDir() -> String {
        //1.获取路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = path + self
        return filePath
    }
    ///快速生成document路径
    func docDir() -> String {
        //1.获取路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let filePath = path + self
        return filePath
    }
    ///快速生成tmp路径
    func tmpDir() -> String {
        //1.获取路径
        let path = NSTemporaryDirectory()
        let filePath = path + self
        return filePath
    }
}
