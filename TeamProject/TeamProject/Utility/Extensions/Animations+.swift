//
//  Animations.swift
//  TeamProject
//
//  Created by iOS study on 5/2/25.
//

import UIKit

class NoShadowPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {
            containerView.addSubview(toVC.view)
            let finalFrame = transitionContext.finalFrame(for: toVC)
            toVC.view.frame = finalFrame.offsetBy(dx: toVC.view.frame.width, dy: 0)

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toVC.view.frame = finalFrame
                fromVC.view.frame = fromVC.view.frame.offsetBy(dx: -fromVC.view.frame.width * 0.3, dy: 0)
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
            let initialFrame = fromVC.view.frame

            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.frame = initialFrame.offsetBy(dx: initialFrame.width, dy: 0)
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
