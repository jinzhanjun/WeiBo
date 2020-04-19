//
//  WBNewVersionView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/18.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import SDWebImage

class WBWelcomeView: UIView {
    // 头像
    @IBOutlet weak var avatarImage: UIImageView!
    // 欢迎Label
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // 头像top约束
    @IBOutlet weak var avatarTop: NSLayoutConstraint!
    
    
    class func view() -> WBWelcomeView {
        
        // 从XIB中加载
        let instence = Bundle.main.loadNibNamed("WBWelcomeView", owner: self, options: nil)?.first as? WBWelcomeView
        return instence!
    }
    
    
    /// 此方法是从二进制数据读取到内存后调用的方法，此时IBOutlet还没有连接，无法读取avataImage、welcomeLabel、avatarTop三个控件
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        print(welcomeLabel)
//    }
    
//
//    override func willMove(toWindow newWindow: UIWindow?) {
//        super.willMove(toWindow: newWindow)
//
//        print(welcomeLabel)
//    }
    
    override func awakeFromNib() {
                
        guard let urlStr = WBNetWorkingController.shared.userAccount.avatar_large,
            let url = URL(string: urlStr) else {
                return
        }
        avatarImage.setImageWith(url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 设置圆角
//        avatarImage.layer.cornerRadius = 10
    }
    
    
    /// 已经移动到窗口上
    override func didMoveToWindow() {
        
        avatarTop.constant = bounds.height - 700
        
        UIView.animate(withDuration: 1.5, animations: {
            self.layoutSubviews()
        }) { (_) in
            
            UIView.animate(withDuration: 1.5, animations: {
                self.welcomeLabel.alpha = 1
            }) { (isComplete) in
                if isComplete {
                    self.removeFromSuperview()
                }
            }
        }
    }
}
