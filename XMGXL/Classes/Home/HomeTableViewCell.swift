//
//  HomeTableViewCell.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/25.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    ///头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 会员图标
    @IBOutlet weak var vipImageVIew: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLaebl: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: StatusViewModel?
    {
        didSet{
            //1.设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_url, completed: nil)
            //2.设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            //3.设置会员图标
            vipImageVIew.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage {
                vipImageVIew.image = image
                nameLabel.textColor = UIColor.orange
            }
            //4.设置时间
            timeLabel.text = viewModel?.created_Time
            //5.来源
            sourceLaebl.text = viewModel?.source_Text
            //6.正文
            contentLabel.text = viewModel?.status.text
            //7.昵称
            nameLabel.text = viewModel?.status.user?.screen_name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //1.设置正文最大宽度
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * 10
}
}
