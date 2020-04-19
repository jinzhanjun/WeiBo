//
//  WBNewVersionView.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/19.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBNewVersionView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        
    }
    
    // 图片数量
    let NewPicCount = 4
    
    class func view()-> WBNewVersionView {
        // 从XIB中加载
        let instence = Bundle.main.loadNibNamed("WBNewVersionView", owner: self, options: nil)?.first as? WBNewVersionView

        return instence!
    }
    
    // 激活控件
    override func awakeFromNib() {
        setupUI()
        
        enterButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }

    // 设置界面
    private func setupUI() {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - safeAreaInsets.bottom - safeAreaInsets.top))
        
        scrollView.contentSize = CGSize(width: rect.width * CGFloat(NewPicCount + 1), height: scrollView.bounds.height)
        
        for i in 1..<NewPicCount + 1 {
            
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = UIImage(named: "new_feature_\(i)")
            imageView.contentMode = .scaleToFill
            
            imageView.frame = imageView.frame.offsetBy(dx: imageView.bounds.width * CGFloat(i-1), dy: 0)
            scrollView.addSubview(imageView)
        }
        // 设置代理
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
    }
    
    @objc private func closeView() {
        removeFromSuperview()
    }
    
    //MARK: - scrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        enterButton.isHidden = true
        pageIndicator.isHidden = false
        
        let pageNumber = Int((scrollView.contentOffset.x / UIScreen.main.bounds.width) + 0.5)
        
        pageIndicator.currentPage = Int(pageNumber)
        
        if pageNumber == NewPicCount - 1 {
            enterButton.isHidden = false
        }
        if pageNumber == NewPicCount {
            enterButton.isHidden = true
            pageIndicator.isHidden = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        
        if pageNumber == NewPicCount {
            closeView()
        }
    }
    
    
}
