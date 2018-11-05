//
//  CategoryController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class CategoryWordsController: MainController {
    
    var categoryObjects: [Entry]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryObjects = screenMng.getCategoryWordEntries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showWord" || segue.identifier == "showWordPreview" {
            screenMng.setActiveEntryList(self.categoryObjects)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.collectionView.visibleCells.isEmpty {
            if !(self.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    cell.setColor()
                }
            }
        }
        
        for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader) {
            if let header = header as? HeaderSection {
                header.setColor()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            if let header = headerView as? HeaderSection {
                header.setColor()
                if self.categoryObjects.isEmpty {
                    header.headerLabel.text = "No entries for this category!"
                } else {
                    let category = (self.categoryObjects.first?.category)!
                    header.headerLabel.text = category.category_hausa
                }
            }
            return headerView
        default:
            assert(false, "Unexcepted element kind")
        }
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath)
        if let cell = cell as? WordCell {
            cell.word = self.screenMng.entryList.categoryWordEntries[indexPath.item]
            cell.setColor()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width;
        let intrinsicMargin: CGFloat = 15.0 + 15.0
        var targetWidth: CGFloat = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        var height: CGFloat = 0
        var cellSize: CGFloat = 0
        
        var item: Entry! = nil
        let items = calculate(width: width)
        
        targetWidth = width / CGFloat(items) - 20
        if indexPath.item % 2 != 0 {
            item = categoryObjects[indexPath.item - (indexPath.item % items)]
        } else {
            item = categoryObjects[indexPath.item]
        }
        
        /*
        if width < self.view.frame.size.height {
            targetWidth = width * 0.5 - 20
            if indexPath.item % 2 != 0 {
                item = categoryObjects[indexPath.item - (indexPath.item % 2)]
            } else {
                item = categoryObjects[indexPath.item]
            }
        } else {
            targetWidth = width * (1/3) - 20
            if indexPath.item % 3 != 0 {
                item = categoryObjects[indexPath.item - (indexPath.item % 3)]
            } else {
                item = categoryObjects[indexPath.item]
            }
        }
        */
        
        let labelSize = UILabel.estimatedSize(item.word, targetSize: CGSize(width: targetWidth, height: 0))
        let sec = UILabel.estimatedSize(getAsString(list: item.translationList), targetSize: CGSize(width: targetWidth, height: 0))
        cellSize = labelSize.height + intrinsicMargin + sec.height
        
        height = targetWidth + cellSize - intrinsicMargin
        return CGSize(width: targetWidth, height: height)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenMng.entryList.categoryWordEntries.count
    }
    
}
