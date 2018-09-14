//
//  PresentMenuAnimator.swift
//  Hausa
//
//  Created by Emre Can Bolat on 08.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class PresentMenuAnimator : NSObject {
}

extension PresentMenuAnimator : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        // replace main view with snapshot
        if let snapshot = fromVC.view.snapshotView() {
            snapshot.tag = MenuHelper.snapshotNumber
            snapshot.isUserInteractionEnabled = false
            snapshot.layer.shadowOpacity = 0.7
            
            containerView.insertSubview(snapshot, aboveSubview: toVC.view)
            fromVC.view.isHidden = true
            
            snapshot.addBlurEffect(withDuration: transitionDuration(using: transitionContext))
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                animations: {
                    snapshot.center.x += UIScreen.main.bounds.width * MenuHelper.menuWidth()
            },
                completion: { _ in
                    fromVC.view.isHidden = false
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            )
        }
    }
}
