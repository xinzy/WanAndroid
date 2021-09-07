//
//  AutoResizeTextView.swift
//  Commons
//
//  Created by Yang on 2021/9/3.
//

import UIKit

public class AutoResizeTextView: UITextView {

    public var minimumHeight: CGFloat = 0
    public var maximumHeight: CGFloat = CGFloat(MAXFLOAT)

    public override var contentSize: CGSize {
        didSet {

        }
    }
}
