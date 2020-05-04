//
//  WBRefreshView.swift
//  WBRefreshControl
//
//  Created by jinzhanjun on 2020/5/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

/// 刷新状态
enum RefreshState {
    
    init() {
        self = .Normal
    }
    
    // 下拉未超过刷新临界点
    case Normal
    // 下拉已超过刷新临界点
    case Pulling
    // 放手即将刷新中
    case WillRefresh
}


class WBRefreshView: UIView {
    
    /// 刷新状态
    var refreshState = RefreshState() {
        didSet {
            switch refreshState {
                
            case .Normal:
                tipLabel.text = "下拉刷新"
                tipLabel.sizeToFit()
                
                UIView.animate(withDuration: 0.25) {
                    self.arrowDown.transform = CGAffineTransform(rotationAngle: 0)
                }
                
            case .Pulling:
                tipLabel.text = "放手刷新"
                tipLabel.sizeToFit()
                
                UIView.animate(withDuration: 0.25) {
                    self.arrowDown.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.001))
                }
                
                
            case .WillRefresh:
                tipLabel.text = "正在刷新"
                tipLabel.sizeToFit()
                
                
            }
        }
    }
    
    /// 下拉提示标签
    @IBOutlet weak var tipLabel: UILabel!

    /// 刷新指示箭头
    @IBOutlet weak var arrowDown: UIImageView!
    /// 从xib中加载视图
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBRefreshView
    }
}
