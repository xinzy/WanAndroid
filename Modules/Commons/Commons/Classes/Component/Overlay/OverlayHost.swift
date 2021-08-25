//
//  OverlayHost.swift
//  Alamofire
//
//  Created by Yang on 2021/8/23.
//

import UIKit

public protocol OverlayHost: AnyObject {
    var overlaySize: CGSize? { get }

    var overlayOnWindow: Bool { get }

    func presentOverlay(from parentViewController: UIViewController)

    func dismissOverlay()
}

public extension OverlayHost where Self: UIViewController {
    private var overlayViewTag: Int { 32768 }

    var overlaySize: CGSize? { nil }

    var overlayOnWindow: Bool { true }

    func presentOverlay(from parentViewController: UIViewController) {
        guard let window = parentViewController.view.window else { return }
        let parentBounds: CGRect = overlayOnWindow ? window.bounds : parentViewController.view.bounds

        let backgroundOverlayView = UIView()
        backgroundOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundOverlayView.frame = parentBounds
        backgroundOverlayView.alpha = 0.0
        backgroundOverlayView.isUserInteractionEnabled = true
        backgroundOverlayView.tag = overlayViewTag
        window.addSubview(backgroundOverlayView)

        let containerView = UIView()
        containerView.alpha = 0.0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 10.0
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.zero

        if let overlaySize = overlaySize {
            let x = (parentBounds.width - overlaySize.width) * 0.5
            let y = (parentBounds.height - overlaySize.height) * 0.5
            containerView.frame = CGRect(x: x, y: y, width: overlaySize.width, height: overlaySize.height)
        } else {
            containerView.frame = parentBounds.insetBy(dx: parentBounds.width * 0.05, dy: parentBounds.height * 0.05)
        }

        window.addSubview(containerView)
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = false

        containerView.addSubview(self.view)
        constraintViewEqual(containerView, self.view)

        containerView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 1.0
            containerView.transform = .identity
            backgroundOverlayView.alpha = 1.0
        }
    }

    func dismissOverlay() {
        guard let containerView = view.superview else { return }
        let blackOverlayView = containerView.superview?.viewWithTag(overlayViewTag)
        UIView.animate(withDuration: 0.3, animations: {
            blackOverlayView?.alpha = 0.0
            containerView.alpha = 0.0
            containerView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            self.removeFromParent()
            containerView.removeFromSuperview()
            blackOverlayView?.removeFromSuperview()
        }
    }

    private func constraintViewEqual(_ view: UIView, _ root: UIView) {
        root.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                             toItem: root, attribute: .top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal,
                                             toItem: root, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let constraint3 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                             toItem: root, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let constraint4 = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                             toItem: root, attribute: .leading, multiplier: 1.0, constant: 0.0)
        view.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }
}
