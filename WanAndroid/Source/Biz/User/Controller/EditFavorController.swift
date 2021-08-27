//
//  EditFavorController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import SnapKit
import Commons

class EditFavorController: OverlayViewController {
    var favor: Favor?
    var editResultAction: ((Bool) -> Void)?

    init(_ favor: Favor? = nil) {
        self.favor = favor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissWhenTouchOutside = false
        setupView()
    }

    private func setupView() {

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(titleField)
        titleField.snp.makeConstraints { make in
            make.leading.equalTo(32)
            make.trailing.equalTo(-32)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(28)
        }

        contentView.addSubview(authorField)
        authorField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(titleField)
            make.top.equalTo(titleField.snp.bottom).offset(12)
        }

        contentView.addSubview(linkField)
        linkField.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(titleField)
            make.top.equalTo(authorField.snp.bottom).offset(12)
        }

        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(titleField)
            make.top.equalTo(linkField.snp.bottom).offset(24)
            make.height.equalTo(44)
            make.bottom.equalTo(-16)
        }

        contentView.addSubview(commitButton)
        commitButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(24)
            make.trailing.equalTo(titleField)
            make.top.height.width.equalTo(cancelButton)
        }
    }

    @objc private func onButtonClick(_ sender: ThemeButton) {
        if sender.tag == 1 {
            dismiss(animated: true)
        } else {
            guard let title = titleField.text else {
                HUD.tip(text: "请输入标题")
                return
            }
            guard let link = linkField.text else {
                HUD.tip(text: "请输入链接")
                return
            }
            let author = authorField.text ?? ""

            favor != nil ? modify(id: favor!.id, title: title, author: author, link: link) : add(title: title, author: author, link: link)
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .font(ofSize: 16, type: .semibold)
        label.text = favor == nil ? "编辑收藏" : "收藏文章"
        label.textColor = Colors.textPrimary
        return label
    }()

    private lazy var titleField: UITextField = {
        let field = UITextField()
        field.rightViewMode = .never
        field.borderStyle = .roundedRect
        field.font = .font(ofSize: 14)
        field.placeholder = "文章标题"
        field.text = favor?.displayTitle ?? ""
        return field
    }()

    private lazy var linkField: UITextField = {
        let field = UITextField()
        field.rightViewMode = .never
        field.borderStyle = .roundedRect
        field.font = .font(ofSize: 14)
        field.placeholder = "文章链接"
        field.text = favor?.link ?? "https://"
        return field
    }()

    private lazy var authorField: UITextField = {
        let field = UITextField()
        field.rightViewMode = .never
        field.borderStyle = .roundedRect
        field.font = .font(ofSize: 14)
        field.placeholder = "文章作者"
        field.text = favor?.author ?? ""
        return field
    }()

    private lazy var commitButton: ThemeButton = {
        let button = ThemeButton("保存", 16, 22, type: .yellowBlack)
        button.tag = 2
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: ThemeButton = {
        let button = ThemeButton("取消", 16, 22, type: .whiteBlue)
        button.tag = 1
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return button
    }()
}

extension EditFavorController: AutoDisposed {
    private func modify(id: Int, title: String, author: String, link: String) {
        ApiHelper.favor(id, title: title, author: author, link: link).subscribe { [weak self] result in
            guard let `self` = self else { return }
            if result {
                self.dismiss(animated: true)
                self.editResultAction?(true)
            } else {
                HUD.tip(text: "编辑收藏失败")
            }
        }.disposed(by: disposeBag)
    }

    private func add(title: String, author: String, link: String) {
        ApiHelper.favor(title: title, author: author, link: link).subscribe { [weak self] result in
            guard let `self` = self else { return }
            if result {
                self.dismiss(animated: true)
                self.editResultAction?(true)
            } else {
                HUD.tip(text: "添加收藏失败")
            }
        }.disposed(by: disposeBag)
    }
}
