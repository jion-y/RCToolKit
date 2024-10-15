//
//  RC HorizontalPageLayout.swift
//  RCToolKit
//
//  Created by yoyo on 2024/9/29.
//

import UIKit

/// UICollection 横向布局
open class RCHorizontalPageLayout: UICollectionViewLayout {
    public var  minimumLineSpacing:CGFloat = 5
    public var  minimumInteritemSpacing:CGFloat = 5
    public var  itemSize:CGSize = .zero
    public var sectionInset:UIEdgeInsets = .zero
    
    private var layoutAttributes:Array<UICollectionViewLayoutAttributes> = []
    private var _rowCount:Int = 0
    private var rowCount:Int {
        get {
            var count = _rowCount
            if _rowCount <= 0 {
                let numerator = Int32(self.collectionView!.rc.height - self.sectionInset.top - self.sectionInset.bottom + self.minimumLineSpacing)
                let denominator = Int32(self.minimumLineSpacing + self.itemSize.height)
                count = Int(numerator / denominator)
                _rowCount = count >= 1 ? count : 1
//                if numerator % denominator != 0 && count != 1 {
//                    self.minimumLineSpacing = (self.collectionView!.rc.height - self.sectionInset.top - self.sectionInset.bottom - CGFloat(count) * self.itemSize.height) / CGFloat(count - 1)
//                }
            }
            return _rowCount
        }
        
        set {
            _columnCount = newValue
        }
    }
    private var _columnCount:Int = 0
    private var columnCount:Int {
        get {
            let numerator = Int32(self.collectionView!.rc.width - self.sectionInset.left - self.sectionInset.right + self.minimumInteritemSpacing)
            let denominator = Int32(self.minimumInteritemSpacing + self.itemSize.width)
            let count:Int = Int(numerator / denominator)
            _columnCount = count
            
//            if numerator % denominator != 0 {
//                self.minimumInteritemSpacing = (self.collectionView!.rc.width - self.sectionInset.left - self.sectionInset.right - CGFloat(count) * self.itemSize.width) / CGFloat(count - 1)
//            }
            return _columnCount
        }
        set {
            _columnCount = newValue
        }
    }
    
    
    open override func prepare() {
        let itemCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for i in 0..<itemCount {
             let indexPath = IndexPath(row: i, section: 0)
            let attr = self.layoutAttributesForItem(at: indexPath)!
            self.layoutAttributes.append(attr)
        }
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let item  = indexPath.item
        let pageNumber  = item / (self.rowCount * self.columnCount)
        let itemInPage = item % (self.rowCount * self.columnCount)
        
        let col:Int = itemInPage % self.columnCount
        let row:Int = itemInPage / self.columnCount
        
        let x:CGFloat =  self.sectionInset.left +  ( self.itemSize.width + self.minimumInteritemSpacing ) * CGFloat(col) + CGFloat(pageNumber) * self.collectionView!.rc.width
        
        let y:CGFloat = self.sectionInset.top + ( self.itemSize.height + self.minimumLineSpacing ) * CGFloat(row)
        attri.frame = CGRectMake(x, y, itemSize.width, itemSize.height)
        
        return attri
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttributes
    }
    
    open override var collectionViewContentSize: CGSize {
        let itemCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        let pageNumber:Int = Int(ceil(Float(itemCount) / Float(self.rowCount * self.columnCount)))
        return CGSizeMake(CGFloat(pageNumber) * self.collectionView!.rc.width, self.collectionView!.rc.height)
    }
    
    func getCollectViewHeight(with rowCount:Int32)->CGFloat {
        
        return 0.0
    }
    
    public func getPageTotalNum()->Int {
        return self.columnCount * self.rowCount
    }
    
    
}
