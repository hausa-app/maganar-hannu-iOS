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
        if segue.identifier == "showWord" {
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
        
        for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) {
            if let header = header as? HeaderSection {
                header.setColor()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
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
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenMng.entryList.categoryWordEntries.count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endSearching(false)
    }
    
}
