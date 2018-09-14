//
//  ListWordsController.swift
//  Hausa
///Users/emrecanbolat/Documents/maganar-hannu-iOS/ios-app/layout/cells/collectionView/WordCell.swift
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "showWord" || identifier == "showWordPreview", self.editingList {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showWord" || segue.identifier == "showWordPreview" {
            screenMng.setActiveEntryList(self.entries)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.collectionView.visibleCells.isEmpty {
            if !(self.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    if headerText == "Mafi jan hankali — Most popular" {
                        cell.setColor(type: .popular)
                    } else if headerText == "Kalmomin da aka nema — Recent searches" {
                        cell.setColor(type: .recentSearches)
                    } else {
                        cell.setColor(type: .recentViews)
                    }
                }
            }
        }
        
        for header in self.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) {
            if let header = header as? HeaderSection {
                if headerText == "Mafi jan hankali — Most popular" {
                    header.setColor(type: .popular)
                } else if headerText == "Kalmomin da aka nema — Recent searches" {
                    header.setColor(type: .recentSearches)
                } else {
                    header.setColor(type: .recentViews)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! HeaderSection
        
        if headerText == "Mafi jan hankali — Most popular" {
            headerView.setColor(type: .popular)
        } else if headerText == "Kalmomin da aka nema — Recent searches" {
            headerView.setColor(type: .recentSearches)
        } else {
            headerView.setColor(type: .recentViews)
        }
        
        if entries.isEmpty || headerText == "Mafi jan hankali — Most popular" {
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
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if entries.count % limit > 0, indexPath == collectionView.lastIndexPath(inSection: indexPath.section), limit <= entries.count {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath)
            (cell as! ExtraCell).entries = (entries, limit - 1)
            setCellColorAndHandler(cell: (cell as! ExtraCell), indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath)
            (cell as! WordCell).word = entries[indexPath.item]
            if editingList {
                DispatchQueue.main.async {
                    (cell as! WordCell).wobble(true)
                }
            } else {
                (cell as! WordCell).wobble(false)
            }
            setCellColorAndHandler(cell: (cell as! WordCell), indexPath: indexPath)
        }

        return cell
    }
    
    func setCellColorAndHandler(cell: MainCell, indexPath: IndexPath) {
        if headerText == "Mafi jan hankali — Most popular" {
            cell.setColor(type: .popular)
        } else if headerText == "Kalmomin da aka nema — Recent searches" {
            cell.setColor(type: .recentSearches)
            if let cell = cell as? WordCell {
                cell.deleteHandler = {
                    UserConfig.deleteSearchEntry(pos: indexPath.item)
                    self.updateEntries()
                    self.collectionView.reloadData()
                }
            }
        } else {
            cell.setColor(type: .recentViews)
            if let cell = cell as? WordCell {
                cell.deleteHandler = {
                    self.screenMng.removeViewed(entry: cell.word!)
                    self.updateEntries()
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell is ExtraCell, !editingList {
            limit += 6
            updateEntries()
            self.collectionView.reloadData()
        }
        return true
    }

    func updateEntries() {
        if headerText == "Mafi jan hankali — Most popular" {
            self.entries = screenMng.getPopularEntries(limit + 1)
        } else if headerText == "Kalmomin da aka nema — Recent searches" {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.numberOfItems(inSection: 0) <= 0 { return }
        for i in 0...collectionView.numberOfItems(inSection: 0)-1 {
            let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0))
            if let cell = cell as? WordCell {
                cell.wobble(self.editingList)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width;
        let intrinsicMargin: CGFloat = 15.0 + 15.0
        var targetWidth: CGFloat = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        var height: CGFloat = 0
        var cellSize: CGFloat = 0
        
        var item: Entry! = nil
        
        if width < self.view.frame.size.height {
            targetWidth = width * 0.5 - 20
            if indexPath.item % 2 != 0 {
                item = entries[indexPath.item - (indexPath.item % 2)]
            } else {
                item = entries[indexPath.item]
            }
        } else {
            targetWidth = width * (1/3) - 20
            if indexPath.item % 3 != 0 {
                item = entries[indexPath.item - (indexPath.item % 3)]
            } else {
                item = entries[indexPath.item]
            }
        }
        
        let labelSize = UILabel.estimatedSize(item.word, targetSize: CGSize(width: targetWidth, height: 0))
        let sec = UILabel.estimatedSize(getAsString(list: item.translationList), targetSize: CGSize(width: targetWidth, height: 0))
        cellSize = labelSize.height + intrinsicMargin + sec.height
        
        height = targetWidth + cellSize - intrinsicMargin
        return CGSize(width: targetWidth, height: height)
    }
}
