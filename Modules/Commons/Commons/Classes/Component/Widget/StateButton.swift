//
//  StateButton.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import UIKit

public class StateButton: UIButton {

    public var disableColor: UIColor?
    public var highlightColor: UIColor?
    public var selectedColor: UIColor?
    public var normalColor: UIColor = .clear {
        didSet {
            backgroundColor = normalColor
        }
    }

    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalColor : (disableColor ?? normalColor)
        }
    }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? (highlightColor ?? normalColor) : normalColor
        }
    }

    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? (selectedColor ?? normalColor) : normalColor
        }
    }
}
