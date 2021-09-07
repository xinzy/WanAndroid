//
//  SheetViewController.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

open class SlideViewController: UIViewController {

    public enum SlidePosition {
        case left, top, right, bottom
    }

    open var controllerSize: CGFloat { 0 }
    public var slidePosition: SlideViewController.SlidePosition {
        get { slideAnimator.slidePosition }
        set { slideAnimator.slidePosition = newValue }
    }
    public var cornerRadius: CGFloat = 8
    public var maskToRadius: Bool = true
    public var dismissWhenTouchOutside: Bool = false {
        didSet {
            if dismissWhenTouchOutside {
                view.addTapGesture(self, #selector(dismissAction))
            } else {
                view.removeAllGestureRecognizers()
            }
        }
    }
    public var panToDismiss: Bool = true

    public var contentView: UIView = UIView()

    open override func loadView() {
        super.loadView()

        switch slidePosition {
        case .left:
            contentView.frame = CGRect(x: 0, y: 0, width: controllerSize, height: ScreenHeight)
            if maskToRadius { contentView.cornerRadii(cornerRadius, corners: [.bottomRight, .topRight]) }
        case .right:
            contentView.frame = CGRect(x: ScreenWidth - controllerSize, y: 0, width: controllerSize, height: ScreenHeight)
            if maskToRadius { contentView.cornerRadii(cornerRadius, corners: [.topLeft, .bottomLeft]) }
        case .top:
            contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: controllerSize)
            if maskToRadius { contentView.cornerRadii(cornerRadius, corners: [.bottomLeft, .bottomRight]) }
        case .bottom:
            contentView.frame = CGRect(x: 0, y: ScreenHeight - controllerSize, width: ScreenWidth, height: controllerSize)
            if maskToRadius { contentView.cornerRadii(cornerRadius, corners: [.topLeft, .topRight]) }
        }
        view.addSubview(contentView)
        contentView.addTapGesture(self, #selector(hideKeyboardIfNeed))
        contentView.addGestureRecognizer(panGestureRecognizer)
    }

    public func present(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        modalPresentationStyle = .custom
        slideAnimator.slideSize = controllerSize
        transitioningDelegate = slideAnimator
        controller.present(self, animated: true, completion: completion)
    }

    @objc private func dismissAction() {
        if dismissWhenTouchOutside { dismiss(animated: true) }
    }

    @objc private func hideKeyboardIfNeed() {
        view.endEditing(true)
    }

    private lazy var slideAnimator: SlideAnimator = {
        let animator = SlideAnimator()
        return animator
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognizer(_:)))
        recognizer.minimumNumberOfTouches = 1
        recognizer.delegate = self
        return recognizer
    }()
}

extension SlideViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        panToDismiss
    }

    @objc private func onPanGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: contentView)
            guard isEffectivePoint(translation: translation) else { return }
            if isInitialState(translation: translation) {
                view.transform = .identity
            } else {
                view.transform = makeTransform(translation: translation)
            }
        case .ended:
            let translation = recognizer.translation(in: contentView)
            if isCanDismiss(translation: translation) {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: animationDuration) { self.view.transform = .identity }
            }
        case .cancelled:
            UIView.animate(withDuration: animationDuration) { self.view.transform = .identity }
        default:
            break
        }
    }

    private func isEffectivePoint(translation: CGPoint) -> Bool {
        slidePosition == .top || slidePosition == .bottom ? abs(translation.x) < abs(translation.y) : abs(translation.x) > abs(translation.y)
    }

    private func isInitialState(translation: CGPoint) -> Bool {
        switch slidePosition {
        case .left: return translation.x >= 0
        case .right: return translation.x <= 0
        case .top: return translation.y >= 0
        case .bottom: return translation.y <= 0
        }
    }

    private func makeTransform(translation: CGPoint) -> CGAffineTransform {
        switch slidePosition {
        case .left: return CGAffineTransform(translationX: translation.x, y: 0)
        case .right: return CGAffineTransform(translationX: translation.x, y: 0)
        case .top: return CGAffineTransform(translationX: 0, y: translation.y)
        case .bottom: return CGAffineTransform(translationX: 0, y: translation.y)
        }
    }

    private func isCanDismiss(translation: CGPoint) -> Bool {
        switch slidePosition {
        case .left: return translation.x <= -controllerSize / 2
        case .right: return translation.x >= controllerSize / 2
        case .top: return translation.y <= -controllerSize / 2
        case .bottom: return translation.y >= controllerSize / 2
        }
    }
}

fileprivate class SheetPresentationController: UIPresentationController {

    fileprivate var slideSize: CGFloat = 0
    fileprivate var slidePosition: SlideViewController.SlidePosition = .bottom

    public override var frameOfPresentedViewInContainerView: CGRect {
        ScreenBounds
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

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = containerView?.bounds ?? ScreenBounds
        view.backgroundColor = .black.withAlphaComponent(0.35)
        return view
    }()
}

fileprivate class SlideAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var isPresented: Bool = false

    fileprivate var slidePosition: SlideViewController.SlidePosition = .bottom

    fileprivate var slideSize: CGFloat = 0

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = SheetPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.slideSize = slideSize
        presentationController.slidePosition = slidePosition
        return presentationController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresented {
            guard let toView = transitionContext.view(forKey: .to) else { return}
            transitionContext.containerView.addSubview(toView)

            switch slidePosition {
            case .left: toView.transform = CGAffineTransform(translationX: -slideSize, y: 0)
            case .top: toView.transform = CGAffineTransform(translationX: 0, y: -slideSize)
            case .right: toView.transform = CGAffineTransform(translationX: slideSize, y: 0)
            case .bottom: toView.transform = CGAffineTransform(translationX: 0, y: slideSize)
            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                toView.transform = .identity
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else { return}

            let transform: CGAffineTransform
            switch slidePosition {
            case .left: transform = CGAffineTransform(translationX: -slideSize, y: 0)
            case .top: transform = CGAffineTransform(translationX: 0, y: -slideSize)
            case .right: transform = CGAffineTransform(translationX: slideSize, y: 0)
            case .bottom: transform = CGAffineTransform(translationX: 0, y: slideSize)
            }

            UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                fromView.transform = transform
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
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
}
