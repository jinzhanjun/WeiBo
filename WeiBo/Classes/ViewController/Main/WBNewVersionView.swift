//
//  WBNewVersionView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/18.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import SDWebImage

class WBNewVersionView: UIView {
    // 头像
    @IBOutlet weak var avatarImage: UIImageView!
    // 欢迎Label
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // 头像top约束
    @IBOutlet weak var avatarTop: NSLayoutConstraint!
    
    
    class func wbNewVersionView() -> WBNewVersionView {
        
        // 从XIB中加载
        let instence = Bundle.main.loadNibNamed("NewVersionView", owner: nil, options: nil)?.first as? WBNewVersionView
        
        let urlStr = WBNetWorkingController.shared.userAccount.avatar_large
        let url = URL(string: urlStr ?? "")
        
        instence?.avatarImage.setImageWith(url!, placeholderImage: UIImage(named: "avatar_default_big"))
        return instence!
    }
    
    override func didMoveToWindow() {
        
        avatarTop.constant = bounds.height - 700
        
        UIView.animate(withDuration: 2, animations: {
            self.layoutSubviews()
        }) { (_) in
            
            UIView.animate(withDuration: 1) {
                self.welcomeLabel.alpha = 1
            }
        }
    }
    
    
}
