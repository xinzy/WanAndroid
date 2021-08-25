//
//  UIFont+.swift
//  Commons
//
//  Created by Yang on 2021/7/9.
//

import UIKit

public extension UIFont {
    enum FontType {
        case regular
        case light
        case medium
        case semibold
        case dinbold
    }

    static func font(ofSize: CGFloat, type: FontType = .regular) -> UIFont {
        let font: UIFont?
        switch type {
        case .regular:
            font = UIFont(name: "PingFangSC-Regular", size: ofSize)
        case .light:
            font = UIFont(name: "PingFangSC-Light", size: ofSize)
        case .medium:
            font = UIFont(name: "PingFangSC-Medium", size: ofSize)
        case .semibold:
            font = UIFont(name: "PingFangSC-Semibold", size: ofSize)
        case .dinbold:
            font = UIFont(name: "DIN-Bold", size: ofSize)
        }
        return font ?? UIFont.systemFont(ofSize: ofSize)
    }
}
