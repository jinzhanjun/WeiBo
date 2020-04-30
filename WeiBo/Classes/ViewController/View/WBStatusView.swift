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

    /// 底部工具栏视图
    @IBOutlet weak var WBStatusToolBar: WBStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
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
            
            // 设置微博内容
            statusLabel.text = model.statusModel.text
            
            // 设置转发微博内容
            if viewModel?.statusModel.retweeted_status != nil {
                let retWeetedStatus = viewModel!.statusModel.retweeted_status
                
                retweetStatusLabel?.text = "@\(retWeetedStatus!.user?.screen_name ?? ""): " + (retWeetedStatus?.text ?? "")
            }
            
            // 根据配图数量确定配图视图高度
            pictureView.viewModel = model
            // 设置工具栏
            WBStatusToolBar.statusBarModel = model
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
    
    /// 转发微博内容
    @IBOutlet weak var retweetStatusLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // 栅格化，滚动的时候，cell以图片的形式，停止后，恢复
        layer.shouldRasterize = true
        
        layer.rasterizationScale = UIScreen.main.scale
    }
}
