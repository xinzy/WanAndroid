//
//  FavorCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import Commons
import SnapKit
import Kingfisher

class FavorCell: UITableViewCell {

    var favor: Favor = Favor() {
        didSet {
            titleLabel.text = favor.displayTitle
            timeLabel.text = favor.niceDate
            if favor.desc.isNotEmpty {
                descLabel.text = favor.desc.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    .replacingOccurrences(of: "\r\n\r\n", with: "\r\n")
                timeLabel.snp.remakeConstraints { make in
                    make.leading.bottom.equalToSuperview()
                    make.top.equalTo(descLabel.snp.bottom).offset(8)
                }
            } else {
                descLabel.text = ""
                timeLabel.snp.remakeConstraints { make in
                    make.leading.bottom.equalToSuperview()
                    make.top.equalTo(descLabel.snp.bottom).offset(0)
                }
            }

            if favor.envelopePic.isEmpty {
                image.isHidden = true
                image.image = nil
                mainView.snp.remakeConstraints { make in
                    make.leading.equalTo(horizontalPadding)
                    make.trailing.equalTo(-horizontalPadding)
                    make.top.equalTo(12)
                    make.bottom.equalTo(-12)
                }
            } else {
                image.isHidden = false
                image.kf.setImage(with: URL(string: favor.envelopePic), placeholder: UIImage.placeholder)
                mainView.snp.remakeConstraints { make in
                    make.leading.equalTo(horizontalPadding)
                    make.trailing.equalTo(image.snp.leading).offset(-12)
                    make.top.equalTo(12)
                    make.bottom.equalTo(-12)
                }
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }

        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.equalTo(image.snp.leading).offset(-12)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }

        contentView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        mainView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        mainView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
    }

    private let mainView: UIView = UIView()

    private let titleLabel: UILabel = UILabel().then {
        $0.textColor = Colors.textPrimary
        $0.font = .font(ofSize: 16)
        $0.numberOfLines = 2
    }

    private let descLabel: UILabel = UILabel().then {
        $0.textColor = Colors.textInfo
        $0.font = .font(ofSize: 14)
        $0.numberOfLines = 4
    }

    private let timeLabel: UILabel = UILabel().then {
        $0.textColor = Colors.textHint
        $0.font = .font(ofSize: 12)
    }

    private let image: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    private let divider: UIView = UIView().then { $0.backgroundColor = Colors.separator }
}
