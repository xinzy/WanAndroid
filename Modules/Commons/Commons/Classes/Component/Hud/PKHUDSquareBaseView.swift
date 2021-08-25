//
//  PKHUDSquareBaseView.swift
//  PKHUD
//
//  Created by Philip Kluz on 6/12/15.
//  Copyright (c) 2016 NSExceptional. All rights reserved.
//  Licensed under the MIT license.
//

import UIKit

/// PKHUDSquareBaseView provides a square view, which you can subclass and add additional views to.
open class PKHUDSquareBaseView: UIView {

    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    open var padding: CGFloat = 20

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil) {
        super.init(frame: PKHUDSquareBaseView.defaultSquareBaseViewFrame)
        imageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(closeButton)

        let titleSize = titleLabel.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.frame = CGRect(origin: CGPoint.zero, size: titleSize)
        let subtitleSize = subtitleLabel.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude))
        subtitleLabel.frame = CGRect(origin: CGPoint.zero, size: subtitleSize)
        var width: CGFloat = max(titleSize.width, subtitleSize.width) + 2 * padding
        var height: CGFloat = titleSize.height + subtitleSize.height + (image?.size.height ?? 0) + padding
        if title != nil {
            height += padding
        }
        if image != nil {
            height += padding
        }
        if subtitle != nil {
            height += padding
        }
        width = max(max(width, height), 120)
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
    }

    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.85
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        return imageView
    }()

    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    public let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(imageNamed("icon_8px_delete"), for: .normal)
        button.isHidden = true
        return button
    }()

    open override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.center = CGPoint(x: frame.size.width / 2, y: padding + titleLabel.frame.size.height / 2)
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.image?.size.width ?? 0, height: imageView.image?.size.height ?? 0)
        let y: CGFloat
        if titleLabel.text != nil {
            y = titleLabel.frame.maxY + (imageView.image?.size.height ?? 0) / 2 + padding
        } else {
            y = (imageView.image?.size.height ?? 0) / 2 + padding
        }
        imageView.center = CGPoint(x: frame.size.width / 2, y: y)
        subtitleLabel.center = CGPoint(x: frame.size.width / 2, y: frame.size.height - padding - subtitleLabel.frame.size.height / 2)
        closeButton.frame = CGRect(x: frame.size.width - 14, y: 6, width: 8, height: 8)
    }
}
