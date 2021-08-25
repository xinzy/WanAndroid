//
//  ScoreHistoryCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import Commons
import SnapKit

class ScoreHistoryCell: UITableViewCell {

    var history: ScoreHistory? {
        didSet {
            guard let item = history else { return }
            titleLabel.text = item.reason
            descLabel.text = item.desc
            scoreLabel.text = "\(item.coinCount)"
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.top.equalTo(12)
            make.trailing.lessThanOrEqualTo(scoreLabel.snp.leading).offset(-12)
        }

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.trailing.lessThanOrEqualTo(scoreLabel.snp.leading).offset(-12)
            make.bottom.equalTo(-12)
        }

        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textPrimary
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 12)
        label.textColor = Colors.textInfo
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 14)
        label.textColor = Colors.brand_600
        return label
    }()

    private let divider: UIView = UIView().then { $0.backgroundColor = Colors.separator }
}
