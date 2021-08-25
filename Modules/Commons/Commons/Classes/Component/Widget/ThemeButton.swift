//
//  UIButton+.swift
//  Themes
//
//  Created by Yang on 2021/7/12.
//

import UIKit

public class ThemeButton: UIButton {

    public enum ThemeType {
        case yellowBlack // 黄底黑字
        case whiteBlue // 白底蓝边蓝字
        case whiteBlack // 白底黑边黑字
        case clearBlue // 无边框蓝字
        case grayBlack // 灰底黑字
        case whiteGray // 白底灰色边框
        case red  //红底红字
    }

    public override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.9 : 1.0
        }
    }

    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }

    public convenience init(_ title: String, _ fontSize: CGFloat = 14, _ radius: CGFloat = 16, type: ThemeType = .yellowBlack) {
        self.init(frame: .zero)

        titleFont = .font(ofSize: fontSize, type: .semibold)
        setTitle(title, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = radius

        switch type {
        case .yellowBlack:
            backgroundColor = Colors.textHint
            setTitleColor(Colors.textPrimary, for: .normal)
        case .whiteBlue:
            backgroundColor = Colors.background
            setTitleColor(Colors.blue_600, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = Colors.blue_600.cgColor
        case .whiteBlack:
            backgroundColor = Colors.background
            setTitleColor(Colors.textPrimary, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = Colors.textPrimary.cgColor
        case .clearBlue:
            backgroundColor = Colors.background
            setTitleColor(Colors.blue_600, for: .normal)
        case .grayBlack:
            backgroundColor = Colors.separator
            setTitleColor(Colors.textPrimary, for: .normal)
        case .red:
            backgroundColor = Colors.red_100
            setTitleColor(Colors.red_600, for: .normal)
        default:
            break
        }
    }
}
