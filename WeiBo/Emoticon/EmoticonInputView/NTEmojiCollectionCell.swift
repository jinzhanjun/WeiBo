//
//  NTEmojiCollectionCell.swift
//  emojiInput
//
//  Created by jinzhanjun on 2020/5/19.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

protocol NTEmojiCollectionCellDelegate: NSObjectProtocol {
    /// 点击表情按钮代理方法
    func emojiCollectionCellDidClicked(cell: NTEmojiCollectionCell, emojiModel: EmojiModel?) -> Void
    
    
}

class NTEmojiCollectionCell: UICollectionViewCell {
    
    /// 代理属性 (需要使用 weak， 否则会循环引用，造成内存泄漏！)
    weak var delegate: NTEmojiCollectionCellDelegate?
    
    /// 懒加载只加载一次，存储在常量区，每次调用同一个内存地址。
    lazy var tipImageView: NTEmojiTipView = NTEmojiTipView()
    
    /// 两侧边距
    let sideMargin = 8
    /// 底部边距
    let bottomMargin = 16
    /// 移除按钮
    var removeBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        
        guard let window = newWindow else {
            return
        }
        
        // 添加表情提示视图
        window.addSubview(tipImageView)
        // 隐藏表情提示视图
        tipImageView.isHidden = true
    }
    
    
    /// 表情模型数组
    var emojiModels: [EmojiModel]? {
        didSet {
            
            // 隐藏所有按钮
            contentView.subviews.forEach{ $0.isHidden = true }
            
            // 显示最后一个按钮
            removeBtn?.isHidden = false
            
            // 遍历数组创建表情按钮
            for (i, model) in (emojiModels ?? []).enumerated(){
                if let btn = contentView.subviews[i] as? UIButton {
                    btn.setImage(model.image, for: .normal)
                    
                    btn.setTitle(model.codeEmoji, for: .normal)
                    btn.isHidden = false
                }
            }
        }
    }
    
    private func setupUI() {
        
        // 列数
        let colum = 7
        // 计算单个表情 size
        let width = (bounds.width - CGFloat(2 * sideMargin)) / CGFloat(colum)
                
        for i in 0...20 {
            
            let btn = UIButton()
            
            btn.tag = i
            
            // 计算所在行数
            let row = i / colum + 1
            // 计算所在列数
            let col = i % colum
            
            let x = CGFloat(sideMargin) + CGFloat(col) * width
            let y = CGFloat(row - 1) * width
            
            btn.frame = CGRect(x: x, y: y, width: width, height: width)
            
            contentView.addSubview(btn)
            // 隐藏按钮
            btn.isHidden = true
            // 设置监听方法
            btn.addTarget(self, action: #selector(emojiBtnClicked(button:)), for: .touchUpInside)
            
            // 除去最后一个按钮，删除按钮不添加长按手势
            if i != 20 {
                /// 添加长按手势
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(emojiLongPressed(gesture:)))
                // 长按时间
                longPress.minimumPressDuration = 0.1
                // 添加手势
                btn.addGestureRecognizer(longPress)
            }
        }
        
        removeBtn = contentView.subviews.last as? UIButton
        
        guard let bundlePath = Bundle.main.path(forResource: "HMEmoticon", ofType: ".bundle"),
        let emojiBundle = Bundle(path: bundlePath)
            else { return }
        
        
        let backImage = UIImage(named: "compose_emotion_delete", in: emojiBundle, with: nil)
        let backImageHL = UIImage(named: "compose_emotion_delete_highlighted", in: emojiBundle, with: nil)
        removeBtn?.setImage(backImage, for: .normal)
        removeBtn?.setImage(backImageHL, for: .highlighted)
        removeBtn?.setImage(backImageHL, for: .selected)
        
    }
    
    /// 表情长按
    @objc private func emojiLongPressed(gesture: UILongPressGestureRecognizer) {
        // 首先隐藏表情提示视图
        tipImageView.isHidden = true
        
        
        switch gesture.state {
        case .began, .changed:
            
            // 设置表情提示视图的位置
            // 识别点击的表情
            let location = gesture.location(in: self)
            
            // 遍历表情(一定要用contentView)
            let selectedEmoji = contentView.subviews.filter{ $0.frame.contains(location) }
            
            guard let emojiButton = selectedEmoji.first as? UIButton else { return }
            
            // 转换坐标系
            let center = self.convert(emojiButton.center, to: window)
            // 设置坐标位置
            tipImageView.center = center
            // 设置模型
            // 如果不是删除按钮
            if emojiButton.tag < emojiModels?.count ?? 0 {

                // 显示表情提示视图
                tipImageView.isHidden = false
                tipImageView.emojiModel = emojiModels?[emojiButton.tag]
            }
        
        default:
            break
        }
    }
    
    /// 点击表情按钮
    @objc private func emojiBtnClicked(button: UIButton) {
        let tag = button.tag
        /// 表情模型
        var emojiModel: EmojiModel?
        if tag < 20 {
            
            // 记录表情的点击次数
            emojiModels?[tag].times += 1
            
            // 表情按钮
            emojiModel = emojiModels?[tag]
        } else {
            // 删除按钮
            emojiModel = nil
        }
        
        // 执行代理方法
        delegate?.emojiCollectionCellDidClicked(cell: self, emojiModel: emojiModel)
    }
}
