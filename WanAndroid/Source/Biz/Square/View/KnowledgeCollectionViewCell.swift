//
//  KnowledgeCollectionViewCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/20.
//

import UIKit
import SnapKit

class KnowledgeCollectionViewCell: UICollectionViewCell {

    var title: String = "" {
        didSet {
            label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupView()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mainView.layer.borderColor = UIColor.orange_100.cgColor
    }

    private func setupView() {
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(24)
        }
        mainView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.cornerRadius(12, .orange_100, 1)
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .bluegrey_700
        return label
    }()
}

class KnowledgeCollectionSectionFooter: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(seperatorView)
        seperatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(4)
            make.bottom.equalTo(4)
            make.height.equalTo(1)
        }
    }

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .bluegrey_100
        return view
    }()
}
