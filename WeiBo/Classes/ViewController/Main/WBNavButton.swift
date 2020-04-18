//
//  WBNavButton.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/18.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBNavButton: UIButton {
    
    /// 重载函数
    required init(title: String?) {
        super.init(frame: CGRect(origin: .zero, size: .zero))
        
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            setTitle("\(title!)" + " ", for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        // 设置字体颜色
        setTitleColor(UIColor.darkGray, for: .normal)
        // 设置字体大小
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//        sizeToFit()
        
        // 设置点击
        addTarget(self, action: #selector(clicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func clicked() {
        isSelected = !isSelected
    }
    
    // 设置图片在文字右边
    override func layoutSubviews() {

        super.layoutSubviews()
        
        guard let imageViewBounds = imageView?.bounds,
            let titleBounds = titleLabel?.bounds
            else { return }

        imageView?.frame = CGRect(x: titleBounds.width, y: 7, width: imageViewBounds.width, height: imageViewBounds.height)

        titleLabel?.frame = CGRect(x: 0, y: 0, width: titleBounds.width, height: titleBounds.height)
    }
}
