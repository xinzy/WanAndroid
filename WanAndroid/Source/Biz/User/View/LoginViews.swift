//
//  LoginInputField.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/2.
//

import UIKit
import Commons
import SnapKit

class LoginInputField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        textColor = Colors.textPrimary
        font = .font(ofSize: 14)
        borderStyle = .none

        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}

class LogoutButton: UIView {
    var action: UIButton.Action? {
        get { button.action }
        set { button.action = newValue }
    }

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.cell
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(Colors.red_600, for: .normal)
        return button
    }()
}
