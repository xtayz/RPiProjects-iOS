//
//  Button.swift
//  RPiProject
//
//  Created by wonderworld on 16/8/25.
//  Copyright © 2016年 haozhang. All rights reserved.
//

import UIKit

/// 圆角按钮
@IBDesignable
class Button: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var normalBackgroundColor: UIColor! {
        didSet {
            setBackgroundImage(normalBackgroundColor.toImage(CGSize(width: 1, height: 1)), forState: .Normal)
        }
    }

}

extension UIColor {
    
    /**
     *  颜色转图片
     *  - parameter color: 图片颜色
     *  - parameter size:  图片尺寸
     */
    func toImage(size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}