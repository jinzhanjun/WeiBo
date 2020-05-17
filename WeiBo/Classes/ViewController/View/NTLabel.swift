//
//  NTLabel.swift
//  正则表达式
//
//  Created by jinzhanjun on 2020/5/12.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit
class NTLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextManager()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        /// 设置接管 Label text 的控制器
        setupTextManager()
    }
    /// 属性文本
    override var attributedText: NSAttributedString? {
        didSet {
            // 更新 属性文本
            updateAttriText(with: attributedText)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textContainer?.size = bounds.size
    }
    
    /// 在此接管(重写原draw的方法，但是不实现父类方法)
    override func drawText(in rect: CGRect) {
        /// 绘制 富文本
        textLayoutManager?.drawGlyphs(forGlyphRange: NSRange(location: 0, length: attributedText?.length ?? 0), at: CGPoint.zero)
    }
    
    /// 更新 属性文本
    private func updateAttriText(with attriStr: NSAttributedString?) {
        // 设置 表情 range 数组
//        setEmojiTextRange(with: attriStr)
        // 设置 url range 数组
        setUrlTextRange(with: attriStr)
        
        
        guard let attriText = attriStr else { return }
        
        let mutableAttrString = NSMutableAttributedString(attributedString: attriText)
        
        for range in urlRanges ?? [] {
            
            let urlAttris = [NSAttributedString.Key.foregroundColor: UIColor.blue]
            
            mutableAttrString.addAttributes(urlAttris, range: range)
        }
        
        
//        /// 根据 range 替换渲染内容，表情字符转换为表情
//        for range in emojiRanges?.reversed() ?? [] {
//            /// 获取 属性文本在 range 的 字符串
//            let subStr = attriText.subString(in: range)
//
//            guard  let emojiBundlePath = Bundle.main.path(forResource: "HMEmoticon", ofType: ".bundle"),
//                let emojiName = getEmoji(with: subStr),
//                let emojiBundle = Bundle(path: emojiBundlePath),
//
//                let image = UIImage(named: emojiName.0 + "/" + emojiName.1, in: emojiBundle, compatibleWith: nil)
//                else { return }
//
//            let attachment = NSTextAttachment(image: image)
//            let height = font.lineHeight
//            attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
//            let attriString = NSAttributedString(attachment: attachment)
//            // 替换 range 内的内容
//            mutableAttrString.replaceCharacters(in: range, with: attriString)
//        }
//
        mutableAttrString.addAttributes([NSAttributedString.Key.font: font!], range: NSRange(location: 0, length: mutableAttrString.string.count))

        textStorage?.setAttributedString(mutableAttrString)
////        attributedText = mutableAttrString
        // 重新绘制
        setNeedsDisplay()
    }
    
    /// 文本内容存储器
    var textStorage: NSTextStorage?
    /// 文本布局管理器
    var textLayoutManager: NSLayoutManager?
    /// 文本绘制区域管理器
    var textContainer: NSTextContainer?
    /// 过滤出来的 url Range
    lazy var urlRanges: [NSRange]? = [NSRange]()
    
    /// 准备接管Label的text管理器
    private func setupTextManager() {
        // 开启用户交互，实现点击事件
        self.isUserInteractionEnabled = true
        
        // 实例化 text 内容存储器
        textStorage = NSTextStorage()
        // 实例化 text 布局管理器
        textLayoutManager = NSLayoutManager()
        // 实例化 text 绘制区域
        textContainer = NSTextContainer()
        // 关联 text 管理器
        textStorage?.addLayoutManager(textLayoutManager!)
        textLayoutManager?.addTextContainer(textContainer!)
        
//        textContainer?.lineBreakMode = .byWordWrapping
        textContainer?.lineFragmentPadding = 0
    }
    
    /// 正则表达式，过滤表情文字，并且返回表情符号
//    private func setEmojiTextRange(with attriStr: NSAttributedString?) {
//        // 清空所有，避免错误
//        emojiRanges?.removeAll()
//
//        guard let attriText = attriStr else { return }
//
//        /// 正则表达式
//        let pattern = "\\[.*?\\]"
//
//        guard let rgx = try? NSRegularExpression(pattern: pattern, options: [])
//            else { return }
//
//        let result = rgx.matches(in: attriText.string, options: [], range: NSRange(location: 0, length: attriText.length))
//
//        /// 遍历结果
//        for r in result {
//            let range = NSRange(location: r.range(at: 0).location, length: r.range(at: 0).length)
//            emojiRanges?.append(range)
//        }
//    }
    
    /// 根据 url 正则表达式，过滤 url range ，并添加到 urlRanges 数组
    private func setUrlTextRange(with attriStr: NSAttributedString?) {
        // 移除所有 range
        urlRanges?.removeAll()
        
        guard let attriText = attriStr else { return }
        
        let pattern = "(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
        
        guard let rgx = try? NSRegularExpression(pattern: pattern, options: [])
            else { return }
        
        // 获取匹配结果
        let result = rgx.matches(in: attriText.string, options: [], range: NSRange(location: 0, length: attriText.length))
        
        // 遍历结果，添加到数组中
        for r in result {
            urlRanges?.append(r.range(at: 0))
        }
    }
    
//    /// 根据 表情字符串 获取对应表情的文件夹和图片名称
//    private func getEmoji(with text: String) -> (String, String)? {
//        let emojiManager = EmoticonManager.shared
//        return emojiManager.getEmojiName(by: text)
//    }
    
    /// Label 的点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// 确保存在textLayoutManager
        guard let textLayoutManager = self.textLayoutManager
            else { return }
        
        // 确定是否点击了，url所在区域
        for touch in touches {
            // 计算点击在 label 的位置
            let location  = touch.location(in: self)
            // 根据点击的位置确定字符的 index
            let glyphIndex = textLayoutManager.glyphIndex(for: location, in: textContainer!)
            // 根据字符的 index ，确定字符的rect
            let glyphRect = textLayoutManager.boundingRect(forGlyphRange: NSMakeRange(glyphIndex, 1), in: self.textContainer!)
            // 判断字符的rect 是否包含了点击的位置
            if glyphRect.contains(location) {
                // 包含了字符的rect
                // 获取字符Index
                let characterIndex = textLayoutManager.characterIndexForGlyph(at: glyphIndex)
                
//                print(characterIndex)
//                let character = (textStorage.string as NSString).character(at: characterIndex)
                
                for r in urlRanges ?? [] {
                    
                    print(r)
                    if r.contains(characterIndex) {
//                        let urlStr = attributedText?.subString(in: r)
//                        print("点击了url: \(urlStr)")
                    } else {
                        print("点击了字符")
                    }
                }
                
            } else {
                // 点击到了空白位置
                print("点击到了空白位置！")
                
            }
        }
    }
    
    
}

extension NSAttributedString {
    func subString(in range: NSRange) -> String {
        
        let startIndex = string.index(string.startIndex, offsetBy: range.location)
        let endIndex = string.index(startIndex, offsetBy: range.length)
        
        let subStr = String(string[startIndex..<endIndex])
        
        return subStr
    }
}
