//
//  RankCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/20.
//

import UIKit
import Commons
import SnapKit

class RankCell: UITableViewCell {
    var score: Score? {
        didSet {
            guard let item = score else { return }
            titleLabel.text = item.username
            scoreLabel.text = "\(item.coinCount)"

            if let icon = UIImage(named: "icon_rank_\(item.rank)") {
                rankIcon.image = icon
                rankIcon.isHidden = false
                rankLabel.isHidden = true
            } else {
                rankIcon.isHidden = true
                rankLabel.isHidden = false
                rankLabel.text = item.rank > 99 ? "99+" : "\(item.rank)"
            }
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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(rankIcon)
        rankIcon.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(rankLabel)
        rankLabel.snp.makeConstraints { make in
            make.edges.equalTo(rankIcon)
        }

        contentView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankIcon.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(scoreLabel.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private let rankIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.backgroundColor = Colors.green_100

        label.font = .font(ofSize: 12)
        label.textAlignment = .center
        label.textColor = Colors.orange_600
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 14)
        label.textColor = Colors.brand_600
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textPrimary
        return label
    }()

    private let divider: UIView = UIView().then { $0.backgroundColor = Colors.separator }
}
