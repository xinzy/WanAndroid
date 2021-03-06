//
//  UIView+.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public extension UIView {

    var left: CGFloat {
        get { frame.left }
        set {
            var f = frame
            f.left = newValue
            frame = f
        }
    }

    var right: CGFloat {
        get { frame.right }
        set {
            var f = frame
            f.right = newValue
            frame = f
        }
    }

    var top: CGFloat {
        get { frame.top }
        set {
            var f = frame
            f.top = newValue
            frame = f
        }
    }

    var bottom: CGFloat {
        get { frame.bottom }
        set {
            var f = frame
            f.bottom = newValue
            frame = f
        }
    }

    var centerX: CGFloat {
        get { center.x }
        set {
            var point = center
            point.x = newValue
            center = point
        }
    }

    var centerY: CGFloat {
        get { center.y }
        set {
            var point = center
            point.y = newValue
            center = point
        }
    }

    var width: CGFloat {
        get { frame.width }
        set {
            var f = frame
            f.size.width = newValue
            frame = f
        }
    }

    var height: CGFloat {
        get { frame.height }
        set {
            var f = frame
            f.size.height = newValue
            frame = f
        }
    }

    var size: CGSize {
        get { CGSize(width: width, height: height) }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    func removeAllSubviews() {
        let children = subviews
        if children.isEmpty { return }

        for item in children {
            item.removeFromSuperview()
        }
    }

    func removeSubview(with condition: (UIView) throws -> Bool) rethrows {
        let children = subviews
        if children.isEmpty { return }

        for item in children {
            if try condition(item) {
                item.removeFromSuperview()
            }
        }
    }

    func cornerRadius(_ radius: CGFloat, _ borderColor: UIColor = .clear, _ borderWidth: CGFloat = 0) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    func cornerRadii(_ radius: CGFloat, corners: UIRectCorner = [.allCorners]) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }

    func shadow(_ color: UIColor, offset: CGSize = .zero, opacity: Float = 0.8, radius: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }

    func addTapGesture(_ target: Any, _ action: Selector, _ tapNumber: Int = 1) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
    }

    func removeAllGestureRecognizers() {
        gestureRecognizers?.removeAll()
    }

    func setContentHuggingPriority(priority: Float, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(UILayoutPriority(priority), for: axis)
    }

    func setContentCompressionResistancePriority(priority: Float, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(UILayoutPriority(priority), for: axis)
    }
}
