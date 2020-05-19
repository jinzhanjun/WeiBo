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
    
    /// 声明最多表情数量
    let MAXNumberOfEmojis = 20
    
    /// 表情分组
    @objc var groupName: String?
    
    /// 表情页面数量(每一页最多20个表情)
    var pagesNumber: Int? {
        get {
            
            let emojiCount = emojiModelArray.count
            
            let pagesNumber = (emojiCount - 1) / 20 + 1
            
            return pagesNumber
        }
    }
    
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
    
    /// 根据 pageNumber 返回 模型数组
    func modelInPage(pageNumber: Int) -> [EmojiModel] {
        
        let location = pageNumber * MAXNumberOfEmojis
        
        // 如果大于20就选择20，如果小于20，就选择剩余模型
        let length = ((emojiModelArray.count - location) > 20) ? 20 : emojiModelArray.count - location
        
        
        // 截取模型数组
        let subArray = (emojiModelArray as NSArray).subarray(with: NSRange(location: location, length: length))
        
        return subArray as! [EmojiModel]
        
    }
    override var description: String {
        return self.yy_modelDescription()
    }
}
