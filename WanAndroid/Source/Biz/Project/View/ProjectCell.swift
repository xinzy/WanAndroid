//
//  ProjectCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/19.
//

import Commons
import UIKit
import Kingfisher

class ProjectCell: UITableViewCell {

    var article: Article? {
        didSet {
            guard let item = article else { return }
            authorLabel.text = item.displayAuthor
            titleLabel.text = item.displayTitle
            descLabel.text = item.displayDesc
            dateLabel.text = item.niceDate
            picImageView.kf.setImage(with: URL(string: item.envelopePic), placeholder: UIImage.placeholder)

            let h = item.displayTitle.height(sizeOfSystem: 16, viewWidth: ScreenWidth - horizontalPadding * 3 - 120)
            titleLabel.snp.updateConstraints { make in
                make.height.equalTo(h > 40 ? 40 : h + 1)
            }
        }
    }

    var titleTapAction: ((Article) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupView()
    }

    private func setupView() {
        contentView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.top.equalTo(verticalPadding)
            make.leading.equalTo(horizontalPadding)
        }

        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImage.snp.trailing).offset(6)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }

        contentView.addSubview(picImageView)
        picImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.top.equalTo(verticalPadding)
            make.bottom.equalTo(-verticalPadding)
            make.width.equalTo(120)
            make.height.equalTo(176)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImage.snp.leading)
            make.trailing.equalTo(picImageView.snp.leading).offset(-horizontalPadding)
            make.top.equalTo(avatarImage.snp.bottom).offset(8)
            make.height.equalTo(20)
        }

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImage.snp.leading)
            make.bottom.equalTo(-verticalPadding)
            make.height.equalTo(20)
        }

        contentView.addSubview(favorImage)
        favorImage.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(horizontalPadding)
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.width.height.equalTo(20)
        }

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(dateLabel.snp.top).offset(-8)
        }

        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        view.image = .iconAvatar
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.textHint
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.textPrimary
        label.addTapGesture(self, #selector(titleTap))
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Colors.textHint
        return label
    }()

    private lazy var picImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.textHint
        return label
    }()

    private lazy var favorImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .iconFavor
        return view
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}

extension ProjectCell {
    @objc private func titleTap() {
        guard let item = article else { return }
        titleTapAction?(item)
    }
}
