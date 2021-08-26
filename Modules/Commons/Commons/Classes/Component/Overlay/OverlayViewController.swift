//
//  OverlayWindow.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

fileprivate let animationDuration: TimeInterval = 0.35
open class OverlayViewController: UIViewController {

    public enum AnimationInType {
        case leftIn, rightIn, topIn, bottomIn, fade
    }
    public enum AnimationOutType {
        case leftOut, rightOut, topOut, bottomOut, fade
    }

    public var animationInType: AnimationInType {
        get { overlayAnimator.animationInType }
        set { overlayAnimator.animationInType = newValue }
    }
    public var animationOutType: AnimationOutType {
        get { overlayAnimator.animationOutType }
        set { overlayAnimator.animationOutType = newValue }
    }
    public var dismissWhenTouchOutside: Bool {
        get { overlayAnimator.dismissWhenTouchOutside }
        set { overlayAnimator.dismissWhenTouchOutside = newValue }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = false
    }
    
    public func present(from parentController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        modalPresentationStyle = .custom
        transitioningDelegate = overlayAnimator
        let controller = parentController.navigationController ?? parentController
        controller.present(self, animated: true, completion: completion)
    }

    private lazy var overlayAnimator: OverlayAnimator = {
        let animator = OverlayAnimator()
        return animator
    }()
}

fileprivate class OverlayAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    private var isPresented: Bool = false
    var dismissWhenTouchOutside: Bool = true
    var animationInType: OverlayViewController.AnimationInType = .fade
    var animationOutType: OverlayViewController.AnimationOutType = .fade

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = OverlayPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.dismissWhenTouchOutside = dismissWhenTouchOutside
        return presentationController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { animationDuration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            animateTransition(in: transitionContext)
        } else {
            animateTransition(out: transitionContext)
        }
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }

    private func animateTransition(in transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return}

        transitionContext.containerView.addSubview(toView)
        switch animationInType {
        case .fade:
            toView.alpha = 0
        case .leftIn:
            toView.transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
        case .rightIn:
            toView.transform = CGAffineTransform(translationX: ScreenWidth, y: 0)
        case .topIn:
            toView.transform = CGAffineTransform(translationX: 0, y: -ScreenHeight)
        case .bottomIn:
            toView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            switch self.animationInType {
            case .fade:
                toView.alpha = 1
            default:
                toView.transform = .identity
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    private func animateTransition(out transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return}

        let transform: CGAffineTransform?
        switch animationOutType {
        case .leftOut: transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
        case .rightOut: transform = CGAffineTransform(translationX: ScreenWidth, y: 0)
        case .topOut: transform = CGAffineTransform(translationX: 0, y: -ScreenHeight)
        case .bottomOut: transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        case .fade: transform = nil
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            switch self.animationInType {
            case .fade: fromView.alpha = 0
            default:
                fromView.transform = transform!
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate class OverlayPresentationController: UIPresentationController {

    public var dismissWhenTouchOutside: Bool = true

    public override var frameOfPresentedViewInContainerView: CGRect {
        ScreenBounds
    }

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    public override func presentationTransitionWillBegin() {
        backgroundView.alpha = 0
        containerView?.addSubview(backgroundView)

        UIView.animate(withDuration: animationDuration) {
            self.backgroundView.alpha = 1
        }
    }

    public override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: animationDuration) {
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
