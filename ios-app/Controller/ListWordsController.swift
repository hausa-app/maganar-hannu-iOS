//
//  ListWordsController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 29.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class ListWordsController: MainController {
    
    var headerText: String!
    var limit: Int = 6
    
    var entries: [Entry]!
    
    var editingList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEntries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showWord" {
            screenMng.setActiveEntryList(self.entries)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.collectionView.visibleCells.isEmpty {
            if !(self.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    if headerText == "Most Popular" {
                        cell.setColor(type: .popular)
                    } else if headerText == "Recent Searches" {
                        cell.setColor(type: .recentSearches)
                    } else {
                        cell.setColor(type: .recentViews)
                    }
                }
            }
        }
        
        for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) {
            if let header = header as? HeaderSection {
                if headerText == "Most Popular" {
                    header.setColor(type: .popular)
                } else if headerText == "Recent Searches" {
                    header.setColor(type: .recentSearches)
                } else {
                    header.setColor(type: .recentViews)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! HeaderSection
        
        if headerText == "Most Popular" {
            headerView.setColor(type: .popular)
        } else if headerText == "Recent Searches" {
            headerView.setColor(type: .recentSearches)
        } else {
            headerView.setColor(type: .recentViews)
        }
        
        if entries.isEmpty || headerText == "Most Popular" {
            headerView.setHeader(headerText)
        } else {
            headerView.changeIcon(editingList)
            headerView.setHeader(headerText, withButton: true)
            headerView.settingsHandler = {
                self.executeDeleteSettings(header: headerView, indexPath: indexPath)
                self.editingList = !self.editingList
            }
        }
        
        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = entries.count
        if count <= 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
            cell.word = entries[indexPath.item]
            if self.editingList { cell.wobble(true) }
            setCellColorAndHandler(cell: cell, indexPath: indexPath)
            
            return cell
        } else if count % limit > 0 {
            if indexPath == collectionView.lastIndexPath(inSection: indexPath.section) && limit <= count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                cell.entries = (entries, limit - 1)
                setCellColorAndHandler(cell: cell, indexPath: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                cell.word = entries[indexPath.item]
                if self.editingList { cell.wobble(true) }
                setCellColorAndHandler(cell: cell, indexPath: indexPath)
                return cell
            }
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath)
    }
    
    func setCellColorAndHandler(cell: MainCell, indexPath: IndexPath) {
        if headerText == "Most Popular" {
            cell.setColor(type: .popular)
        } else if headerText == "Recent Searches" {
            cell.setColor(type: .recentSearches)
            if let cell = cell as? WordCell {
                cell.deleteHandler = {
                    UserConfig.deleteSearchEntry(pos: indexPath.item)
                    self.entries = UserConfig.getRecentSearches(5)
                    self.collectionView.reloadData()
                }
            }
        } else {
            cell.setColor(type: .recentViews)
            if let cell = cell as? WordCell {
                cell.deleteHandler = {
                    self.screenMng.removeViewed(entry: cell.word!)
                    self.entries = self.screenMng.getRecentViewedEntries(5)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = entries.count
        if count > limit { return count - 1 }
        return count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endSearching(false)
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
        if headerText == "Most Popular" {
            self.entries = screenMng.getPopularEntries(limit + 1)
        } else if headerText == "Recent Searches" {
            self.entries = UserConfig.getRecentSearches(limit + 1)
        } else {
            self.entries = screenMng.getRecentViewedEntries(limit + 1)
        }
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
}
