//
//  EmojiModel.swift
//  EmojiBundle
//
//  Created by jinzhanjun on 2020/5/11.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation

/// 表情模型
class EmojiModel: NSObject {
    /// 表情-简体中文
    @objc var chs: String?
    /// 表情-繁体中文
    @objc var cht: String?
    /// gif图片名称
    @objc var gif: String?
    /// png图片名称
    @objc var png: String?
    /// 类型
    @objc var type: String?
    /// 表情字符
    @objc var code: String? {
        didSet {
            guard let code = code else { return }
            // 字符串转16进制
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            codeEmoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    var codeEmoji: String?
    
    /// 表情包名称
    var packageName: String?
    
    /// 点击次数
    var times: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}
