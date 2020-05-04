//
//  WBRefreshController.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

/// 刷新临界点
let refreshHeight: CGFloat = 80

/// 下拉刷新控制器
class WBRefreshController: UIControl {
    
    /// 父视图
    var scrollView: UIScrollView?
    
    /// 子视图
    lazy var refreshView = WBRefreshView.refreshView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    /// 将要被添加到父视图
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 判断父视图是否为 scrollView
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        // 监听scrollView的滚动情况
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    deinit {
        // 销毁时移除监听
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 判断父视图是否存在
        guard let sv = scrollView else { return }
        
        // 计算视图下拉的高度
        let height = -sv.contentOffset.y - sv.adjustedContentInset.top
        
        if height < 0 {
            return
        }
        
        // 根据下拉情况调整 frame
        let rect = CGRect(origin: CGPoint(x: 0, y: -height), size: CGSize(width: sv.bounds.width, height: height))
        
        frame = rect
        
        // 如果正在拖拽
        if sv.isDragging {
            
            if height > refreshHeight && refreshView.refreshState == .Normal {
                // 改变刷新状态为 将要刷新
                refreshView.refreshState = .Pulling
            } else if height <= refreshHeight && refreshView.refreshState == .Pulling {
                // 改变刷新状态为 正常
                refreshView.refreshState = .Normal
            }
        } else {
            if refreshView.refreshState == .Pulling {
                print("刷新")
                
                refreshView.refreshState = .WillRefresh
                
                // 开始刷新
                beginRefreshing()
                
                
            }
        }
    }
    
    /// 从XIB中设置界面
    private func setupUI() {
        clipsToBounds = true
        /// 添加视图
        addSubview(refreshView)
        
        // 布局
        // 取消自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(
            item: refreshView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: refreshView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0))
        addConstraint(NSLayoutConstraint(
            item: refreshView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(
            item: refreshView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: refreshView.bounds.height))
        
    }
    /// 结束刷新
    func endRefreshing() {
        
    }
    /// 开始刷新
    func beginRefreshing() {
        
        sendActions(for: .valueChanged)
        
        // 完成后就恢复为下拉刷新
        refreshView.refreshState = .Normal
    }
}
