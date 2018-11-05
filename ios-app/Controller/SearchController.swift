//
//  SearchController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 06.09.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import Foundation
import UIKit

class SearchController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let screenMng: ScreenManager = ScreenManager.instance
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navitem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let searchBar = UISearchBar()
    
    override func loadView() {
        super.loadView()
        
        searchBar.placeholder = "Search..."
        searchBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1;
        searchBar.tintColor = .black
        
        searchBar.layer.borderColor = UIColor.white.cgColor
        configureCancelBarButton()
        
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: navBar.frame.height)
        navitem.titleView = searchBarContainer
    }
    
    override func viewDidLoad() {
        collectionView.delegate = self
    }
    
    func configureCancelBarButton() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        cancelButton.tintColor = .black

        navitem.rightBarButtonItem = cancelButton
    }
    
    @objc func cancel() {
        screenMng.clearSearchResults()
        searchBar.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
        
        DispatchQueue.main.async {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showWord" || identifier == "showWordPreview" {
            screenMng.setActiveEntryList(screenMng.getSearchResults())
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? WordCell {
            if segue.identifier == "showWord" || segue.identifier == "showWordPreview" {
                let destController: WordController = segue.destination as! WordController
                destController.segue = segue.identifier
                
                let selectedEntry = cell.word!
                destController.selectedEntry = selectedEntry
                
                UserConfig.addSearchEntry(entry: selectedEntry)
            }
        }
    }
    
    @IBAction func createDialog(_ sender: UIBarButtonItem) {
        let popupVC = SearchFilterAlert()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        
        self.present(popupVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as! WordCell
        
        cell.word = screenMng.getSearchResults()[indexPath.item]
        cell.setColor()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenMng.getSearchResults().count
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
            item = screenMng.getSearchResults()[indexPath.item - (indexPath.item % items)]
        } else {
            item = screenMng.getSearchResults()[indexPath.item]
        }
        
        /*
        if width < self.view.frame.size.height {
            targetWidth = width * 0.5 - 20
            if indexPath.item % 2 != 0 {
                item = screenMng.getSearchResults()[indexPath.item - (indexPath.item % 2)]
            } else {
                item = screenMng.getSearchResults()[indexPath.item]
            }
        } else {
            targetWidth = width * (1/3) - 20
            if indexPath.item % 3 != 0 {
                item = screenMng.getSearchResults()[indexPath.item - (indexPath.item % 3)]
            } else {
                item = screenMng.getSearchResults()[indexPath.item]
            }
        }
        */
        
        let labelSize = UILabel.estimatedSize(item.word, targetSize: CGSize(width: targetWidth, height: 0))
        let sec = UILabel.estimatedSize(getAsString(list: item.translationList), targetSize: CGSize(width: targetWidth, height: 0))
        cellSize = labelSize.height + intrinsicMargin + sec.height
        
        height = targetWidth + cellSize - intrinsicMargin
        return CGSize(width: targetWidth, height: height)
    }
    
    func getAsString(list: [String]) -> String {
        var string = ""
        for a in list {
            string.append(a)
            if list.last != a {
                string.append(", ")
            }
        }
        return string
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func calculate(width: CGFloat) -> Int {
        var selected: CGFloat = 241.0
        var start: CGFloat = 1.0
        while selected > 240 {
            selected = width / start - 20
            start += 1.0
        }
        return Int(start - 1.0)
    }
    
}

extension SearchController: UISearchBarDelegate, PopupVCDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        screenMng.clearSearchResults()
        searchBar.resignFirstResponder()
        self.dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            screenMng.setSearchResults(key: searchText)
        } else {
            screenMng.clearSearchResults()
        }
        collectionView.reloadData()
    }

    func popupDidDisapper() {
        screenMng.setSearchResults(key: searchBar.text!)
        collectionView.reloadData()
    }
    
}

extension SearchController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
    }
}

