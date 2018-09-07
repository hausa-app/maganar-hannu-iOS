//
//  HomeController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class HomeController: MainController {
    
    var index: IndexPath!
    
    var popularEntries: [Entry]!
    var recentViewed: [Entry]!
    var recentSearches: [Entry]!
    
    var entries = [Int: [Entry]]()
    
    var editRS = false
    var editRV = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEntries()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var limit = 6
        if self.view.frame.size.width < self.view.frame.size.height {
            limit = 4
        }
        
        let entriesToSet = entries[indexPath.section]!
        let count = entriesToSet.count
        var cell: UICollectionViewCell
        
        if count <= limit || indexPath != collectionView.lastIndexPath(inSection: indexPath.section) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath)
            (cell as! WordCell).word = entriesToSet[indexPath.item]
            (cell as! WordCell).setColor(type: ThemeType(rawValue: indexPath.section))
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath)
            (cell as! ExtraCell).entries = (entriesToSet, limit - 1)
            (cell as! ExtraCell).setColor(type: ThemeType(rawValue: indexPath.section))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: UICollectionReusableView!
        if collectionView.numberOfItems(inSection: indexPath.section) == 0 {
            headerView =
                collectionView
                    .dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "bigSectionHeader",
                        for: indexPath)
        } else {
            headerView =
                collectionView
                    .dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: "sectionHeader",
                        for: indexPath)
        }
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            if let header = headerView as? HeaderSection {
                if indexPath.section == 0 {
                    header.setHeader("Most popular")
                    header.setColor(type: .popular)
                } else if indexPath.section == 1 {
                    header.setColor(type: .recentSearches)
                    if recentSearches.isEmpty {
                        header.setHeader("Recent searches")
                    } else {
                        header.changeIcon(editRS)
                        header.setHeader("Recent searches", withButton: true)
                        header.settingsHandler = {
                            self.executeDeleteSettings(header: header, indexPath: indexPath)
                            self.editRV = false
                            self.editRS = true
                        }
                    }

                } else {
                    header.setColor(type: .recentViews)
                    if recentViewed.isEmpty {
                        header.setHeader("Recent views")
                    } else {
                        header.changeIcon(editRV)
                        header.setHeader("Recent views", withButton: true)
                        header.settingsHandler = {
                            self.executeDeleteSettings(header: header, indexPath: indexPath)
                            self.editRV = true
                            self.editRS = false
                        }
                    }
                }
            }
            return headerView

        default:
            assert(false, "Unexcepted element kind")
        }
        return headerView
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
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.numberOfItems(inSection: section) == 0 {
            let width  = self.view.frame.size.width;
            if width < self.view.frame.size.height {
                return CGSize(width: collectionView.frame.width, height: width * 0.5 - 20)
            } else {
                return CGSize(width: collectionView.frame.width, height: width * 0.25 - 20)
            }
            
        }
        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var limit = 6
        if self.view.frame.size.width < self.view.frame.size.height {
            limit = 4
        }
        if section == 0 {
            if popularEntries.count > limit { return limit } else { return popularEntries.count }
        } else if section == 1 {
            if recentSearches.count > limit { return limit } else  { return recentSearches.count }
        } else {
            if recentViewed.count > limit { return limit } else { return recentViewed.count }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.index = indexPath
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "showWord" {
            screenMng.setActiveEntryList(entries[index.section]!)
            
            if let cell = sender as? WordCell {
                if !cell.delete.isHidden {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showList" {
            let destController: ListWordsController = segue.destination as! ListWordsController
            if index.section == 0 {
                destController.headerText = "Most popular"
            } else if index.section == 1 {
                destController.headerText = "Recent searches"
            } else {
                destController.headerText = "Recent views"
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateEntries()
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.editRS = false
        self.editRV = false
    }
    
    func updateEntries() {
        self.popularEntries = screenMng.getPopularEntries(7)
        self.recentSearches = UserConfig.getRecentSearches(7)
        self.recentViewed = screenMng.getRecentViewedEntries(7)
        
        entries[0] = popularEntries
        entries[1] = recentSearches
        entries[2] = recentViewed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width
        let intrinsicMargin: CGFloat = 15.0 + 15.0
        var targetWidth: CGFloat = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2
        var height: CGFloat = 0
        var cellSize: CGFloat = 0
        
        var item: Entry! = nil
        
        if width < self.view.frame.size.height {
            targetWidth = width * 0.5 - 20
            if indexPath.item % 2 != 0 {
                item = entries[indexPath.section]![indexPath.item - (indexPath.item % 2)]
            } else {
                item = entries[indexPath.section]![indexPath.item]
            }
        } else {
            targetWidth = width * (1/3) - 20
            if indexPath.item % 3 != 0 {
                item = entries[indexPath.section]![indexPath.item - (indexPath.item % 3)]
            } else {
                item = entries[indexPath.section]![indexPath.item]
            }
        }
        
        let labelSize = UILabel.estimatedSize(item.word, targetSize: CGSize(width: targetWidth, height: 0))
        let sec = UILabel.estimatedSize(getAsString(list: item.translationList), targetSize: CGSize(width: targetWidth, height: 0))
        cellSize = labelSize.height + intrinsicMargin + sec.height
        
        height = targetWidth + cellSize - intrinsicMargin
        return CGSize(width: targetWidth, height: height)
    }
}
