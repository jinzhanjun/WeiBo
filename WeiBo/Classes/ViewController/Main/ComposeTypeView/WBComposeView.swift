//
//  WBComposeTypeView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/8.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBComposeView: UIView {
    
    
    /// 返回按钮点击
    @IBAction func backButtonPressed() {
        self.removeFromSuperview()
    }
    
    
    class func composeTypeView() -> WBComposeView {
        // 获取xib地址
        let nib = UINib(nibName: "WBComposeView", bundle: nil)

        // 实例化xib
        let instance = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeView
        // 返回实例
        return instance
    }
    
    func show() {
        let vc = UIApplication.shared.windows[0].rootViewController
        
        vc?.view.addSubview(self)
    }

}
