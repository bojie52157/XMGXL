//
//  XMGPresentationManager.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/12.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

///自定义转场的展现
let XMGPresentationManagerDidPresented = "XMGPresentationManagerDidPresented"
///自定义转场的消失
let XMGPresentationManagerDidDismiss = "XMGPresentationManagerDidDismiss"

class XMGPresentationManager: NSObject ,UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning{
    //定义标记记录当前是否是展现
    private var isPresent = false
    ///保存菜单的尺寸
    var presentFrame = CGRect.zero
    
    //MARK: - UIViewControllerTransitioningDelegate
    //转场时最上层的视图的控制器需遵循UIViewControllerTransitioningDelegate协议
    //该方法用于返回一个负责转场动画的对象，处理present动画过度对象
    //可以在该对象中控制视图的尺寸等
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = XMGPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    //该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        //发送通知，告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XMGPresentationManagerDidPresented), object: self)
        return self
    }
    //该方法用于返回一个负责转场如何消失的对象,dismiss动画过度对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        //发送通知，告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XMGPresentationManagerDidDismiss), object: self)
        return self
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
//遵守UIViewControllerAnimatedTransitioning协议的动画过度管理对象
    //告诉系统展现和消失动画的时长
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //专门用于管理modal如何展现和消失的，无论展现还是消失都会调用该方法
    //注意点：只要实现这个代理方法，那么系统就不会再有默认的动画了，也就是说默认的modal从下至上的移动系统不帮我们添加了,所有的动画操作都需要我们实现，包括需要展现的视图也需要我们自己添加到容器视图上（containerView）
    //transitionContext:所有动画需要的东西都保存在上下文中，换而言之就是可以通过transitionContext获取到我们想要的东西
    //所有的过度动画事务都在这个方法完成
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            //展现视图
            willPresentedController(transitionContext: transitionContext)
        }else{
            //消失
            willDismissedController(transitionContext: transitionContext)
        }
        
    }
    
    ///执行展现动画
    private func willPresentedController(transitionContext:UIViewControllerContextTransitioning)  {
        //1.获取需要弹出视图
        guard let toVC: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        //2.将需要弹出的视图添加到containerView上
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        //3.执行动画
        toVC.view.transform = CGAffineTransform(scaleX: 1.0,y: 0.0)
        //设置锚点
        toVC.view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        UIView.animate(withDuration: 2.0, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }) { (_) in
            //注意：自定义转场动画，在执行完动画之后一定要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
    ///执行消失动画
    private func willDismissedController(transitionContext:UIViewControllerContextTransitioning){
        //消失
        guard let fromVC:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        //2执行
        UIView.animate(withDuration: 0.5, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 1.0,y: 0.0001)
        }) { (_) in
            //注意：自定义转场动画，在执行完动画之后一定要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
}
