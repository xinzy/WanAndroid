//
//  TestOverlayController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/26.
//

import UIKit
import SnapKit
import Commons

class TestOverlayController: OverlayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.isUserInteractionEnabled = false
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("测试红红火火", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private lazy var contentView: UIView = UIControl().then {
        $0.cornerRadius(12)
        $0.backgroundColor = .green
        $0.action = { [weak self] in self?.dismiss(animated: true) }
    }
}
