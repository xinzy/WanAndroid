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
}

public extension UINavigationController {
}
