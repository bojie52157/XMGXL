//
//  HomeTableViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/9/29.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {

    ///保存所有的微博数据
    var statuses: [StatusViewModel]?{
        didSet{
            tableView.reloadData()
        }
    }
    
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
        //4.获取微博数据
        loadData()
        //5.动态加载行高
        //尽量不要使用，约束复杂，容易造成约束混乱
//        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableViewAutomaticDimension
    }

    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:-获取微博数据
    private func loadData(){
        NetworkTolls.sharedInstance.loadStatuses { (array, error) in
            //1.校验
            if error != nil {
                SVProgressHUD.showError(withStatus: "加载不到数据...")
            }
            guard let arr = array else{
                return
            }
//            SZXLog(message: arr)
            //2.将字典数组转换为模型数组
            var model = [StatusViewModel]()
            for dict in arr{
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                model.append(viewModel)
            }
            //3.缓存微博所有配图
            self.cachesImages(viewModels: model)
        }
    }
    
    ///缓存微博配图
    private func cachesImages(viewModels:[StatusViewModel]){
        //0.创建组
        let group = DispatchGroup()
        for viewModel in viewModels {
            //1.从模型中取出配图数组
            guard let picurls = viewModel.thumbnail_pic else{
                continue
            }
            //2.遍历配图数组下载图片
            for url in picurls {
                //将当前的下载操作添加到组中
                group.enter()
                //3.3利用SDWebImage下载图片
                SDWebImageManager.shared.loadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: nil) { (image, data, error, _, _, _) in
                    //将当前的下载操作从组中移除
                    group.leave()
                }
            }
        //监听下载操作
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(block: {
            //保存数据
            self.statuses = viewModels
        }))
        }
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

//MARK:- tableView代理方法
extension HomeTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.取出cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        //2.设置数据
        cell.viewModel = statuses![indexPath.row]
        //3.返回cell
        return cell
    }
}
