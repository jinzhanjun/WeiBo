//
//  Bundle+Extension.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/4/4.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
extension Bundle {
    static var nameSpace: String {
        
        return (main.infoDictionary!["CFBundleExecutable"] as! String) + "."
    }
}
