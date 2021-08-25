//
//  LoginController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/2.
//

import UIKit
import Commons
import SnapKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "用户登录"
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
        field.rightView = sectureButton
        field.rightViewMode = .always
        return field
    }()

    private lazy var sectureButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        btn.setImage(.iconPasswordHidden, for: .normal)
        btn.setImage(.iconPasswordShown, for: .selected)
        btn.addTarget(self, action: #selector(sectureButtonClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var closeItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(.iconClose, for: .normal)
        button.action = { [weak self] in self?.dismiss(animated: true) }
        return UIBarButtonItem(customView: button)
    }()

    private lazy var loginButton: ThemeButton = {
        let button = ThemeButton("登录", 16, 22)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()

    private lazy var registerTextView: UITextView = {
        let attributeString = NSMutableAttributedString(string: "没有账号？点我注册")
        attributeString.addAttribute(.link, value: "register://", range: NSRange(location: 5, length: 4))

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

extension LoginController: AutoDisposed {
    static func showController(_ controller: UIViewController) {
        let navigationController = ThemeNavigationController(rootViewController: LoginController())
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = Colors.backgroundPrimary
        navigationItem.rightBarButtonItem = closeItem

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

        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.leading.equalTo(48)
            make.trailing.equalTo(-48)
            make.height.equalTo(44)
        }

        view.addSubview(registerTextView)
        registerTextView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func sectureButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passwordField.isSecureTextEntry = false
        } else {
            passwordField.isSecureTextEntry = true
        }
    }

    @objc private func login() {
        HUD.show(.progress)
        ApiHelper.login(usernameField.text ?? "", passwordField.text ?? "").subscribe { [weak self] result in
            guard let `self` = self else { return }
            HUD.hide()
            if result.isLogin {
                User.me.login(result)
                self.navigationController?.dismiss(animated: true)
            } else {
                HUD.tip(text: "用户名或密码错误")
            }
        }.disposed(by: disposeBag)
    }
}

extension LoginController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(url.absoluteString)
        if url.absoluteString == "register://" {
            let controller = RegisterController()
            navigationController?.pushViewController(controller, animated: true)
        }
        return true
    }
}
