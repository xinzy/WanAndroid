//
//  RegisterController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/16.
//

import UIKit
import Commons
import SnapKit

class RegisterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "用户注册"
        setupView()
    }


    private lazy var usernameField: LoginInputField = {
        let field = LoginInputField()
        field.placeholder = "用户名"
        field.clearButtonMode = .whileEditing
        return field
    }()

    private lazy var passwordField: LoginInputField = {
        let field = LoginInputField()
        field.placeholder = "密码"
        field.isSecureTextEntry = true
        field.rightView = secrectButton
        field.rightViewMode = .always
        return field
    }()

    private lazy var confirmField: LoginInputField = {
        let field = LoginInputField()
        field.placeholder = "确认密码"
        field.isSecureTextEntry = true
        field.rightView = confirmSecretButton
        field.rightViewMode = .always
        return field
    }()

    private lazy var secrectButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        btn.setImage(.iconPasswordHidden, for: .normal)
        btn.setImage(.iconPasswordShown, for: .selected)
        btn.addTarget(self, action: #selector(sectureButtonClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var confirmSecretButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        btn.setImage(.iconPasswordHidden, for: .normal)
        btn.setImage(.iconPasswordShown, for: .selected)
        btn.addTarget(self, action: #selector(sectureButtonClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var loginButton: ThemeButton = {
        let button = ThemeButton("注册", 16, 22)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    private lazy var loginTextView: UITextView = {
        let attributeString = NSMutableAttributedString(string: "已有账号？点我登录")
        attributeString.addAttribute(.link, value: "login://", range: NSRange(location: 5, length: 4))

        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.attributedText = attributeString
        textView.textColor = Colors.textSecondary
        textView.font = .font(ofSize: 12)
        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.blue_600,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        return textView
    }()
}

extension RegisterController {
    static func showController(_ controller: UIViewController) {
        let navigationController = ThemeNavigationController(rootViewController: LoginController())
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = Colors.background

        view.addSubview(usernameField)
        usernameField.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.equalTo(-horizontalPadding)
            make.top.equalTo(96)
            make.height.equalTo(36)
        }

        view.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(usernameField)
            make.top.equalTo(usernameField.snp.bottom).offset(16)
        }

        view.addSubview(confirmField)
        confirmField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(usernameField)
            make.top.equalTo(passwordField.snp.bottom).offset(16)
        }

        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(confirmField.snp.bottom).offset(32)
            make.leading.equalTo(48)
            make.trailing.equalTo(-48)
            make.height.equalTo(44)
        }

        view.addSubview(loginTextView)
        loginTextView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func sectureButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender == secrectButton {
            if sender.isSelected {
                passwordField.isSecureTextEntry = false
            } else {
                passwordField.isSecureTextEntry = true
            }
        } else if sender == confirmSecretButton {
            if sender.isSelected {
                confirmField.isSecureTextEntry = false
            } else {
                confirmField.isSecureTextEntry = true
            }
        }
    }

    @objc private func login() {

    }
}

extension RegisterController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.absoluteString == "login://" {
            navigationController?.popViewController(animated: true)
        }
        return true
    }
}
