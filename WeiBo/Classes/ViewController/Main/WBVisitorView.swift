//
//  WBVisitorView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/6.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBVisitorView: UIView {
    
    
    // 添加注册、登录按钮
    lazy var registBtn: UIButton = UIButton.cz_textButton("注册", fontSize: 16, normalColor: UIColor.orange, highlightedColor: UIColor.orange, backgroundImageName: "common_button_white_disable")
    lazy var loginBtn: UIButton = UIButton.cz_textButton("登录", fontSize: 16, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange, backgroundImageName: "common_button_white_disable")
    
    // 信息字典，用来配置界面
    var infoDic: [String: String]?{
        didSet {
            setupWithDic()
        }
    }
    
    // 旋转图案
    private lazy var iconImage = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // 主页标语
    private lazy var tipsLabel = UILabel()
    // 主页标志
    private lazy var houseImage = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // 遮罩图像
    private lazy var maskWBImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置界面
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// 根据字典配置界面
    private func setupWithDic() {
        
        guard let imageName = infoDic?["imageName"],
        let message = infoDic?["message"]
            else { return }
        
        if imageName == "" {
            return
        }
        // 隐藏旋转图标
        iconImage.isHidden = true
        // 隐藏遮罩层
        maskWBImageView.isHidden = true
        // 设置主页标志
        houseImage.image = UIImage(named: imageName)
        // 设置主页标语
        tipsLabel.text = message
    }
    
    /// 设置界面
    private func setupUI() {
        
        tipsLabel.text = "关注一些人，能够看到他们的往事！"

        tipsLabel.textAlignment = .center
        tipsLabel.numberOfLines = 0
        addSubview(iconImage)
        addSubview(maskWBImageView)
        addSubview(houseImage)
        addSubview(tipsLabel)
        addSubview(registBtn)
        addSubview(loginBtn)
        
        // 旋转图标转动
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 10
        animation.repeatCount = HUGE
        // 解决跳转后动画停止的问题
        animation.isRemovedOnCompletion = false
        iconImage.layer.add(animation, forKey: nil)
        
        // icomImage的中心点X
        addConstraint(NSLayoutConstraint(
            item: iconImage,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        
        // icomImage的中心点Y
        addConstraint(NSLayoutConstraint(
            item: iconImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: -100))

        
        // houseImage的中心点X
        addConstraint(NSLayoutConstraint(
            item: houseImage,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        
        // houseImage的中心点Y
        addConstraint(NSLayoutConstraint(
            item: houseImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0))

        // tipsLabel的中心点X
        addConstraint(NSLayoutConstraint(
            item: tipsLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0))
        // tipsLabel的中心点Y
        addConstraint(NSLayoutConstraint(
            item: tipsLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: iconImage,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 20))
        // tipsLabel的宽度
        addConstraint(NSLayoutConstraint(
            item: tipsLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 246))
        
        // 注册按钮位置X
        addConstraint(NSLayoutConstraint(
            item: registBtn,
            attribute: .leading,
            relatedBy: .equal,
            toItem: tipsLabel,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0))
        // 注册按钮位置Y
        addConstraint(NSLayoutConstraint(
            item: registBtn,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipsLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        // 注册按钮的宽度
        addConstraint(NSLayoutConstraint(
            item: registBtn,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 100))
        
        // 登录按钮位置X
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: tipsLabel,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0))
        // 登录按钮位置Y
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .top,
            relatedBy: .equal,
            toItem: tipsLabel,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
        // 登录按钮的宽度
        addConstraint(NSLayoutConstraint(
            item: loginBtn,
            attribute: .width,
            relatedBy: .equal,
            toItem: registBtn,
            attribute: .width,
            multiplier: 1.0,
            constant: 0))
        
        // maskImage的宽度
        addConstraint(NSLayoutConstraint(
            item: maskWBImageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: 0))
        // maskImage的位置Y采用VFL
        let viewDic: [String: UIView] = ["maskWBImageView": maskWBImageView, "loginBtn": loginBtn]
        let metrics = ["spacing": -30]
        let VFLContraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[maskWBImageView]-(spacing)-[loginBtn]",
            options: [],
            metrics: metrics,
            views: viewDic)
        addConstraints(VFLContraint)
    }
}
