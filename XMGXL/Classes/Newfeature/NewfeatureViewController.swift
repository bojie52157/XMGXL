//
//  NewfeatureViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/21.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import SnapKit

class NewfeatureViewController: UIViewController {

    ///新特性界面个数
    private var maxCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}


//MARK:- Collection代理
extension NewfeatureViewController: UICollectionViewDataSource{
    
    //1.有多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //2.有多少行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    //3.行内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.设置cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! XMGNewfeatureCell
        //2.设置数据
        cell.index = indexPath.item
        //3.返回cell
        return cell
    }
}

extension NewfeatureViewController: UICollectionViewDelegate{
    //已经展示某个item时调用
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //注意：传入的cell和indexPath都是上一页的，而不是当前页
        //1.手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last!
        //2.根据指定的indexPath获取当前显示cell
        let currentCell = collectionView.cellForItem(at: index) as! XMGNewfeatureCell
        //3.判断当前是否是最后一页
        if index.item == (maxCount - 1) {
            //做动画
            currentCell.startAniamtion()
        }
    }
}

//MARK: -自定义cell
class XMGNewfeatureCell: UICollectionViewCell{
    var index: Int = 0{
        didSet{//属性观察者
            //生成图片名称
            let name = "new_feature_\(index + 1)"
            //设置图片
            iconView.image = UIImage(named: name)
            //点击按钮的显示隐藏
            startButton.isHidden = true
        }
    }
    //MARK:-内部控制方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //初始化UI
        setupUI()
    }
    
    //MARK:-外部控制方法
    ///做动画
    func startAniamtion(){
        startButton.isHidden = false
        //执行donghua
        startButton.transform = CGAffineTransform(scaleX: 0.0,y: 0.0)
        //不能点击
        startButton.isUserInteractionEnabled = false
        /*
         第一个参数：动画时间
         第二个参数：延迟时间
         第三个参数：振幅 0.0-1.0 越小越厉害
         第四个参数：加速度，值越大越厉害
         第五个参数：动画附加属性
         第六个参数：执行动画的block
         第七个参数: 执行完毕后的回调block
         **/
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            self.startButton.transform = CGAffineTransform.identity
        }) { (_) in
            self.startButton.isUserInteractionEnabled = true
        }
    }
    /// 初始化UI
    private func setupUI() {
        //1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        //2.进行布局
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
    }
    //MARK:-懒加载
    /// 图片容器
    private lazy var iconView = UIImageView()
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(startBtnClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    //MARK:-按钮点击事件
    @objc private func startBtnClick(){
          //4跳转到首页
        /*
          let sb = UIStoryboard(name: "Main", bundle: nil)
          let vc = sb.instantiateInitialViewController()!
          UIApplication.shared.keyWindow?.rootViewController = vc
        */
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "XMGRooterViewController"), object: true)
    }
}

//MARK:-自定义布局
class XMGNewfeatureLayout: UICollectionViewFlowLayout{
    //准备布局
    override func prepare() {
        super .prepare()
        //1.设置每个cell的尺寸
        itemSize = UIScreen.main.bounds.size
        //2.设置cell的间隙
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        //4.设置分页
        collectionView?.isPagingEnabled = true
        //5.禁用回弹
        collectionView?.bounces = false
        //6.去掉滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
