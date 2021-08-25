//
//  UIViewController+.swift
//  Themes
//
//  Created by Yang on 2021/7/7.
//

import UIKit

public extension UIViewController {

    private struct AssociatedKey {
        static var AutoCreateBackKey = "AutoCreateBackKey"
    }

    var autoCreateBackItem: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.AutoCreateBackKey) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.AutoCreateBackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func toast(_ msg: String) {
        HUD.tip(text: msg)
    }

    func showLoading() {
        HUD.show(.progress)
    }

    func hideLoading() {
        HUD.hide()
    }
}


public extension UIViewController {
    private struct PopAssociatedKey {
        static var keyInteractivePopDisabled = "interactivePopDisabled"
        static var keyPrefersNavigationBarHidden = "prefersNavigationBarHidden"
        static var keyInteractivePopMaxAllowedInitialDistanceToLeftEdge = "interactivePopMaxAllowedInitialDistanceToLeftEdge"
    }

    var interactivePopDisabled: Bool {
        get {
            objc_getAssociatedObject(self, &PopAssociatedKey.keyInteractivePopDisabled) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &PopAssociatedKey.keyInteractivePopDisabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var prefersNavigationBarHidden: Bool {
        get {
            objc_getAssociatedObject(self, &PopAssociatedKey.keyPrefersNavigationBarHidden) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &PopAssociatedKey.keyPrefersNavigationBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
        get {
            objc_getAssociatedObject(self, &PopAssociatedKey.keyPrefersNavigationBarHidden) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, &PopAssociatedKey.keyPrefersNavigationBarHidden, max(newValue, 0), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UINavigationController {
    private struct PopAssociatedKey {
        static var keyFullscreenPopGestureRecognizer = "fullscreenPopGestureRecognizer"
        static var keyViewControllerBasedNavigationBarAppearanceEnabled = "viewControllerBasedNavigationBarAppearanceEnabled"
    }


    var fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        if let recognizer = objc_getAssociatedObject(self, &PopAssociatedKey.keyFullscreenPopGestureRecognizer) as? UIPanGestureRecognizer {
            return recognizer
        }
        let recognizer = UIPanGestureRecognizer()
        recognizer.maximumNumberOfTouches = 1
        objc_setAssociatedObject(self, &PopAssociatedKey.keyFullscreenPopGestureRecognizer, recognizer, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return recognizer
    }

    var viewControllerBasedNavigationBarAppearanceEnabled: Bool {
        get {
            objc_getAssociatedObject(self, &PopAssociatedKey.keyViewControllerBasedNavigationBarAppearanceEnabled) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &PopAssociatedKey.keyViewControllerBasedNavigationBarAppearanceEnabled, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

private class FullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var navigationController: UINavigationController?

    
}
