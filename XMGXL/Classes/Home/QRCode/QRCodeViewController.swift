//
//  QRCodeViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/12.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    //MARK: - 属性
    ///扫描容器视图
    @IBOutlet weak var customContainerView: UIView!
    ///底部工具条
    @IBOutlet weak var customTabBar: UITabBar!
    ///冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    ///容器视图高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    ///冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    ///结果文本
    @IBOutlet weak var customLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置默认选中
        customTabBar.selectedItem = customTabBar.items?.first
        //2.添加监听，监听底部工具条点击
        customTabBar.delegate = self
        //3.开始扫描二维码
        scanQRCode()
    }
    ///视图已出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    //MARK:- 开始扫描二维码
    private func scanQRCode(){
        //1.判断输入能否添加到会话中
        if !session.canAddInput(input!) {
            return
        }
        //2.判断输出能够添加到会话中
        if !session.canAddOutput(output){
            return
        }
        //3.添加输入和输出到会话中
        session.addInput(input!)
        session.addOutput(output)
        //4.设置输出能够解析的数据类型
        //注意点：设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //5.设置监听输出解析的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        //7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        //8.开始扫描
        session.startRunning()
    }
    
    //MARK:- 开启冲击波动画
    private func startAnimation(){
       //1.设置冲击波底部和容器视图顶部对齐
       scanLineCons.constant = -containerHeightCons.constant
       //强制刷新视图
       view.layoutIfNeeded()
       //2.执行动画
       //一般情况下swift只有需要区分两个变量，或者闭包中访问外界属性才需要加上self
       UIView.animate(withDuration: 2.0) {
           UIView.setAnimationRepeatCount(MAXFLOAT)
           self.scanLineCons.constant = self.containerHeightCons.constant
           self.view.layoutIfNeeded()
       }
    }
    
    //MARK: - 点击按钮
    @IBAction func closeBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func photoBtnClick(_ sender: Any) {
        //1.打开相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            return
        }
        //2.创建相册控制器
        let imagePickerVC = UIImagePickerController()
        //设置代理，实现选中相册相片
        imagePickerVC.delegate = self
        //3.弹出相册控制器
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    //MARK: - 懒加载
    ///输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        return try? AVCaptureDeviceInput(device: device!)
    }()
    ///会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    ///输出对象
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
//    private lazy var output: AVCaptureMetadataOutput = {
//        let out = AVCaptureMetadataOutput()
//        //设置输出对象解析数据感兴趣的范围
//        //默认值是(0,0,1,1)，通过对这个值观察，发现传入的是比例
//        //1.获取屏幕frame
//        let viewRect = self.view.frame
//        //2.获取臊面容器的frame
//        let containerRect = self.customContainerView.frame
//        let x = containerRect.origin.y / viewRect.height
//        let y = containerRect.origin.x / viewRect.width
//        let width = containerRect.height / viewRect.height
//        let height = containerRect.width / viewRect.width
//        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
//        return out
//    }()
    ///预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    ///专门用于保存描边的图层
    private lazy var containerLayer: CALayer = CALayer()
}


//MARK: - UITabBarDelegate
extension QRCodeViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //根据当前选中的按钮重新设置二维码容器高度
        containerHeightCons.constant = (item.tag == 1 ) ? 100 : 200
        view.layoutIfNeeded()
        //移除动画
        scanLineView.layer.removeAllAnimations()
        //重新开始动画
        startAnimation()
    }
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate{
    ///只要扫描到结果就会调用
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        //1.显示结果
        let object = metadataObjects.last
        //清空描边
//        clearLayers()
        guard let contentStr:String = (object as AnyObject).stringValue else {
            return
        }
        customLabel.text = contentStr
/*
        guard let metadata = metadataObjects.last else {
            return
        }
        //通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        //2.对扫描到的二维码进行描边
//        drawLines(objc: objc as! AVMetadataMachineReadableCodeObject)
        
    }
    */
    /*
    ///对扫描到的二维码进行描边
    private func drawLines(objc:AVMetadataMachineReadableCodeObject){
        
        //0.安全校验
        let pointCorners = objc.corners
//        let array = NSArray(object:pointCorners)
        
        //1.创建图层，用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        //2.创建UIBezierPath，绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        let arrayIndex = pointCorners[index]
        point = CGPoint.init(dictionaryRepresentation: (arrayIndex as! CFDictionary))!
        index += 1
        //2.1将七点移动到某一点
        path.move(to: point)
        //2.2连接其他线段
        while index < pointCorners.count {
            let arrayIndex = pointCorners[index]
            point = CGPoint.init(dictionaryRepresentation: (arrayIndex as! CFDictionary))!
            index += 1
            path.addLine(to: point)
        }
        //2.3关闭路径
        path.close()
        layer.path = path.cgPath
        //3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    ///清空描边
    private func clearLayers(){
        guard let subLayers = containerLayer.sublayers else{
            return
        }
        for layer in subLayers{
            layer.removeFromSuperlayer()
        }
    }
}
 */
}
}
//MARK: - 选中相册代理
extension QRCodeViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            return
        }
        guard let ciImage = CIImage(image: image) else{
            return
        }
        //2.从选中的图片中读取二维码
         //2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow])
         //2.2利用探测器探测数据
        let results = detector!.features(in: ciImage)
        //2.3取出探测到的数据
        for result in results {
            print((result as! CIQRCodeFeature).messageString)
        }
        //注意：实现了该方法，当选中一张图片时系统不会自动关闭相册控制器
        picker.dismiss(animated: true, completion: nil)
    }

}
