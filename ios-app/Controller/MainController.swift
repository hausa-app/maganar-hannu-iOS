//
//  MainController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 19.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit
import AudioToolbox

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let screenMng: ScreenManager = ScreenManager.instance
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    let logoImage = #imageLiteral(resourceName: "logo-black")
    
    override func loadView() {
        super.loadView()
        
        let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        barButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        setUpUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let cv = collectionView {
            cv.register(
                UINib(nibName: "HeaderSection", bundle: nil),
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "sectionHeader"
            )
            
            cv.register(
                UINib(nibName: "BigHeaderSection", bundle: nil),
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "bigSectionHeader"
            )
            cv.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateState), name: .updateState, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? WordCell {
            if segue.identifier == "showWord" || segue.identifier == "showWordPreview" {
                let destController: WordController = segue.destination as! WordController
                destController.segue = segue.identifier
                
                let selectedEntry = cell.word!
                destController.selectedEntry = selectedEntry
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.layoutIfNeeded()
    }
    
    @objc func updateState() {
        DispatchQueue.main.async {
            if Config.updateAvailable() == .available {
                self.menuButton.setBadge(text: "1")
            } else {
                self.menuButton.removeBadge()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateState()
    }
    
    func setUpUI() {
        if let bar = navigationController?.navigationBar {
            let height = bar.frame.size.height

            let imageView = UIImageView(image: logoImage)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: (height / logoImage.size.height) * logoImage.size.width, height: height))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
            
            self.navigationItem.titleView = titleView
        }
    }
    
    func deleteButtons() {
        navigationItem.rightBarButtonItems = nil
    }
    
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
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
            return CGSize(width: collectionView.frame.width, height: (width * 0.5 - 20) * 0.28)
        } else {
            return CGSize(width: collectionView.frame.width, height: (width * 0.25 - 20) * 0.31)
        }
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
}

extension MainController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let actualVC = (tabBarController.selectedViewController as! UINavigationController).topViewController
        let toVC = (viewController as! UINavigationController).topViewController
        
        if actualVC == toVC {
            if self.collectionView.getItemCount() > 6 {
                self.collectionView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }
        }
        
        return true
    }
}
