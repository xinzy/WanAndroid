//
//  TestSlideController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/31.
//

import UIKit
import SnapKit
import Commons

class TestSlideController: UIViewController {

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

        view.addSubview(sheetButton)
        sheetButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc private func onBtnClick(_ sender: UIButton) {
        let controller = Slide()
        switch sender.tag {
        case 1:
            controller.size = 240
            controller.slidePosition = .left
        case 2:
            controller.size = 240
            controller.slidePosition = .right
            controller.dismissWhenTouchOutside = true
        case 3:
            controller.size = 360
            controller.slidePosition = .top
        case 4:
            controller.size = 360
            controller.slidePosition = .bottom
            controller.dismissWhenTouchOutside = true
        default: break
        }
        controller.present(from: self)
    }

    @objc private func onSheetClick(_ sender: UIButton) {
        let sheet = ActionSheet()
        sheet.titleText = "测试哈哈哈"
        sheet.addLeftButton("左") { print("left") }
        sheet.addRightButton("右") { print("right") }
        ["香蕉", "橘子", "苹果"].forEach { item in
            sheet.addActionItem(item) { print(item) }
        }
        sheet.show(from: self)
    }

    private lazy var leftButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("左", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var rightButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("右", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var topButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("上", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 3
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var bottomButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("下", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.tag = 4
        btn.addTarget(self, action: #selector(onBtnClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var sheetButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Action Sheet", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(onSheetClick(_:)), for: .touchUpInside)
        return btn
    }()
}

fileprivate class Slide: SlideViewController {
    var size: CGFloat = 120
    override var controllerSize: CGFloat { size }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = Colors.backgroundPrimary
    }
}
