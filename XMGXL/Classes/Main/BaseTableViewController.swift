//
//  BaseTableViewController.swift
//  XMGWB
//
//  Created by 孙 on 2019/6/20.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

/*
 通知：层级结构较深
 代理：父子，方法较多时使用
 block：父子，方法较少时使用（一般情况一个方法）
 */

class BaseTableViewController: UITableViewController {
    
    //定义标记记录用户登录状态
    var isLogin = UserAccount.isLoginWB()
    //访客视图
    var visitorView : VisitorView?
    
    //loadView，控制器加载执行第一个视图加载方法
    override func loadView() {
        //判断用户是否登录，如果没有登录就显示访客界面，如果已经登录就显示tableView
        isLogin ? super.loadView() : setupVisitorView()
    }
    
//MARK: -内部控制方法
    private func setupVisitorView(){
        //1.创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        //2.按钮点击事件
        visitorView?.loginButton .addTarget(self, action: #selector(loginBtnClick), for: UIControlEvents.touchUpInside)
        visitorView?.registerButton.addTarget(self, action: #selector(registerBtnClick), for: UIControlEvents.touchUpInside)
        //3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(loginBtnClick))
        
    }
    
    ///监听登录按钮点击
    @objc private func loginBtnClick(){
        //1.初始化OAuth.storyboard
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        //2.弹出视图
        present(vc, animated: true, completion: nil)
    }
    ///监听注册按钮点击
    @objc private func registerBtnClick(){
        
    }
}

