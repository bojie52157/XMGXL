//
//  XMGPresentationController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/2.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class XMGPresentationController: UIPresentationController {
    
    ///保存菜单的尺寸
    var presentFrame = CGRect.zero
   /*
        如果不自定义转场modal出来的控制器会转移原有的控制器
        如果自定义转场modal出来的控制器不会移除原有的控制器
        如果不自定义转场modal出来的控制器的尺寸和屏幕一样
        如果自定义转场modal出来的控制器的尺寸，我们可以自己在containerViewWillLayoutSubviews方法中控制
        containerView非常重要，容器视图，所有modal出来的视图都是添加到containerView上
        **/
       override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
           super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
       }
       
       //用于布局转场动画弹出的控件
       override func containerViewWillLayoutSubviews() {
           //设置弹出视图的尺寸
           presentedView?.frame = presentFrame//CGRect(x: 100, y: 45, width: 200, height: 200)
           //添加蒙版
           containerView?.insertSubview(coverButton, at: 0)
           coverButton.addTarget(self, action: #selector(coverBtnClick), for: UIControlEvents.touchUpInside)
       }
       
       //MARK: - 内部控制方法
       @objc private func coverBtnClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
       }
       
       //MARK: - 懒加载
       private lazy var coverButton : UIButton = {
           let btn = UIButton()
           btn.frame = UIScreen.main.bounds
           return btn
       }()
}
