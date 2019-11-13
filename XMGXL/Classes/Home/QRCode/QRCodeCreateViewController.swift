//
//  QRCodeCreateViewController.swift
//  XMGXL
//
//  Created by 孙 on 2019/11/13.
//  Copyright © 2019 小情调. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {
    ///二维码容器
    @IBOutlet weak var customImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        //2.还原滤镜默认属性
        filter?.setDefaults()
        //3.设置需要生成二维码的数据到滤镜中
        filter?.setValue("小情调".data(using: String.Encoding.utf8), forKey: "inputMessage")
        //4.从滤镜中取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else {
            return
        }
//        customImageView.image = UIImage(ciImage: ciImage)
        customImageView.image = createNonInterpolatedUIImageFormCIImage(image: ciImage, size: 300)
    }

    //转化为高清二维码图片
    private func createNonInterpolatedUIImageFormCIImage(image:CIImage, size: CGFloat) ->UIImage{
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        //1.创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil,width: Int(width),height: Int(height),bitsPerComponent: 8,bytesPerRow: 0,space: cs,bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale,y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        
        //2.保存bitmap到图片
        let scaledImage:CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }
}
