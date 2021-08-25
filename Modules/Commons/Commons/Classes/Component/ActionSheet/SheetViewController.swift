//
//  SheetViewController.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

open class SheetViewController: UIViewController, UIViewControllerTransitioningDelegate {

    open var controllerHeight: CGFloat { 0 }

    public func presentSheet(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        modalPresentationStyle = .custom
        transitioningDelegate = self
        controller.present(self, animated: true, completion: completion)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting).then { $0.sheetHeight = controllerHeight }
    }
}
