//
//  String+Extension.swift
//  WeiBo
//
//  Created by jinzhanjun on 2020/5/14.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

extension String {
    func subString(range: NSRange?) -> String? {
        
        guard let range = range else {
            return nil
        }
        
        let startIndex = index(self.startIndex, offsetBy: range.location)
        let endIndex = index(startIndex, offsetBy: range.length)
        
        return String(self[startIndex..<endIndex])
    }
}
