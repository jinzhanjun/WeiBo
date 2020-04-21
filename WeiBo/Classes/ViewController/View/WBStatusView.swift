//
//  WBStatusView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/21.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

/// 微博Cell
class WBStatusView: UITableViewCell {
    
    
    @IBOutlet weak var WBStatusToolBar: WBStatusToolBar!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            guard let model = self.viewModel,
                let profileImageUrlStr = model.statusModel.user?.profile_image_url
                else { return }
            
            // 设置头像
            avatarImageView.jj_image(with: URL(string: profileImageUrlStr), by: nil, placeholderImage: UIImage(named: "avatar_default_big"))
            
            // 设置昵称
            nameLabel.text = model.statusModel.user?.screen_name
            
            // 设置VIP图标
            vipImageView.image = model.memberIcon
            
            // 设置
            
            // 设置微博内容
            statusLabel.text = model.statusModel.text
            
            // 设置工具栏
            WBStatusToolBar.statusBarModel = model.statusModel
        }
    }
    
    /// 头像图片视图
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// VIP 图标
    @IBOutlet weak var vipImageView: UIImageView!
    
    /// 时间标签
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 微博来源标签
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 微博内容
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
