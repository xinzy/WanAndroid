//
//  MediaSelectionBottomBar.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import UIKit
import SnapKit

class MediaSelectionBottomBar: UIView {
    enum ActionType {
        case preview, origin(Bool), ok
    }

    var actionBlock: ((ActionType) -> Void)?

    var previewButtonText: String = "预览" {
        didSet { previewButton.setTitle(previewButtonText, for: .normal) }
    }
    var originButtonText: String = "原图" {
        didSet { originButton.setTitle(originButtonText, for: .normal) }
    }
    var okButtonText: String = "确定" {
        didSet { okButton.setTitle(okButtonText, for: .normal) }
    }

    var isOrigin: Bool {
        get { originButton.isSelected }
        set { originButton.isSelected = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(previewButton)
        previewButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(horizontalPadding)
        }

        addSubview(originButton)
        originButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
        }
    }

    @objc private func onButtonClick(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            actionBlock?(.preview)
        case 2:
            sender.isSelected.toggle()
            actionBlock?(.origin(sender.isSelected))
        case 4:
            actionBlock?(.ok)
        default:
            break
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var previewButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.titleFont = .font(ofSize: 16)
        button.setTitleColor(Colors.textPrimary, for: .normal)
        button.setTitle(previewButtonText, for: .normal)
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var originButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.titleFont = .font(ofSize: 16)
        button.setImagePosition(.leading, spacing: 4)
        button.setTitleColor(Colors.textPrimary, for: .normal)
        button.setTitle(originButtonText, for: .normal)
        button.setImage(getImage(named: "ic_checkbox"), for: .normal)
        button.setImage(getImage(named: "ic_checkbox_checked"), for: .selected)
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var okButton: StateButton = {
        let button = StateButton()
        button.tag = 4
        button.titleFont = .font(ofSize: 16)
        button.cornerRadius(16)
        button.isEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.setTitleColor(Colors.white_card, for: .normal)
        button.setTitleColor(Colors.white_card.withAlphaComponent(0.6), for: .disabled)
        button.setTitle(okButtonText, for: .normal)
        button.normalColor = Colors.brand_600
        button.disableColor = Colors.brand_100
        button.highlightColor = Colors.brand_500
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}
