//
//  CustomNavigationDelegate.swift
//  TeamProject
//
//  Created by iOS study on 5/2/25.
//

import UIKit

class YourNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return NoShadowPushAnimator(isPresenting: true)
        case .pop:
            return NoShadowPushAnimator(isPresenting: false)
        default:
            return nil
        }
    }
}
