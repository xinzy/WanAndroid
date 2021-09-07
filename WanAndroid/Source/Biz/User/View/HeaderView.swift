//
//  HeaderView.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/30.
//

import UIKit
import Commons
import SnapKit

class HeaderView: UIView {

    var loginAction: (() -> Void)?

    var user: User = User.me {
        didSet {
            if user.isLogin {
                usernameButton.setTitle(user.nickname, for: .normal)
            } else {
                usernameButton.setTitle("点击登录", for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    private func setupView() {
        addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.width.height.equalTo(48)
            make.centerY.equalToSuperview()
        }

        addSubview(usernameButton)
        usernameButton.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(16)
            make.centerY.equalTo(avatarView)
        }
    }

    @objc private func loginClick() {
        loginAction?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .iconHeaderAvatar
        return view
    }()

    private lazy var usernameButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(Colors.textSecondary, for: .normal)
        btn.titleFont = .font(ofSize: 16, type: .semibold)
        if user.isLogin {
            btn.setTitle(user.nickname, for: .normal)
        } else {
            btn.setTitle("点击登录", for: .normal)
        }
        btn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        return btn
    }()
}

class HeaderWrapperView: UIView {

    init() {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: statusBarHeight + 72)
        super.init(frame: frame)
        backgroundColor = Colors.backgroundPrimary
        addSubview(headerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let headerView = HeaderView(frame: CGRect(x: 0, y: statusBarHeight, width: ScreenWidth, height: 72))
}
