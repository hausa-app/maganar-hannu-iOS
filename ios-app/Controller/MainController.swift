//
//  MainController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 19.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit
import AudioToolbox

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let searchBar = UISearchBar()
    var screenMng: ScreenManager = ScreenManager.instance
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var mainView: UIView!
    var searchView: SearchView!

    let logoImage = #imageLiteral(resourceName: "logo-black")
    
    let menuImage = #imageLiteral(resourceName: "menu")
    
    var button2: UIBarButtonItem!
    
    override func loadView() {
        super.loadView()
        searchView = SearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        barButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        addButtons()
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: searchView, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: searchView, attribute: .bottom, multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: searchView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setImage(#imageLiteral(resourceName: "next_ico"), for: .bookmark, state: .normal)
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        if collectionView != nil {
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.sectionHeadersPinToVisibleBounds = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateState), name: .updateState, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.layoutIfNeeded()
    }
    
    @objc func updateState() {
        DispatchQueue.main.async {
            if Config.updateAvailable() == .available {
                self.button2.tintColor = .red
                //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else { self.button2.tintColor = .black }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateState()
        if !(self is WordController) {
            self.tabBarController?.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.searchView.collectionView.visibleCells.isEmpty {
            if !(self.searchView.collectionView.visibleCells.first as! MainCell).isOldColor() { return }
            for cell in self.searchView.collectionView.visibleCells {
                if let cell = cell as? MainCell {
                    cell.setColor()
                }
            }
            for header in self.searchView.collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader) {
                if let header = header as? HeaderSection {
                    header.setColor()
                }
            }
        }
    }
    
    func addButtons() {
        let button1 = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        button2 = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(myRightSideBarButtonItemTapped(_:)))
        
        button2.tintColor = .black
        button1.tintColor = .black
        navigationItem.rightBarButtonItems = [button2, button1]
        setUpUI()
    }
    
    func setUpUI() {
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3)
        widthConstraint.isActive = true
       
        navigationItem.titleView = imageView
    }
    
    func deleteButtons() {
        navigationItem.rightBarButtonItems = nil
    }
    
    func createSearchBar() {
        searchBar.placeholder = "Search..."
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filterSearch(_:)))
        button.tintColor = .black
        
        navigationItem.leftBarButtonItem = button
        
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        
        self.navigationItem.titleView = searchBarContainer
    }
    
    @objc func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!) {
        if let tabBar = UIApplication.tabBarController() as? ResizedUITabBarController {
            tabBar.openMenu()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let width  = self.view.frame.size.width;
        if width < self.view.frame.size.height {
            return CGSize(width: collectionView.frame.width, height: (width * 0.5 - 20) * 0.275)
        } else {
            return CGSize(width: collectionView.frame.width, height: (width * 0.25 - 20) * 0.275)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = self.view.frame.size.width;
        if width < self.view.frame.size.height {
            return CGSize(width: width * 0.5 - 20, height: width * 0.5 - 20)
        } else {
            return CGSize(width: width * 0.25 - 20, height: width * 0.25 - 20)
        }
    }

    func changeView(toSearch: Bool) {
        if toSearch {
            mainView.isHidden = true
            searchView.isHidden = false
            return
        }
        searchView.isHidden = true
        mainView.isHidden = false
    }
    
    func endSearching(_ back: Bool) {
        searchBar.endEditing(true)

        if back || screenMng.getSearchResults().isEmpty {
            navigationItem.leftBarButtonItem = nil
            screenMng.clearSearchResults()
            removeBlurEffect()
            dismissSearchBar()
            addButtons()
            self.searchBar.text = ""
            changeView(toSearch: false)
        } else {
            searchBar.resignFirstResponder()
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
        }
    }
    
    func dismissSearchBar() {
        self.navigationItem.titleView = nil
    }
    
    @objc func search() {
        deleteButtons()
        createSearchBar()
        addBlurEffect()

        searchBar.becomeFirstResponder()
    }
    
    @objc func filterSearch(_ sender: UIBarButtonItem) {
        createDialog()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? WordCell {
            if segue.identifier == "showWord" {
                endSearching(false)
                let destController: WordController = segue.destination as! WordController
                
                let selectedEntry = cell.word!
                destController.selectedEntry = selectedEntry
                
                if mainView.isHidden {
                    UserConfig.addSearchEntry(entry: selectedEntry)
                }
            }
        }
    }
    
}

extension MainController: UISearchBarDelegate, PopupVCDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearching(true)
        viewWillAppear(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endSearching(false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            changeView(toSearch: true)
            removeBlurEffect()
            screenMng.setSearchResults(key: searchText)
        } else {
            addBlurEffect()
            changeView(toSearch: false)
            screenMng.clearSearchResults()
        }
        searchView.collectionView.reloadData()
    }
    
    func createDialog() {
        let popupVC = SearchFilterAlert()
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.delegate = self
        
        self.tabBarController?.present(popupVC, animated: true, completion: nil)
    }
    
    func popupDidDisapper() {
        changeView(toSearch: true)
        removeBlurEffect()
        screenMng.setSearchResults(key: searchBar.text!)
        searchView.collectionView.reloadData()
    }
}

extension MainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let actualVC = (tabBarController.selectedViewController as! UINavigationController).topViewController
        let toVC = (viewController as! UINavigationController).topViewController
        
        if actualVC == toVC {
            self.endSearching(true)
            if self.collectionView.getItemCount() > 6 {
                self.collectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }
        }
        
        return true
    }
}
