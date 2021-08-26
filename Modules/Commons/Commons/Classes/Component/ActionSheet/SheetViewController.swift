//
//  SheetViewController.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

open class SheetViewController: UIViewController, UIViewControllerTransitioningDelegate {

    open var controllerHeight: CGFloat { 0 }
    public var dismissWhenTouchOutside: Bool = true
    public var makeRadius: Bool = true

    open override func viewDidLoad() {
        super.viewDidLoad()

        if makeRadius {
            view.cornerRadii(8, corners: [.topLeft, .topRight])
        }
    }

    public func presentSheet(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        modalPresentationStyle = .custom
        transitioningDelegate = self
        controller.present(self, animated: true, completion: completion)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.sheetHeight = controllerHeight
        presentationController.dismissWhenTouchOutside = dismissWhenTouchOutside
        return presentationController
    }
}
