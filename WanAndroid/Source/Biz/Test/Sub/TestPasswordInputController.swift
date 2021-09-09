//
//  TestPasswordInputController.swift
//  WanAndroid
//
//  Created by Yang on 2021/9/7.
//

import UIKit
import Commons
import SnapKit

class TestPasswordInputController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary
        view.addSubview(input1)
        input1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(64)
            make.height.equalTo(64)
        }

        view.addSubview(input2)
        input2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(input1.snp.bottom).offset(32)
            make.height.equalTo(64)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private lazy var input1: PasswordInputView = {
        let view = PasswordInputView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var input2: PasswordInputView = {
        let view = PasswordInputView()
        view.configuration.displayMode = .plain(textColor: Colors.textPrimary, textSize: 24)
        view.backgroundColor = .clear
        return view
    }()
}
