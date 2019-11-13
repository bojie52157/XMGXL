//
//  MainViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/9/29.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        /*
        //tabBar文字，图片颜色
        tabBar.tintColor = UIColor.orange
        //添加子控制器
        addChildViewControllers()
        */
        
        
    }
    
//MARK: 设置按钮frame
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        tabBar .addSubview(composeButton)
        //保存按钮尺寸
        let rect = composeButton.frame
        //计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        //设置按钮位置
        composeButton.frame = CGRect(x: 2 * width, y: 5, width: width, height: rect.height)
    }
    
//MARK: -添加子控制器
    /*
    /// 添加所有子控制器
    func addChildViewControllers() {
        
        //根据JSON文件创建控制器
        //1.读取json数据
        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            return
        }
        guard let data = NSData(contentsOfFile: filePath) else {
            return
        }
        //2.将json数据转为对象
        do {
            let objc = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
            //3.遍历数组字典取出每一个字典
            for dict in objc {
                //4.根据遍历到的字典创建控制器
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName, title: title, imageName: imageName)
            }
        } catch {
            addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("NullViewController",title: "", imageName: "")
            addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
        
        //命名空间方式加载controller
        /*
        addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
         */
    }
    */
    
//MARK: -设置子控制器
    /*
    /// 设置子控制器
    /// - Parameter childController: 控制器
    /// - Parameter title: 标题
    /// - Parameter imageName: 图片
    func addChildViewController(_ childControllerName: String?,title: String?, imageName: String?) {
        //1.动态获取命名空间
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else
        {
            return
        }
        
        //2.根据字符串获取Class
        var cls: AnyClass? = nil
        if let vcName = childControllerName {
            cls = NSClassFromString(name + "." + vcName)
        }
        guard let typeCls = cls as? UITableViewController.Type else {
            return
        }
        //通过Class创建对象
        let childController = typeCls.init()
        //设置控制器属性
        //该方法会由内向外设置标题
        childController.title = title;
        if let ivName = imageName{
            childController.tabBarItem.image = UIImage(named: ivName)
            childController.tabBarItem.selectedImage = UIImage(named: ivName + "_highlighted")
        }
        //包装一个导航控制器
        let nav = UINavigationController(rootViewController: childController)
        //将子控制器添加到UITbaBarController中
        addChildViewController(nav)
    }
    */
    
//MARK: button点击
    @objc func composeBtnClick() {
        
    }
    
//MARK:- 懒加载
    lazy var composeButton :UIButton = {
        //1.创建按钮
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        //2.点击事件
        btn .addTarget(self, action: #selector(composeBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
}
