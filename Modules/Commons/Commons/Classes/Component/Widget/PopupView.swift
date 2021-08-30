//
//  PopupView.swift
//  Commons
//
//  Created by Yang on 2021/8/27.
//

import UIKit

public class PopupView: UIControl {
    public struct Config {
        /// 箭头方向
        public var arrowDirection: ArrowDirection = .bottom
        /// 箭头大小
        public var arrowSize: CGSize = CGSize(width: 12, height: 8)
        ///箭头所在位置比例
        public var arrowPositionRatio: CGFloat = 0.5
        /// 箭头与锚View的间距
        public var arrowSpacing: CGFloat = 4
        /// 弹出View圆角
        public var contentViewRadius: CGFloat = 8
        /// 弹出View背景色
        public var contentViewBackgroundColor: UIColor = .white
        /// 遮罩色
        public var maskColor: UIColor = .black.withAlphaComponent(0.35)
        /// 模糊
        var maskBlur: UIBlurEffect?
        /// 动画执行时间
        public var animationTimeInterval: TimeInterval = 0.35

        /// 高亮锚View 圆角大小
        public var highlightAnchorViewRadiusSize: CGSize = CGSize(width: 8, height: 8)
        /// 锚View高亮
        public var isHighlightAnchorView: Bool = false
        /// 阴影颜色
        public var shadowColor: UIColor = .black.withAlphaComponent(0.3)
        /// 阴影
        public var isShowShadow: Bool = true
        /// 点击其他区域关闭
        public var dismissWhenTouchOutside: Bool = true
    }

    public enum ArrowDirection {
        case top, bottom, left, right
    }

    public var config: Config = Config()
    private weak var rootView: UIView!
    private var contentView: UIView!
    private var anchorViewFrameInRoot: CGRect = .zero // 锚View在屏幕上的位置
    private var arrowFrame: CGRect = .zero

    public func show(_ contentView: UIView, anchorView: UIView) {
        guard let window = UIApplication.shared.keyWindow else { return }
        self.rootView = window
        self.contentView = contentView
        self.anchorViewFrameInRoot = anchorView.convert(anchorView.bounds, to: window)

        configuration()
        show()
        showAnimation()
    }

    public func dismiss() {
        UIView.animate(withDuration: config.animationTimeInterval) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private lazy var backgroundView: UIView = {
        let view = UIView(frame: frame)
        view.isUserInteractionEnabled = false

        let path = UIBezierPath(rect: frame)
        if config.isHighlightAnchorView {
            let highlightPath = UIBezierPath(roundedRect: anchorViewFrameInRoot, byRoundingCorners: .allCorners, cornerRadii: config.highlightAnchorViewRadiusSize)
            path.append(highlightPath)
            path.usesEvenOddFillRule = true
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillRule = .evenOdd
        shapeLayer.fillColor = config.maskColor.cgColor

        view.layer.addSublayer(shapeLayer)
        return view
    }()

    private lazy var triangleView: TriangleView = {
        let view = TriangleView()
        view.backgroundColor = .clear
        view.direction = config.arrowDirection
        view.fillColor = config.contentViewBackgroundColor
        return view
    }()
}

extension PopupView {
    private func configuration() {
        alpha = 0
        frame = rootView.frame
        backgroundColor = .clear

        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = config.contentViewRadius
        contentView.backgroundColor = config.contentViewBackgroundColor
        if config.isShowShadow {
            contentView.shadow(config.shadowColor)
        }

        if config.dismissWhenTouchOutside {
            addTarget(self, action: #selector(onTapOutside), for: .touchUpInside)
        }
        if let blur = config.maskBlur {
            let effectView = UIVisualEffectView(effect: blur)
            effectView.alpha = 0.3
            effectView.isUserInteractionEnabled = false
            effectView.frame = rootView.bounds
            addSubview(effectView)
        }
    }

    private func show() {
        let contentViewFrame = contentView.frame
        switch config.arrowDirection {
        case .left:
            let topDivide = (contentViewFrame.height - config.arrowSize.width) * config.arrowPositionRatio
            let y = anchorViewFrameInRoot.centerY - topDivide - config.arrowSize.width / 2
            let x = anchorViewFrameInRoot.maxX + config.arrowSpacing + config.arrowSize.height
            contentView.frame.origin = CGPoint(x: x, y: y)
            arrowFrame = CGRect(x: anchorViewFrameInRoot.maxX + config.arrowSpacing,
                                y: anchorViewFrameInRoot.centerY - config.arrowSize.width / 2,
                                width: config.arrowSize.height, height: config.arrowSize.width)
        case .right:
            let topDivide = (contentViewFrame.height - config.arrowSize.width) * config.arrowPositionRatio
            let y = anchorViewFrameInRoot.centerY - topDivide - config.arrowSize.width / 2
            let x = anchorViewFrameInRoot.minX - contentViewFrame.width - config.arrowSize.height - config.arrowSpacing
            contentView.frame.origin = CGPoint(x: x, y: y)
            arrowFrame = CGRect(x: anchorViewFrameInRoot.minX - config.arrowSpacing - config.arrowSize.height,
                                y: anchorViewFrameInRoot.centerY - config.arrowSize.width / 2,
                                width: config.arrowSize.height, height: config.arrowSize.width)
        case .top:
            let leftDivider = (contentViewFrame.width - config.arrowSize.width) * config.arrowPositionRatio
            let x = anchorViewFrameInRoot.centerX - leftDivider - config.arrowSize.width / 2
            let y = anchorViewFrameInRoot.maxY + config.arrowSize.height + config.arrowSpacing
            contentView.frame.origin = CGPoint(x: x, y: y)
            arrowFrame = CGRect(x: anchorViewFrameInRoot.centerX - config.arrowSize.width / 2, y: anchorViewFrameInRoot.maxY + config.arrowSpacing,
                                width: config.arrowSize.width, height: config.arrowSize.height)
        case .bottom:
            let leftDivider = (contentViewFrame.width - config.arrowSize.width) * config.arrowPositionRatio
            let x = anchorViewFrameInRoot.centerX - leftDivider - config.arrowSize.width / 2
            let y = anchorViewFrameInRoot.minY - config.arrowSize.height - config.arrowSpacing - contentViewFrame.height
            contentView.frame.origin = CGPoint(x: x, y: y)
            arrowFrame = CGRect(x: anchorViewFrameInRoot.centerX - config.arrowSize.width / 2, y: anchorViewFrameInRoot.minY - config.arrowSpacing - config.arrowSize.height,
                                width: config.arrowSize.width, height: config.arrowSize.height)
        }

        addSubview(backgroundView)
        triangleView.frame = arrowFrame
        addSubview(triangleView)
        addSubview(contentView)
        rootView.addSubview(self)
    }

    private func showAnimation() {
        UIView.animate(withDuration: config.animationTimeInterval) {
            self.alpha = 1
        }
    }

    @objc private func onTapOutside() {
        dismiss()
    }
}

extension PopupView {

    private class TriangleView: UIView {
        var direction: ArrowDirection = .left
        var fillColor: UIColor = .white

        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            let path = UIBezierPath()
            switch direction {
            case .left:
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.centerY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            case .right:
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.centerY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            case .top:
                path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.centerX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            case .bottom:
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.centerX, y: rect.maxY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            }
            path.close()
            fillColor.setFill()
            path.fill()
        }
    }
}
