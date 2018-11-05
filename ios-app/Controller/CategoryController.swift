//
//  ViewController.swift
//  ios-app
//
//  Created by Emre Can Bolat on 02.11.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class CategoryController: MainController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
        
        if !self.collectionView.visibleCells.isEmpty {
            if !(self.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    cell.setColor()
                }
            }
            
            for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader) {
                if let header = header as? HeaderSection {
                    header.setColor()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showCategories" {
            let cell = sender as! CategoryCell
            let index = self.collectionView.indexPath(for: cell)
            
            let catID = screenMng.categoryList[(index?.item)!].categoryID
            screenMng.setCategoryWords(with: catID)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        let item = screenMng.categoryList[indexPath.item]
        
        cell.category = item
        cell.setCategoryColor(item.color)
        cell.setColor()

        return cell
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenMng.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            if let header = headerView as? HeaderSection {
                header.headerLabel.text = "Fannoni — Categories"
                header.setColor()
            }
            return headerView
        default:
            assert(false, "Unexcepted element kind")
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width;
        let intrinsicMargin: CGFloat = 15.0 + 15.0
        var targetWidth: CGFloat = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        var height: CGFloat = 0
        var cellSize: CGFloat = 0
        
        var item: Category! = nil
        let items = calculate(width: width)
        
        targetWidth = width / CGFloat(items) - 20
        if indexPath.item % items != 0 {
            item = screenMng.categoryList[indexPath.item - (indexPath.item % items)]
        } else {
            item = screenMng.categoryList[indexPath.item]
        }
        /*
        if width < self.view.frame.size.height {
            targetWidth = width * 0.5 - 20
            if indexPath.item % 2 != 0 {
                item = screenMng.categoryList[indexPath.item - (indexPath.item % 2)]
            } else {
                item = screenMng.categoryList[indexPath.item]
            }
        } else {
            targetWidth = width * (1/3) - 20
            if indexPath.item % 3 != 0 {
                item = screenMng.categoryList[indexPath.item - (indexPath.item % 3)]
            } else {
                item = screenMng.categoryList[indexPath.item]
            }
        }
        */
        
        let labelSize = UILabel.estimatedSize(item.category_hausa, targetSize: CGSize(width: targetWidth, height: 0))
        let sec = UILabel.estimatedSize(item.category_english, targetSize: CGSize(width: targetWidth, height: 0))
        cellSize = labelSize.height + intrinsicMargin + sec.height

        height = targetWidth + cellSize - intrinsicMargin
        return CGSize(width: targetWidth, height: height)
    }
    
}



