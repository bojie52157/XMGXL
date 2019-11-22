//
//  WelcomeViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/19.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    ///头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    ///头像图片
    @IBOutlet weak var iconImageVIew: UIImageView!
    ///欢迎回来
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置头像圆角
        iconImageVIew.layer.cornerRadius = 45
        iconImageVIew.layer.masksToBounds = true
        //断言
        assert(UserAccount.loadUserAccount() != nil, "必须授权后才能显示欢迎界面")
        //2.设置头像
        guard  let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_large!) else{
            return
        }
        iconImageVIew.sd_setImage(with: url as URL, completed: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //1.让头像执行动画
        iconBottomCons.constant = (UIScreen.main.bounds.height - iconBottomCons.constant) + 20
        UIView.animate(withDuration: 2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 2.0, animations: {
                self.titleLabel.alpha = 1.0
            }) { (_) in
                //4跳转到首页
                /*
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateInitialViewController()!
                UIApplication.shared.keyWindow?.rootViewController = vc
                */
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XMGRooterViewController"), object: true)
            }
        }
    }


}
