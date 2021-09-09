//
//  SearchBar.swift
//  WanAndroid
//
//  Created by Yang on 2021/9/7.
//

import UIKit
import SnapKit
import Commons

protocol SearchBarDelegate: AnyObject {
    /// 点击取消按钮
    func searchBarShouldCancel(_ searchBar: SearchBar)
}

class SearchBar: UIView {

    weak var delegate: SearchBarDelegate?

    var cancelText: String = "取消" {
        didSet { cancelButton.setTitle(cancelText, for: .normal) }
    }
    var placeholder: String = "搜索" {
        didSet { textField.placeholder = placeholder }
    }

    override var intrinsicContentSize: CGSize { UIView.layoutFittingExpandedSize }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        addSubview(textContainer)
        textContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(cancelButton.snp.leading).offset(-8)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
        }

        textContainer.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }

        textContainer.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(leftView.snp.trailing).offset(8)
            make.trailing.equalTo(-8)
            make.top.bottom.equalToSuperview()
        }
    }

    @objc private func onCancelClick() {
        delegate?.searchBarShouldCancel(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var textContainer: UIView = {
        let view = UIView()
        view.cornerRadius(16, Colors.textHint, 1)
        view.backgroundColor = Colors.backgroundPrimary
        return view
    }()

    private lazy var leftView: UIImageView = {
        let leftView = UIImageView(frame: CGRect(x: 8, y: 0, width: 16, height: 16))
        leftView.contentMode = .scaleAspectFill
        leftView.image = .iconSearch
        return leftView
    }()

    private lazy var textField: UITextField = {
        let field = UITextField()
        field.textColor = Colors.textPrimary
        field.tintColor = Colors.textPrimary
        field.font = .font(ofSize: 16)
        field.placeholder = placeholder
        field.borderStyle = .none
        field.leftViewMode = .never
        field.clearButtonMode = .whileEditing
        field.setContentHuggingPriority(priority: 249, for: .horizontal)
        field.returnKeyType = .search
        field.enablesReturnKeyAutomatically = true
        return field
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(cancelText, for: .normal)
        button.setTitleColor(Colors.blue_600, for: .normal)
        button.setTitleColor(Colors.separator, for: .disabled)
        button.titleFont = .font(ofSize: 16)
        button.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        return button
    }()
}

extension SearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
