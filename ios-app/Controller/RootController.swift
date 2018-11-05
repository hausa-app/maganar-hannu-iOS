//
//  RootController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 29.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    fileprivate var rootViewController: UIViewController? = nil
    
    private var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSplashViewController()

        DispatchQueue.global(qos: .background).async {
            UserConfig.readConfig()
            if !UserConfig.isClientActivated() {
                StartupController.instance.initializeApp()
            }
            
            StartupController.instance.initialize()
            
            DispatchQueue.main.async {
                self.showMainViewController()
            }
        }
    
    }

    func showSplashViewController() {
        
        if rootViewController is SplashViewController {
            return
        }
        
        rootViewController?.willMove(toParent: nil)
        rootViewController?.removeFromParent()
        rootViewController?.view.removeFromSuperview()
        rootViewController?.didMove(toParent: nil)
        
        let splashViewController = SplashViewController(tileViewFileName: "Chimes")
        rootViewController = splashViewController
        splashViewController.pulsing = true
        
        splashViewController.willMove(toParent: self)
        addChild(splashViewController)
        view.addSubview(splashViewController.view)
        splashViewController.didMove(toParent: self)
    }
    
    func showMainViewController() {
        guard !(rootViewController is MainController) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main =  storyboard.instantiateViewController(withIdentifier: "MainController") as! ResizedUITabBarController
        main.willMove(toParent: self)
        addChild(main)
        
        if let rootViewController = self.rootViewController {
            self.rootViewController = main
            rootViewController.willMove(toParent: nil)
            
            transition(from: rootViewController, to: main, duration: 0.55, options: [.transitionCrossDissolve, .curveEaseOut], animations: { () -> Void in
                
            }, completion: { _ in
                main.didMove(toParent: self)
                rootViewController.removeFromParent()
                rootViewController.didMove(toParent: nil)
            })
        } else {
            rootViewController = main
            view.addSubview(main.view)
            main.didMove(toParent: self)
        }
    }
    
    func showWordController(id: Int) {
        if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController as? WordController {
            let word = ScreenManager.instance.getWordByID(id: id)!
            controller.selectedEntry = word
            controller.updateEntry(true)
        } else if let controller = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController as? SlideMenu {
            controller.dismiss(animated: false)
            self.id = id;
            self.performSegue(withIdentifier: "showWord", sender: self)
        } else {
            self.id = id;
            self.performSegue(withIdentifier: "showWord", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showWord" && id != nil {
            let word = ScreenManager.instance.getWordByID(id: id!)!
            
            if let destController = segue.destination as? WordController {
                destController.selectedEntry = word
            }
            self.id = nil
        }
    }
    
    func getController() -> UIViewController {
        return rootViewController!
    }
}

