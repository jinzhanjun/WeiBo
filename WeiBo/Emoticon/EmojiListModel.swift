//
//  EmojiListModel.swift
//  EmojiBundle
//
//  Created by jinzhanjun on 2020/5/11.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import Foundation
import YYModel

/// 表情包模型
class EmojiListModel: NSObject {
    
    /// 表情分组
    @objc var groupName: String?
    /// 表情组的字典
    @objc var directory:String? {
        didSet {
            guard let dir = directory,
                let bundlePath = Bundle.main.path(forResource: "HMEmoticon", ofType: ".bundle"),
                let emojiBundle = Bundle(path: bundlePath),
                let emojiInfoDir = emojiBundle.path(forResource: "info", ofType: ".plist", inDirectory: dir),
                let emojiArray = NSArray.init(contentsOfFile: emojiInfoDir),
            let emojiModelArray = NSArray.yy_modelArray(with: EmojiModel.self, json: emojiArray) as? [EmojiModel]
                else { return }
            
            self.emojiModelArray += emojiModelArray
        }
    }
    /// 表情组的背景图片
    @objc var bgImageName: String?
    
    /// 表情模型数组
    lazy var emojiModelArray: [EmojiModel] = [EmojiModel]()
    override var description: String {
        return self.yy_modelDescription()
    }
}
