//
//  TitleButton.swift
//  XMGWB
//
//  Created by 孙 on 2019/6/21.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    //通过纯代码创建时调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    //通过xib创建时调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupUI()
    }
    
    private func setupUI(){
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.darkGray, for: .normal)
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        //??用于判断前面的参数是否是nil，如果是nil就返回？？后面的数据，如果不是nil那么？？后面的语句就不执行
        super.setTitle((title ?? "") + " ", for: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //offsetBy 方法用于设置控件的偏移位
        //titleLabel?.frame.offsetBy(dx: -(imageView?.frame.width)! * 0.5, dy: 0)
        
        //swift 语法允许我们之间修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
    }
}
