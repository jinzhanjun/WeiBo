//
//  WBMTRefreshView.swift
//  WBRefreshControl
//
//  Created by jinzhanjun on 2020/5/6.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBMTRefreshView: WBRefreshView {

    /// 重写父视图高度属性
    override var superviewHeight: CGFloat? {
        didSet {
            
            if superviewHeight == nil {
                return
            }
            
            var scale = (superviewHeight! / refreshHeight) + 0.25
            
            if scale >= 1 {
                scale = 1
            }
            
            kangarooImage.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    /// 重写刷新状态属性
    override var refreshState: RefreshState {
        didSet {
            switch refreshState {
            case .Normal:
                // 移除所有动画
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    // 地球转动停止
                    self.earthImageView.layer.removeAllAnimations()
                    // 袋鼠跳跃停止
                    self.kangarooImage.image = UIImage(named: "icon_small_kangaroo_loading_1")
                    // 建筑停止跳动
                    self.buildingImageView.image = UIImage(named: "icon_building_loading_1")
                }
                
            case .Pulling:
                break
            case .WillRefresh:

                // 地球转动
                let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = -2 * Double.pi
                anim.duration = 3
                anim.repeatCount = HUGE
                anim.isRemovedOnCompletion = false
                earthImageView.layer.add(anim, forKey: nil)
                
                // 袋鼠跳跃
                let kangaroo1 = UIImage(named: "icon_small_kangaroo_loading_1")
                let kangaroo2 = UIImage(named: "icon_small_kangaroo_loading_2")
                kangarooImage.image = UIImage.animatedImage(with: [kangaroo1!, kangaroo2!], duration: 0.25)
                
                // 建筑跳动
                let building1 = UIImage(named: "icon_building_loading_1")
                let building2 = UIImage(named: "icon_building_loading_2")
                buildingImageView.image = UIImage.animatedImage(with: [building1!, building2!], duration: 0.5)
            }
        }
    }
    
    override func awakeFromNib() {
        // 设置 袋鼠 图片的锚点与frame的中心点
        // 锚点
        kangarooImage.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        let centerX = self.frame.width * 0.5
        let centerY = self.frame.height - 35
        // 中心点
        kangarooImage.center = CGPoint(x: centerX, y: centerY)
        
        // 设置初始化的 图片大小
        kangarooImage.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        
        super.awakeFromNib()
    }
    
    // 重写父类视图的方法，从 WBMeiTuanRefreshView.xib 中加载
    override class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBMeiTuanRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WBMTRefreshView
    }
    
    /// 美团地球图片
    @IBOutlet weak var earthImageView: UIImageView!
    /// 袋鼠图片
    @IBOutlet weak var kangarooImage: UIImageView!
    /// 建筑图片
    @IBOutlet weak var buildingImageView: UIImageView!
    
}
