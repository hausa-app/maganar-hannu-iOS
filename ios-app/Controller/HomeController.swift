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
    
    var editRS = false
    var editRV = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEntries()
        
        collectionView.register(UINib(nibName:"HeaderSection", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "bigSectionHeader")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let peCount = popularEntries.count
            if peCount <= 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                cell.word = popularEntries[indexPath.item]
                cell.setColor(type: .popular)
                return cell
            } else {
                if indexPath == collectionView.lastIndexPath(inSection: indexPath.section) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                    cell.entries = (popularEntries, 3)
                    cell.setColor(type: .popular)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                    cell.word = popularEntries[indexPath.item]
                    cell.setColor(type: .popular)
                    return cell
                }
            }
        } else if indexPath.section == 1 {
            let rsCount = recentSearches.count
            if rsCount <= 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                cell.word = recentSearches[indexPath.item]
                cell.setColor(type: .recentSearches)

                if self.editRS { cell.wobble(true) } else { cell.wobble(false)}
                cell.deleteHandler = {
                    UserConfig.deleteSearchEntry(pos: indexPath.item)
                    self.recentSearches = UserConfig.getRecentSearches(5)
                    collectionView.reloadData()
                }
                return cell
            } else {
                if indexPath == collectionView.lastIndexPath(inSection: indexPath.section) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                    cell.entries = (recentSearches, 3)
                    cell.setColor(type: .recentSearches)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                    cell.word = recentSearches[indexPath.item]
                    cell.setColor(type: .recentSearches)
                    
                    if self.editRS { cell.wobble(true) } else { cell.wobble(false)}
                    cell.deleteHandler = {
                        UserConfig.deleteSearchEntry(pos: indexPath.item)
                        self.recentSearches = UserConfig.getRecentSearches(5)
                        collectionView.reloadData()
                    }
                    return cell
                }
            }
        } else {
            let rvCount = recentViewed.count
            if rvCount <= 4 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                cell.word = recentViewed[indexPath.item]
                cell.setColor(type: .recentViews)
                if self.editRV { cell.wobble(true) } else { cell.wobble(false)}
                cell.deleteHandler = {
                    self.screenMng.removeViewed(entry: cell.word!)
                    self.recentViewed = self.screenMng.getRecentViewedEntries(5)
                    collectionView.reloadData()
                }
                return cell
            } else {
                if indexPath == collectionView.lastIndexPath(inSection: indexPath.section) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtraCell", for: indexPath) as! ExtraCell
                    cell.entries = (recentViewed, 3)
                    cell.setColor(type: .recentViews)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
                    cell.word = recentViewed[indexPath.item]
                    cell.setColor(type: .recentViews)
                    
                    if self.editRV { cell.wobble(true) } else { cell.wobble(false)}
                    cell.deleteHandler = {
                        self.screenMng.removeViewed(entry: cell.word!)
                        self.recentViewed = self.screenMng.getRecentViewedEntries(5)
                        collectionView.reloadData()
                    }
                    return cell
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: UICollectionReusableView!
        if collectionView.numberOfItems(inSection: indexPath.section) == 0 {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "bigSectionHeader", for: indexPath)
        } else {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
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
        if section == 0 {
            if popularEntries.count > 4 { return 4 } else { return popularEntries.count }
        } else if section == 1 {
            if recentSearches.count > 4 { return 4 } else  { return recentSearches.count }
        } else {
            if recentViewed.count > 4 { return 4 } else { return recentViewed.count }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        self.index = indexPath
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        if identifier == "showWord" {
            if self.index.section == 0 {
                screenMng.setActiveEntryList(self.popularEntries)
            } else if self.index.section == 1 {
                screenMng.setActiveEntryList(self.recentSearches)
            } else {
                screenMng.setActiveEntryList(self.recentViewed)
            }
            
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endSearching(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if searchView.isHidden {
            updateEntries()
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.editRS = false
        self.editRV = false
    }
    
    func updateEntries() {
        self.popularEntries = screenMng.getPopularEntries(5)
        self.recentSearches = UserConfig.getRecentSearches(5)
        self.recentViewed = screenMng.getRecentViewedEntries(5)
    }
    
}
