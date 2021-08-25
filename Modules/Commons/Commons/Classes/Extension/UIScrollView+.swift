//
//  UIScrollView+.swift
//  Components
//
//  Created by Yang on 2021/7/8.
//

import UIKit

public extension UIScrollView {

    var contentOffsetX: CGFloat {
        get { contentOffset.x }
        set {
            var offset = contentOffset
            offset.x = newValue
            contentOffset = offset
        }
    }

    var contentOffsetY: CGFloat {
        get { contentOffset.y }
        set {
            var offset = contentOffset
            offset.y = newValue
            contentOffset = offset
        }
    }

    var contentWidth: CGFloat {
        get { contentSize.width }
        set {
            var size = contentSize
            size.width = newValue
            contentSize = size
        }
    }

    var contentHeight: CGFloat {
        get { contentSize.height }
        set {
            var size = contentSize
            size.height = newValue
            contentSize = size
        }
    }
}
