//
//  WBStatusToolBar.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/21.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    var statusBarModel: StatusModel? {
        didSet{
            if let model = statusBarModel {
                retweetButton.setTitle(checkCount(with: model.reposts_count, placeHolder: "转发"), for: .normal)
                criticalButton.setTitle(checkCount(with: model.comments_count, placeHolder: "评论"), for: .normal)
                likeButton.setTitle(checkCount(with: model.attitudes_count, placeHolder: "赞"), for: .normal)
            }
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetButton: UIButton!
    
    /// 评论
    @IBOutlet weak var criticalButton: UIButton!
    
    /// 赞
    @IBOutlet weak var likeButton: UIButton!
     
    /// 数量为0时,显示文字；数量大于10000时，显示 “XX万”
    private func checkCount(with number: Int?, placeHolder: String) -> String {
        if number == nil || number == 0 {
            return placeHolder
        } else if number! > 10000 {
            let number = Double(number!) / 10000
            
            let str = String(format: "%0.2f 万", number)
            return str
        }
        return placeHolder
    }
}
