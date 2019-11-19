//
//  HomeTableViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/9/29.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.判断用户是否登录
        if !isLogin {
            //设置访客视图
            visitorView?.setupVisitorInfo(imageName: nil, title: "关注一些人")
            return
        }
       
        //2.设置导航条
        setupNav()
        //3.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(titleChange), name: NSNotification.Name(rawValue: XMGPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector: #selector(titleChange), name: NSNotification.Name(rawValue: XMGPresentationManagerDidDismiss), object: animatorManager)
    }

    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:设置导航条
    private func setupNav(){
        //添加左右导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightBtnClick))
        
        //设置titleView
        navigationItem.titleView = titleButton
        
    }
    
    //MARK:标题按钮箭头改变
    @objc private func titleChange(){
        titleButton.isSelected = !titleButton.isSelected
    }
    
    //MARK:设置自定义转场代理，创建菜单
    @objc private func titleBtnClick(btn: TitleButton){
        btn.isSelected = !btn.isSelected
        //显示菜单
        //创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //设置自定义转场动画
        //设置转场代理
        menuView.transitioningDelegate = animatorManager
        //设置转场动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        //弹出菜单
        present(menuView,animated: true,completion: nil)
    }
    
    @objc private func leftBtnClick(){
        
    }
    @objc private func rightBtnClick(){
        //1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        //2.弹出控制器
        present(vc,animated: true, completion: nil)
    }
    //MARK: -懒加载
    private lazy var animatorManager:XMGPresentationManager = {
       let manager = XMGPresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 300)
        return manager
    }()
    ///标题按钮
    private lazy var titleButton:TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(titleBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
}


