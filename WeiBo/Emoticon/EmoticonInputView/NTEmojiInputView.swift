//
//  NTEmojiInputView.swift
//  emojiInput
//
//  Created by jinzhanjun on 2020/5/19.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class NTEmojiInputView: UIView {
    
    /// 表情点击回调闭包
    var emojiClickClosure: ((_ emojiModel: EmojiModel?) -> Void)?
    
    /// 表情列表视图
    @IBOutlet weak var emoticonCollectionView: UICollectionView!
    
    /// 工具条
    @IBOutlet weak var toolBar: NTEmoticonPackageBar!
    
    /// 表情模型
    lazy var emoticonModel = {
        return EmoticonManager.shared.emojiListModel
    }()
    
    // 从XIB读取到内存后调用
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置控制流，调整内部Cell的大小
        emoticonCollectionView.collectionViewLayout = EmoticonCollectionViewLayout()
    }
    
    /// 从XIB中加载视图
    class func inputView( emojiClick: @escaping(_ emojiModel: EmojiModel?) -> Void) -> NTEmojiInputView? {
        
        // 创建nib
        let nib = UINib(nibName: "NTEmojiInputView", bundle: nil)
        // 实例化nib
        let instence = nib.instantiate(withOwner: nil, options: nil)[0] as! NTEmojiInputView
        // 记录闭包
        instence.emojiClickClosure = emojiClick
        // 返回nib
        return instence
    }
    
    private func setupUI() {
        emoticonCollectionView.dataSource = self
        // 注册可重用 Cell
        emoticonCollectionView.register(NTEmojiCollectionCell.self, forCellWithReuseIdentifier: "CellID")
    }
}

//MARK: - UICollectionViewDataSource
extension NTEmojiInputView: UICollectionViewDataSource {
    
    /// 分组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emoticonModel.count
    }
    /// 每组的成员数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonModel[section].pagesNumber ?? 0
    }
    /// cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 取 Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! NTEmojiCollectionCell
        // 设置 cell
        cell.emojiModels = emoticonModel[indexPath.section].modelInPage(pageNumber: indexPath.item)
        
        cell.delegate = self
        
        // 返回 cell
        return cell
    }
}

/// 表情模型拓展
extension EmojiModel {
    // 表情图片
    var image: UIImage? {
        get{
            guard let bundlePath = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let emojiBundle = Bundle(path: bundlePath),
                let packageName = self.packageName,
                let pngName = self.png
                else { return nil}
            
            let imageName = packageName + "/" + pngName
            let image = UIImage(named: imageName, in: emojiBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
            return image
        }
    }
}

//MARK: - NTEmojiCollectionCellDelegate
extension NTEmojiInputView: NTEmojiCollectionCellDelegate {
    func emojiCollectionCellDidClicked(cell: NTEmojiCollectionCell, emojiModel: EmojiModel?) {
        
        emojiClickClosure?(emojiModel)
    }
}
