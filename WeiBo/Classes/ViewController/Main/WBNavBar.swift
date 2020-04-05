//
//  WBNavBar.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class WBNavBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.subviews {
            let stringFromClass = NSStringFromClass(subview.classForCoder)
            
            if stringFromClass.contains("BarBackground") {
                subview.frame = self.bounds
            } else if stringFromClass.contains("UINavigationBarContentView") {
                subview.frame = CGRect(x: 0, y: 44, width: UIScreen.cz_screenWidth(), height: 44)
            }
        }
    }
}
