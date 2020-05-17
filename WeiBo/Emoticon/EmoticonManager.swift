//
//  EmoticonManager.swift
//  EmojiBundle
//
//  Created by jinzhanjun on 2020/5/11.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
import YYModel

class EmoticonManager {
    
    /// 只加载一次，单例模式
    static let shared = EmoticonManager()
    /// 懒加载表情包模型数组
    lazy var emojiListModel: [EmojiListModel] = [EmojiListModel]()
    
    /// 不允许外币调用初始化方法，只能通过单例方式访问
    private init() {
        self.fetchEmojis()
    }
    
    /// 正则表达式，过滤表情文字，并且返回表情符号
    func getEmojiText(with str: String?, for statusFont: UIFont) -> NSAttributedString? {
        
        guard let str = str else { return nil}
        
        /// 正则表达式
        let pattern = "\\[.*?\\]"
        
        guard let rgx = try? NSRegularExpression(pattern: pattern, options: [])
            else { return nil}
        
        let result = rgx.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
        
        let mutableAttriStr = NSMutableAttributedString(string: str)
        
        /// 遍历结果
        for r in result.reversed() {
            let range = NSRange(location: r.range(at: 0).location, length: r.range(at: 0).length)
            
            guard let emojiChs = str.subString(range: range),
                let emojiName = getEmojiName(by: emojiChs),
                let emojiBundlePath = Bundle.main.path(forResource: "HMEmoticon", ofType: ".bundle"),
                let emojiBundle = Bundle(path: emojiBundlePath),
                let image = UIImage(named: emojiName.fileName + "/" + emojiName.pngName, in: emojiBundle, with: nil)
                else { return nil }
            
            let attachment = NSTextAttachment(image: image)
            
            attachment.bounds = CGRect(x: 0, y: -4, width: statusFont.lineHeight, height: statusFont.lineHeight)
            let attrStr = NSAttributedString(attachment: attachment)
            
            mutableAttriStr.replaceCharacters(in: r.range(at: 0), with: attrStr)
        }
        
        mutableAttriStr.addAttributes([NSAttributedString.Key.font: statusFont], range: NSRange(location: 0, length: mutableAttriStr.length))
        
        return mutableAttriStr
    }
    
    
    func fetchEmojis() {
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let emojiBundle = Bundle(path: path),
            let dict = emojiBundle.path(forResource: "emoticons", ofType: ".plist"),
            let array = NSArray(contentsOfFile: dict) as? [[String: String]],
            let modelArray = NSArray.yy_modelArray(with: EmojiListModel.self, json: array) as? [EmojiListModel]
            else { return }
        emojiListModel += modelArray
    }
    
    /// 给 emojiPngName 添加 Bundle 名称
    
    
    
    /// 根据字符返回表情 PNG 名称 与 所在 表情组名称
    func getEmojiName(by text: String) -> (fileName: String, pngName: String)? {
        
        var emojiPngName: (String, String)?
        // 遍历模型数组字典
        for emojiModel in emojiListModel {
            let result = emojiModel.emojiModelArray.filter{ $0.chs == text }
            
            if result.count != 0 {
                if emojiModel.directory != nil || result[0].png != nil {
                    emojiPngName = (emojiModel.directory!, result[0].png!)
                }
            } else {
                continue
            }
        }
        return emojiPngName
    }
}
