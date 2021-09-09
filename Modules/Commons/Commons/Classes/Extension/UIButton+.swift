//
//  UIButton+.swift
//  Commons
//
//  Created by Yang on 2021/7/9.
//

import UIKit

public extension UIButton {

    enum ImagePosition {
        case left, top, right, bottom
    }

    var titleFont: UIFont? {
        get { titleLabel?.font }
        set { titleLabel?.font = newValue }
    }

    func setImagePosition(_ position: ImagePosition, spacing: CGFloat, padding: CGFloat = 0) {
        guard let imageSize = currentImage?.size else { return }
        guard let titleSize = currentTitle?.size(titleLabel?.font ?? .systemFont(ofSize: 17)) else { return }

        switch position {
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2 + padding, bottom: 0, right: spacing / 2 + padding)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + spacing / 2, bottom: 0, right: -titleSize.width - spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width - spacing / 2, bottom: 0, right: imageSize.width + spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2 + padding, bottom: 0, right: spacing / 2 + padding)
        case .top:
            let maxHeight = max(titleSize.height, imageSize.height)
            let maxWidth = max(titleSize.width, imageSize.width)
            let totalWidth = titleSize.width + imageSize.width
            
            contentEdgeInsets = UIEdgeInsets(top: maxHeight / 2 + spacing / 2 + padding,
                                             left: -(totalWidth - maxWidth) / 2,
                                             bottom: maxHeight / 2 + spacing / 2 + padding,
                                             right: -(totalWidth - maxWidth) / 2)
            imageEdgeInsets = UIEdgeInsets(top: -imageSize.height / 2 - spacing / 2,
                                           left: titleSize.width / 2,
                                           bottom: imageSize.height / 2 + spacing / 2,
                                           right:  -titleSize.width / 2)
            titleEdgeInsets = UIEdgeInsets(top: titleSize.height / 2 + spacing / 2,
                                           left: -imageSize.width / 2,
                                           bottom: -titleSize.height / 2 - spacing / 2,
                                           right: imageSize.width / 2)
        case .bottom:
            let maxHeight = max(titleSize.height, imageSize.height)
            let maxWidth = max(titleSize.width, imageSize.width)
            let totalWidth = titleSize.width + imageSize.width

            contentEdgeInsets = UIEdgeInsets(top: maxHeight / 2 + spacing / 2 + padding,
                                             left: -(totalWidth - maxWidth) / 2,
                                             bottom: maxHeight / 2 + spacing / 2 + padding,
                                             right: -(totalWidth - maxWidth) / 2)
            imageEdgeInsets = UIEdgeInsets(top: titleSize.height / 2 + spacing / 2,
                                           left: titleSize.width / 2,
                                           bottom: -titleSize.height / 2 - spacing / 2,
                                           right:  -titleSize.width / 2)
            titleEdgeInsets = UIEdgeInsets(top: -imageSize.height / 2 - spacing / 2,
                                           left: -imageSize.width / 2,
                                           bottom: imageSize.height / 2 + spacing / 2,
                                           right: imageSize.width / 2)
        }
    }

    func setBackgroundColor(_ color: UIColor, for state: State) {
        setBackgroundImage(color.toImage(), for: state)
    }
}
