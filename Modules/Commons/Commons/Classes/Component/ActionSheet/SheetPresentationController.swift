//
//  SheetPresentationController.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

public class SheetPresentationController: UIPresentationController {

    public var sheetHeight: CGFloat = 0
    public var dismissWhenTouchOutside: Bool = true

    public override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(x: 0, y: ScreenHeight - sheetHeight, width: ScreenWidth, height: sheetHeight)
    }

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    public override func presentationTransitionWillBegin() {
        backgroundView.alpha = 0
        containerView?.addSubview(backgroundView)

        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1
        }
    }

    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
        }
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundView.removeFromSuperview()
        }
    }

    @objc private func onBackgroundClick() {
        if dismissWhenTouchOutside {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }

    private lazy var backgroundView: UIControl = {
        let view = UIControl()
        view.frame = containerView?.bounds ?? ScreenBounds
        view.backgroundColor = .black.withAlphaComponent(0.35)
        view.addTarget(self, action: #selector(onBackgroundClick), for: .touchUpInside)
        return view
    }()
}
