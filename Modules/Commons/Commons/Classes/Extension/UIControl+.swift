//
//  UIControl+.swift
//  Commons
//
//  Created by Yang on 2021/7/6.
//

import UIKit

public extension UIControl {

    typealias Action = () -> Void

    private struct AssociatedKeys {
        static var AssociatedKeyAction = "KeyAction"
    }

    private struct ActionWrapper {
        var action: Action

        init(_ action: @escaping Action) {
            self.action = action
        }
    }

    var action: Action? {
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.AssociatedKeyAction) as? ActionWrapper else { return nil }
            return wrapper.action
        }
        set {
            removeTarget(self, action: #selector(onClickAction(_:)), for: .touchUpInside)
            guard let newValue = newValue else { return }
            let wrapper = ActionWrapper(newValue)
            addTarget(self, action: #selector(onClickAction(_:)), for: .touchUpInside)
            objc_setAssociatedObject(self, &AssociatedKeys.AssociatedKeyAction, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private func onClickAction(_ sender: UIControl) {
        guard let action = action else { return }
        action()
    }
}
