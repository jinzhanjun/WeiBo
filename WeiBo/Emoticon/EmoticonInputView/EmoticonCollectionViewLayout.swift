//
//  emoticonCollectionViewLayout.swift
//  emojiInput
//
//  Created by jinzhanjun on 2020/5/19.
//  Copyright © 2020 jinzhanjun. All rights reserved.
//

import UIKit

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // 设置 Cell 的大小
        itemSize = collectionView.bounds.size
        // 设置 Cell 的滚动方向
        scrollDirection = .horizontal
        // 设置 Cell 之间的最小间距
        minimumLineSpacing = 0
    }
}
