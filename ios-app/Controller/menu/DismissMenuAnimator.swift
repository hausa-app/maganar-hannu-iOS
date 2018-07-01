//
//  DismissMenuAnimator.swift
//  Hausa
//
//  Created by Emre Can Bolat on 08.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class DismissMenuAnimator : NSObject {
}

extension DismissMenuAnimator : UIViewControllerAnimatedTransitioning {
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
        let snapshot = containerView.viewWithTag(MenuHelper.snapshotNumber)
        
        snapshot?.removeBlurEffect(withDuration: transitionDuration(using: transitionContext))
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                snapshot?.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        },
            completion: { _ in
                let didTransitionComplete = !transitionContext.transitionWasCancelled
                if didTransitionComplete {
                    containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                    snapshot?.removeFromSuperview()
                    snapshot?.removeBlurFromSuperView()
                }
                transitionContext.completeTransition(didTransitionComplete)
        }
        )
    }
}
