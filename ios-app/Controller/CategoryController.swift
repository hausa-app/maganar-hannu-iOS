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
        
        if searchView.isHidden {
            self.collectionView.reloadData()
        }
        
        if !self.collectionView.visibleCells.isEmpty {
            if !(self.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    cell.setColor()
                }
            }
            
            for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) {
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
        case UICollectionElementKindSectionHeader:
            
            if let header = headerView as? HeaderSection {
                header.headerLabel.text = "Fannoni - Categories"
                header.setColor()
            }
            return headerView
        default:
            assert(false, "Unexcepted element kind")
        }
        return headerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endSearching(false)
    }
    
}



