//
//  RefreshView.swift
//  Themes
//
//  Created by Yang on 2021/7/7.
//

import UIKit
import MJRefresh

public class BallRefreshHeaderView: MJRefreshHeader {
    public override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                animationView.stopAnimation()
            case .refreshing:
                animationView.startAnimation()
            default: break
            }
        }
    }

    public override var pullingPercent: CGFloat {
        didSet {
            if pullingPercent <= -0.0 { return }
            if state == .refreshing { return }
            let percent = pullingPercent > 1 ? 1 : pullingPercent
            animationView.pullingPercent = percent
        }
    }

    public override func prepare() {
        super.prepare()
        addSubview(animationView)
        mj_h = 64
    }

    public override func placeSubviews() {
        super.placeSubviews()
        animationView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        animationView.width = width
    }

    private let animationView: BallView = BallView(frame: CGRect(x: 0, y: 0, width: 64, height: 48))
}

public class BallRefreshFooterView: MJRefreshAutoFooter {
    public var noMoreDataTitle: String = "- - - - - - - - - 我是有底线滴 - - - - - - - - - "

    public override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                animationView.stopAnimation()
                noDataLabel.isHidden = true
                animationView.isHidden = true
            case .pulling:
                noDataLabel.isHidden = true
                animationView.isHidden = true
            case .willRefresh:
                noDataLabel.isHidden = false
                animationView.isHidden = true
            case .refreshing:
                animationView.pullingPercent = 1
                animationView.startAnimation()
                noDataLabel.isHidden = true
                animationView.isHidden = false
            case .noMoreData:
                noDataLabel.isHidden = false
                animationView.isHidden = true
                animationView.stopAnimation()
            default: break
            }
        }
    }

    public override func prepare() {
        super.prepare()
        addSubview(animationView)
        addSubview(noDataLabel)
        mj_h = 64
    }

    public override func placeSubviews() {
        super.placeSubviews()
        noDataLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        animationView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }

    private let animationView: BallView = BallView(frame: CGRect(x: 0, y: 0, width: 64, height: 48))
    private lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 24, width: 300, height: 16))
        label.textColor = Colors.textHint
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = noMoreDataTitle
        label.isHidden = true
        return label
    }()
}

public class BallView: UIView {
    let distance: CGFloat = 14

    private let itemSize: CGFloat = 8.0
    private let animationBegins = [0.15, 0.3, 0.45]

    public var itemColor: UIColor = Colors.textHint {
        didSet {
            if itemColor == oldValue { return }
            subviews.forEach { $0.backgroundColor = itemColor }
        }
    }

    public var pullingPercent: CGFloat = 0 {
        didSet {
            let centerView = subviews[1]
            let offset = pullingPercent * distance
            subviews[0].center = CGPoint(x: centerView.center.x - offset, y: centerView.center.y)
            subviews[2].center = CGPoint(x: centerView.center.x + offset, y: centerView.center.y)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        for _ in 0 ..< 3 {
            let ball = createBall()
            addSubview(ball)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { $0.center = CGPoint(x: frame.width / 2, y: frame.height / 2) }
        let percent = pullingPercent
        pullingPercent = percent
    }

    public func startAnimation() {
        for (index, item) in subviews.enumerated() {
            let animation = createAnimationGroup(animationBegins[index])
            item.layer.add(animation, forKey: "animation")
        }
    }

    public func stopAnimation() {
        subviews.forEach { $0.layer.removeAllAnimations() }
    }

    private func createAnimationGroup(_ timeBegin: TimeInterval) -> CAAnimationGroup {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform")
        scaleAnimation.values = [
            NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 0))
        ]
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.3, 1.0]

        let group = CAAnimationGroup()
        group.animations = [scaleAnimation, opacityAnimation]
        group.autoreverses = true
        group.beginTime = timeBegin
        group.repeatCount = HUGE
        group.duration = 0.5
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        return group
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createBall() -> UIView {
        let ball = UIView(frame: CGRect(x: 0, y: 0, width: itemSize, height: itemSize))
        ball.backgroundColor = itemColor
        ball.layer.masksToBounds = true
        ball.layer.cornerRadius = itemSize / 2
        return ball
    }
}
