//
//  ResizedUITabBarController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 29.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit
import MessageUI

class ResizedUITabBarController: UITabBarController, MFMailComposeViewControllerDelegate {
    
    let present = PresentMenuAnimator()
    let dismiss = DismissMenuAnimator()
    let interactor = Interactor()
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    var trailing: NSLayoutConstraint!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let newTabBarHeight = defaultTabBarHeight - 5
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
        tabBar.tintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.invalidateIntrinsicContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if interactor.toView == "policy" {
            performSegue(withIdentifier: "showPolicy", sender: self)
        } else if interactor.toView == "menu" {
            performSegue(withIdentifier: "openMenu", sender: nil)
        } else if interactor.toView == "mail" {
            sendMail()
        }
        
        interactor.toView = ""
    }
    
    func openMenu() {
        performSegue(withIdentifier: "openMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SlideMenu {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        } else if let destination = segue.destination as? PolicyController {
            destination.interactor = interactor
        }
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["halimayarfulani@yahoo.com"])
            
            present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        self.openMenu()
    }
}

extension ResizedUITabBarController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return present
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismiss
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
