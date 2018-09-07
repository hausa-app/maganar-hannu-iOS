//
//  MainController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 19.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit
import AudioToolbox

class MainController: UIViewController, UICollectionViewDataSource, HausaLayoutDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let screenMng: ScreenManager = ScreenManager.instance
    let searchBar = UISearchBar()
    
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
            
            if let customLayout = cv.collectionViewLayout as? HausaLayout {
                customLayout.delegate = self
            }
            cv.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateState), name: .updateState, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? WordCell {
            if segue.identifier == "showWord" {
                let destController: WordController = segue.destination as! WordController
                
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
                self.menuButton.tintColor = .red
                //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else { self.menuButton.tintColor = .black }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateState()
    }
    
    func setUpUI() {
        if let bar = navigationController?.navigationBar {
            let width = bar.frame.size.width
            let height = bar.frame.size.height
            let x = width / 2 - logoImage.size.width / 2
            let y = height / 2 - logoImage.size.height / 2
            
            let imageView = UIImageView(image: logoImage)
            imageView.frame = CGRect(x: x, y: y, width: width, height: height)
            imageView.contentMode = .scaleAspectFit
            navigationItem.titleView = imageView
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
