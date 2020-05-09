//
//  WBComposeTypeView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/8.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import pop

class WBComposeView: UIView {
    
    /// 按钮滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    /// 返回按钮点击
    @IBAction func backButtonPressed() {
        removeBtnPopAnim()
    }
    /// 左箭头按钮
    @IBOutlet weak var backButton: UIButton!
    /// 左箭头按钮点击
    @IBAction func backBtnPressed() {
        
        backButtonCenterX.constant = 0
        buttonCenterX.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.layoutIfNeeded()
            self.backButton.alpha = 0
        }) { (_) in
            self.backButton.isHidden = true
        }
    }
    /// 左箭头中线点x的约束
    @IBOutlet weak var backButtonCenterX: NSLayoutConstraint!
    /// 返回按钮中心点X的约束
    @IBOutlet weak var buttonCenterX: NSLayoutConstraint!
    
    /// 完成回调闭包
    var completionBlock: ((_ clsName: String?) -> ())?
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]
    ]
    
    
    class func composeTypeView() -> WBComposeView {
        // 获取xib地址
        let nib = UINib(nibName: "WBComposeView", bundle: nil)

        // 实例化xib
        let instance = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeView
        // 返回实例
        return instance
    }
    
    // 展示self，完成回调后，根据点击的按钮来展示控制器！
    func show(completion: @escaping(_ clsName: String?) -> ()) {
        
        // 记录闭包
        completionBlock = completion
        
        let vc = UIApplication.shared.windows[0].rootViewController
        // 给整个View添加动画
        addViewPopAnim()
        vc?.view.addSubview(self)
    }
    
    /// 从XIB加载完成就调用此方法！！
    override func awakeFromNib() {
        setupUI()
    }
    
    private func setupUI() {
        // 强行布局，以获取正确的控件大小，永远不要手动调用 layoutSubviews
        // 要调用layoutIfNeeded，间接调用它
        layoutIfNeeded()
        
        let rect = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height))
        
        for i in 0..<2 {
            
            let v = UIView(frame: rect)
            
            v.frame = rect.offsetBy(dx: CGFloat(i) * scrollView.bounds.width, dy: 0)
            
            addComposeTypeView(in: v, idx: i * 6)
            
            scrollView.addSubview(v)
        }
        
        // 设置scrollView
        scrollView.contentSize = CGSize(width: 2 * scrollView.bounds.width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = false
    }
    
    /// 点击更多按钮
    @objc func clickMore() {
        backButtonCenterX.constant = -(self.scrollView.bounds.width / 6)
        buttonCenterX.constant = self.scrollView.bounds.width / 6
        backButton.alpha = 0
        backButton.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)
            self.backButton.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    private func addComposeTypeView(in view: UIView, idx: Int) {
        let count = 6
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            
            let info = buttonsInfo[i]
            
            guard let imageName = info["imageName"],
                let title = info["title"]
                else {
                return
            }
            
            let btn = WBComposeTypeView.composeTypeView()
            btn.imageView.image = UIImage(named: imageName)
            btn.titleLabel.text = title
            
            if let actionName = info["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else if let clsName = info["clsName"] {
                btn.clsName = clsName
                btn.addTarget(self, action: #selector(clickBtn(button:)), for: .touchUpInside)
            }
            view.addSubview(btn)
        }
        
        // 按钮视图的大小
        let btnSize = CGSize(width: 100, height: 100)
        // 间距
        let margin = (scrollView.bounds.width - 3 * btnSize.width) / 4
        
        for (idx, btn) in view.subviews.enumerated() {
            let col = idx % 3
            let y = (idx > 2) ? (margin + btnSize.height) : 0
            let x = CGFloat(col) * btnSize.width + CGFloat(col + 1) * margin
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
    }
    
    /// 点击展示控制器
    @objc private func clickBtn(button: WBComposeTypeView) {
        // 添加动画
        // 获取当前视图的buttons
        let page = Int(scrollView.contentOffset.y / scrollView.bounds.width)
        
        let v = scrollView.subviews[page]
        
        for (_, btn) in v.subviews.enumerated() {
            
            // 图标变大缩小动画
            let scaleAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale: CGFloat = (btn == button) ? 2 : 0.2
            // 需要将CGPoint 转为 id 类型
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))
            scaleAnim.duration = 0.25
            btn.pop_add(scaleAnim, forKey: nil)
            // 图标渐隐动画
            let alphAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphAnim.fromValue = 1
            alphAnim.toValue = 0
            alphAnim.duration = 0.25
            
            // 给任意一个btn添加完成回调，因为动画结束时间相同，任何一个动画添加回调都具有相同的效果
            if btn == button {
                alphAnim.completionBlock = { _, _ in
                    self.completionBlock?(button.clsName)
                }
            }
            pop_add(alphAnim, forKey: nil)
        }
    }
}

private extension WBComposeView {
    
    /// 整个View添加渐渐显示的动画！
    func addViewPopAnim() {
        // 添加渐渐显示动画
        let alpAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alpAnim.fromValue = 0
        alpAnim.toValue = 1
        alpAnim.duration = 0.25
        pop_add(alpAnim, forKey: nil)
        // 给内部btn添加逐个显示动画
        addBtnPopAnim()
    }
    /// 给btn添加逐个显示动画！
    func addBtnPopAnim() {
        // 页面
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        // 遍历v中的button
        for (idx, btn) in v.subviews.enumerated() {
            let alphAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphAnim.fromValue = 0
            alphAnim.toValue = 1
            btn.pop_add(alphAnim, forKey: nil)
            // 添加动画
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = btn.center.y + 400
            anim.toValue = btn.center.y
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(idx) * 0.025
            btn.pop_add(anim, forKey: nil)
        }
    }
    /// 移除视图的动画
    func removeViewPopAnim() {
        let alphAnim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        alphAnim.fromValue = 1
        alphAnim.toValue = 0
        alphAnim.duration = 0.1
        // 完成回调，移除视图
        alphAnim.completionBlock = { _, _ in
            self.removeFromSuperview()
        }
        pop_add(alphAnim, forKey: nil)
    }
    /// 移除btn 视图的动画
    func removeBtnPopAnim() {
        // 获取scrollView当前显示的子视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        // 遍历btn
        for (idx, btn) in v.subviews.enumerated() {
            
            let alphAnim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            alphAnim.fromValue = btn.center.y
            alphAnim.toValue = btn.center.y + 600
            alphAnim.springBounciness = 0
            alphAnim.springSpeed = 20
            alphAnim.velocity = 20
            alphAnim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - idx) * 0.025
            btn.pop_add(alphAnim, forKey: nil)
            
            // 给最后一个消失的btn添加完成回调，视图后续消失
            if idx == 0 {
                alphAnim.completionBlock = { _, _ in
                    self.removeViewPopAnim()
                }
            }
        }
    }
}
