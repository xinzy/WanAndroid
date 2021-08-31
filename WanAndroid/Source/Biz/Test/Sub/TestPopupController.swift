//
//  TestController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/30.
//

import UIKit
import SnapKit
import Commons

class TestPopupController: UIViewController {

    static func showController(_ navigationController: UINavigationController?) {
        let controller = TestPopupController()
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary

        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.trailing.equalTo(-32)
            make.top.equalTo(120)
        }
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalTo(32)
            make.top.equalTo(120)
        }
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-120)
        }
        view.addSubview(topButton)
        topButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(120)
        }
    }

    @objc private func onBtnClick(_ sender: UIButton) {
        let popupView = PopupView()
        switch sender.tag {
        case 1:
            let contentView = PopupContentView(frame: CGRect(x: 0, y: 0, width: 120, height: 240))
            popupView.config.arrowDirection = .left
            popupView.config.isHighlightAnchorView = true
            popupView.config.arrowPositionRatio = 0.3
            popupView.show(contentView, anchorView: leftButton)
        case 2:
            let contentView = PopupContentView(frame: CGRect(x: 0, y: 0, width: 120, height: 240))
            popupView.config.arrowDirection = .right
            popupView.config.isHighlightAnchorView = true
            popupView.config.isShowShadow = true
            popupView.show(contentView, anchorView: rightButton)
        case 3:
            let contentView = PopupContentView(frame: CGRect(x: 0, y: 0, width: 240, height: 120))
            popupView.config.arrowDirection = .top
            popupView.config.arrowPositionRatio = 0.7
            popupView.show(contentView, anchorView: topButton)
        case 4:
            let contentView = PopupContentView(frame: CGRect(x: 0, y: 0, width: 240, height: 120))
            popupView.config.arrowDirection = .bottom
            popupView.show(contentView, anchorView: bottomButton)
        default: break
        }
    }

    private lazy var leftButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("左箭头", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var rightButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("右箭头", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("上箭头", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 3
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var bottomButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("下箭头", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 4
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
}



class PopupContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let label = UILabel().then { label in
        label.text = "PopupContentView"
    }
}
