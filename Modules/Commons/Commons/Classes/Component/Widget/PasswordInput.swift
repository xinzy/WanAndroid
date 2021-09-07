//
//  PasswordInputView.swift
//  Commons
//
//  Created by Yang on 2021/9/6.
//

import UIKit

public struct PasswordInputConfiguration {

    public static let `default`: PasswordInputConfiguration = PasswordInputConfiguration()

    public enum DisplayMode {
        case plain(textColor: UIColor, textSize: CGFloat)
        case encryption(dotColor: UIColor, dotRadius: CGFloat)
    }

    /// 密码长度
    @RangeValueWrapper(range: 4...8, defaultValue: 6)
    public var passwordNumber: Int

    /// 每一个方块的尺寸
    @RangeValueWrapper(range: 32...96, defaultValue: 48)
    public var squareSize: CGFloat

    /// 圆角
    @RangeValueWrapper(range: 0...12, defaultValue: 6)
    public var squareRadius: CGFloat

    /// 方块的间距
    @RangeValueWrapper(range: 0...12, defaultValue: 6)
    public var itemSpacing: CGFloat

    /// 边框宽度
    @RangeValueWrapper(range: 0...5, defaultValue: 1)
    public var borderWidth: CGFloat

    /// 边框颜色
    public var borderColor: UIColor = Colors.cyan_500

    /// 输入框背景色
    public var fillColor: UIColor = Colors.cyan_100

    /// 边框宽度
    @RangeValueWrapper(range: 0...5, defaultValue: 1)
    public var borderHighlightWidth: CGFloat

    /// 边框高亮色
    public var borderHighlightColor: UIColor = Colors.orange_500

    /// 输入框高亮色
    public var fillHighlightColor: UIColor = Colors.orange_100

    /// 显示方式
    public var displayMode: DisplayMode = .encryption(dotColor: Colors.textPrimary, dotRadius: 8)

    /// 输入完毕自动失焦
    public var autoLostFocusWhenComplete: Bool = true

    var isSecure: Bool {
        switch displayMode {
        case .encryption: return true
        case .plain: return false
        }
    }
}

public protocol PasswordInputViewDelegate: AnyObject {
    /// 获取焦点
    func passwordInputViewGetFocus(_ view: PasswordInputView)

    /// 失去焦点
    func passwordInputViewLoseFocus(_ view: PasswordInputView)

    /// 输入内容改变
    func passswordInputViewDidChange(_ view: PasswordInputView)

    /// 点击删除
    func passwordInputViewDidBackward(_ view: PasswordInputView)

    /// 输入完成
    func passwordInputViewComplete(_ view: PasswordInputView)
}

extension PasswordInputViewDelegate {
    func passwordInputViewGetFocus(_ view: PasswordInputView) { }

    func passwordInputViewLoseFocus(_ view: PasswordInputView) { }

    func passswordInputViewDidChange(_ view: PasswordInputView) { }

    func passwordInputViewDidBackward(_ view: PasswordInputView) { }

    func passwordInputViewComplete(_ view: PasswordInputView) { }
}

public class PasswordInputView: UIView {

    public weak var delegate: PasswordInputViewDelegate?

    public var configuration: PasswordInputConfiguration = PasswordInputConfiguration.default {
        didSet { setNeedsDisplay() }
    }

    public private(set) var text: String = ""

    private var isKeyboardShown: Bool = false

    public override var canBecomeFirstResponder: Bool { true }

    public override var canResignFirstResponder: Bool { true }

    public override func becomeFirstResponder() -> Bool {
        if !isKeyboardShown {
            isKeyboardShown = true
            delegate?.passwordInputViewGetFocus(self)
            setNeedsDisplay()
        }
        return super.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        if isKeyboardShown {
            isKeyboardShown = false
            delegate?.passwordInputViewLoseFocus(self)
            setNeedsDisplay()
        }
        return super.resignFirstResponder()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isFirstResponder {
            _ = becomeFirstResponder()
        }
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        let viewWidth = rect.width
        let viewHeight = rect.height

        // 每一个方块的大小
        let squareItemSize = min(min(configuration.squareSize, viewHeight),
                                 (viewWidth - configuration.itemSpacing * (configuration.passwordNumber - 1)) / configuration.passwordNumber)
        // 第一个方块距view 左边距
        let firstSquareLeftPadding = (viewWidth - squareItemSize * configuration.passwordNumber - configuration.itemSpacing * (configuration.passwordNumber - 1)) / 2
        // 第一个方块距view 上边距
        let topPadding = (viewHeight - squareItemSize) / 2
        let highlightIndex = text.count // 高亮的index

        for index in 0..<configuration.passwordNumber {
            let itemRect = CGRect(x: firstSquareLeftPadding + (configuration.itemSpacing + squareItemSize) * index,
                                  y: topPadding, width: squareItemSize, height: squareItemSize)

            let highlight = isFirstResponder && highlightIndex == index
            let squarePath = UIBezierPath(roundedRect: itemRect, cornerRadius: configuration.squareRadius)
            if highlight {
                squarePath.lineWidth = configuration.borderHighlightWidth
                configuration.borderHighlightColor.setStroke()
                configuration.fillHighlightColor.setFill()
            } else {
                squarePath.lineWidth = configuration.borderWidth
                configuration.borderColor.setStroke()
                configuration.fillColor.setFill()
            }
            squarePath.fill()
            squarePath.stroke()

            if index < highlightIndex { // 已输入的内容
                switch configuration.displayMode {
                case let .plain(textColor, textSize):
                    let str = self.text.substring(start: index, count: 1) as NSString

                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    let attr: [NSAttributedString.Key: Any] = [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize),
                        NSAttributedString.Key.paragraphStyle: style,
                        NSAttributedString.Key.foregroundColor: textColor
                    ]
                    let size = str.size(withAttributes: attr)
                    let textRect = CGRect(x: itemRect.minX, y: itemRect.minY + (itemRect.height - size.height) / 2, width: itemRect.width, height: size.height)
                    str.draw(in: textRect, withAttributes: attr)

                case let .encryption(dotColor, dotRadius):
                    let dotPath = UIBezierPath(arcCenter: itemRect.center, radius: dotRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                    dotColor.setFill()
                    dotPath.fill()
                }
            }
        }
    }
}

extension PasswordInputView: UIKeyInput {

    public var keyboardType: UIKeyboardType {
        get { .numberPad }
        set { }
    }

    public var isSecureTextEntry: Bool {
        get { configuration.isSecure }
        set { }
    }

    public var hasText: Bool { text.isNotEmpty }

    public func insertText(_ text: String) {
        if self.text.count >= configuration.passwordNumber { return }

        self.text.append(text)
        setNeedsDisplay()
        delegate?.passswordInputViewDidChange(self)
        if self.text.count == configuration.passwordNumber {
            delegate?.passwordInputViewComplete(self)
            if configuration.autoLostFocusWhenComplete {
                _ = resignFirstResponder()
            }
        }
    }

    public func deleteBackward() {
        if text.isEmpty { return }
        text.removeLast()
        setNeedsDisplay()
        delegate?.passwordInputViewDidBackward(self)
    }
}
