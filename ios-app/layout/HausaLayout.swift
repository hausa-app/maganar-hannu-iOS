//
//  CellLayoutDelegate.swift
//  Hausa
//
//  Created by Emre Can Bolat on 04.09.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

protocol HausaLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class HausaLayout: UICollectionViewLayout {
    
    weak var delegate: HausaLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    fileprivate var cache = [String: [IndexPath: UICollectionViewLayoutAttributes]]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        prepareCache()

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        var sectionSize: CGFloat = 0
        
        for section in 0 ..< collectionView.numberOfSections {
            
            let frame = CGRect(x: 0, y: sectionSize, width: collectionView.frame.width, height: 50)
            
            let sectionHeaderAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
            sectionHeaderAttributes.frame = frame
            cache["header"]?[IndexPath(item: 0, section: section)] = sectionHeaderAttributes
            
            sectionSize += 50
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                if item < numberOfColumns {
                    yOffset[column] = yOffset[column] + 50
                }
                let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache["cells"]?[indexPath] = attributes
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height

                if item == collectionView.numberOfItems(inSection: section) - 1 {
                    let heightToSet = yOffset[column]
                    for col in 0 ..< numberOfColumns {
                        yOffset[col] = heightToSet
                    }
                    column = 0
                    sectionSize = heightToSet
                } else {
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                }
                
            }
            
        }

    }
    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache["header"] = [IndexPath: UICollectionViewLayoutAttributes]()
        cache["cells"] = [IndexPath: UICollectionViewLayoutAttributes]()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for (_, elementInfos) in cache {
            for (_, attributes) in elementInfos {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for (_, elementInfos) in cache {
            for (index, attributes) in elementInfos {
                if index == indexPath {
                    return attributes
                }
            }
        }
        return nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return cache["header"]?[indexPath]
        default:
            return nil;
        }
    }
    
}
