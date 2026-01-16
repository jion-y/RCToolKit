//
//  CustomButton.swift
//  RCToolKit
//
//  Created by yoyo on 2025/12/29.
//

import Foundation
public class CustomButton: UIButton {

     
    public   var imageSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var spacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = self.imageView,
              let titleLabel = self.titleLabel else { return }
        
        // 设置图片大小
        imageView.frame.size = imageSize
        
        // 计算新的位置
        let imageWidth = imageSize.width
        let titleWidth = titleLabel.frame.width
        let totalWidth = imageWidth + spacing + titleWidth
        
        // 水平居中
        let startX = (self.bounds.width - totalWidth) / 2
        
        // 更新图片位置
        var imageFrame = imageView.frame
        imageFrame.origin.x = startX
        imageFrame.origin.y = (self.bounds.height - imageSize.height) / 2
        imageView.frame = imageFrame
        
        // 更新标题位置
        var titleFrame = titleLabel.frame
        titleFrame.origin.x = startX + imageWidth + spacing
        titleFrame.origin.y = (self.bounds.height - titleFrame.height) / 2
        titleLabel.frame = titleFrame
    }
}
