//
//  CGFloat.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public extension CGFloat {

    static func +(_ this: CGFloat, _ other: Int) -> CGFloat {
        this + CGFloat(other)
    }

    static func -(_ this: CGFloat, _ other: Int) -> CGFloat {
        this - CGFloat(other)
    }

    static func *(_ this: CGFloat, _ other: Int) -> CGFloat {
        this * CGFloat(other)
    }

    static func /(_ this: CGFloat, _ other: Int) -> CGFloat {
        this / CGFloat(other)
    }
}
