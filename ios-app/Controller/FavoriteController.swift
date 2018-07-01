//
//  FavoriteController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class FavoriteController: MainController {
    
    var limit: Int = 6
    var favoriteEntries: [Entry]!
    var editingList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteEntries = screenMng.getFavoriteEntries(limit + 1)
        collectionView.register(UINib(nibName:"HeaderSection", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "bigSectionHeader")
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let feCount = favoriteEntries.count
        if feCount <= 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
            cell.word = favoriteEntries[indexPath.item]
            cell.setColor()
            if self.editingList { cell.wobble(true) }
            cell.deleteHandler = {
                self.screenMng.setFavorited(entry: cell.word!)
                self.updateEntries()
                self.collectionView.reloadData()
            }
            return cell
        } else if feCount % limit > 0 {
            if indexPath == collectionView.lastIndexPath(inSection: indexPath.section) && limit <= feCount {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                cell.entries = (favoriteEntries, limit - 1)
                cell.setColor()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                cell.word = favoriteEntries[indexPath.item]
                cell.setColor()
                if self.editingList { cell.wobble(true) }
                cell.deleteHandler = {
                    self.screenMng.setFavorited(entry: cell.word!)
                    self.updateEntries()
                    self.collectionView.reloadData()
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderSection
        if collectionView.numberOfItems(inSection: indexPath.section) == 0 {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "bigSectionHeader", for: indexPath) as! HeaderSection
        } else {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! HeaderSection
        }

        headerView.setColor()
        
        if favoriteEntries.isEmpty {
            headerView.setHeader("Favorites")
        } else {
            headerView.changeIcon(editingList)
            headerView.setHeader("Favorites", withButton: true)
            headerView.settingsHandler = {
                self.executeDeleteSettings(header: headerView, indexPath: indexPath)
                self.editingList = !self.editingList
            }
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.numberOfItems(inSection: section) == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 115)
        }
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = favoriteEntries.count
        if count > limit { return count - 1 }
        return count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endSearching(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showWord" {
            screenMng.setActiveEntryList(self.favoriteEntries)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.mainView.isHidden {
            limit = 6
            updateEntries()
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell is ExtraCell {
            limit += 6
            updateEntries()
            self.collectionView.reloadData()
        }
        return true
    }
    
    func updateEntries() {
        favoriteEntries = screenMng.getFavoriteEntries(limit + 1)
    }
    
    func executeDeleteSettings(header: HeaderSection, indexPath: IndexPath) {
        if collectionView.numberOfItems(inSection: indexPath.section) != 0 {
            let visibles = collectionView.visibleCells as! [MainCell]
            for cell in visibles.filter({ ($0.delete != nil) && !$0.delete.isHidden }) {
                (cell as! WordCell).wobble(false)
            }
            
            if !visibles.isEmpty {
                let headers = (collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) as! [HeaderSection]).filter({ $0.settingsActive })
                for item in headers { item.changeIcon(false) }
                
                if headers.count == 1 {
                    if headers.first == header { return }
                }
            }
            
        }
        
        header.changeIcon(true)
        
        for i in 0...collectionView.numberOfItems(inSection: indexPath.section)-1 {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: indexPath.section))
            if let cell = cell as? WordCell {
                cell.wobble(header.settingsActive)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.editingList = false
    }
    
}
