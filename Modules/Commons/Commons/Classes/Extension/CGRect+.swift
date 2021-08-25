//
//  CGRect.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public extension CGRect {

    var left: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }

    var right: CGFloat {
        get { origin.x + width }
        set { origin.x = newValue - width }
    }

    var top: CGFloat {
        get { origin.y }
        set { origin.y = newValue }
    }

    var bottom: CGFloat {
        get { origin.y + height }
        set { origin.y = newValue - height }
    }

    var centerX: CGFloat {
        get { (left + width) / 2 }
        set { left += newValue - centerX }
    }

    var centerY: CGFloat {
        get { (top + height) / 2 }
        set { top += newValue - centerY }
    }

    var center: CGPoint {
        get { CGPoint(x: centerX, y: centerY) }
        set {
            centerX = center.x
            centerY = center.y
        }
    }
}
