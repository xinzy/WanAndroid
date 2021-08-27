//
//  ArticleCell.swift
//  Wan
//
//  Created by Yang on 2021/2/7.
//

import UIKit
import Commons
import SnapKit

class ArticleCell: UITableViewCell {

    var article: Article? = nil {
        didSet {
            guard let item = article else { return }
            authorLabel.text = item.displayAuthor
            titleLabel.text = item.displayTitle
            dateLabel.text = item.niceShareDate
            chapterLabel.text = item.category

            favorButton.isSelected = item.collect
            tagCollectionView.reloadData()

            if item.top {
                topIcon.isHidden = false
                topIcon.snp.updateConstraints { make in
                    make.leading.equalTo(authorLabel.snp.trailing).offset(4)
                }
            } else {
                topIcon.isHidden = true
            }

            if item.fresh {
                newIcon.isHidden = false
                newIcon.snp.updateConstraints { make in
                    make.leading.equalTo(authorLabel.snp.trailing).offset(item.top ? 20 : 40)
                }
            } else {
                newIcon.isHidden = true
            }
        }
    }
    var collectingActicle: Article?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupUI()
    }

    private func setupUI() {
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

        contentView.addSubview(topIcon)
        topIcon.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.centerY.equalTo(avatarImage.snp.centerY)
            make.leading.equalTo(authorLabel.snp.trailing).offset(4)
        }

        contentView.addSubview(newIcon)
        newIcon.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.centerY.equalTo(avatarImage.snp.centerY)
            make.leading.equalTo(authorLabel.snp.trailing).offset(20)
        }

        contentView.addSubview(chapterLabel)
        chapterLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-horizontalPadding)
            make.centerY.equalTo(avatarImage.snp.centerY)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalPadding)
            make.trailing.equalTo(-horizontalPadding)
            make.top.equalTo(avatarImage.snp.bottom).offset(12)
        }

        contentView.addSubview(favorButton)
        favorButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.trailing.equalTo(-horizontalPadding)
        }

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(favorButton.snp.leading).offset(-8)
            make.centerY.equalTo(favorButton.snp.centerY)
        }

        contentView.addSubview(tagCollectionView)
        tagCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(favorButton.snp.centerY)
            make.leading.equalTo(horizontalPadding)
            make.width.equalTo(ScreenWidth / 2)
            make.height.equalTo(24)
        }

        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(favorButton.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview()
            make.leading.equalTo(horizontalPadding)
            make.trailing.equalToSuperview()
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
        label.textColor = Colors.textSecondary
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private lazy var topIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .iconTop
        return view
    }()

    private lazy var newIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = .iconHot
        return view
    }()

    private lazy var chapterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.redorange_600
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Colors.textPrimary
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.textHint
        return label
    }()

    private lazy var favorButton: UIButton = {
        let view = UIButton()
        view.setImage(.iconFavored, for: .selected)
        view.setImage(.iconFavor, for: .normal)
        view.addTarget(self, action: #selector(doCollect), for: .touchUpInside)
        return view
    }()

    private lazy var tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 6
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.register(TagCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}

extension ArticleCell: AutoDisposed {
    @objc private func doCollect() {
        guard let item = article else { return }
        collectingActicle = item
        if item.collect {
            ApiHelper.uncollect(idInList: item.id).subscribe { [weak self] result in
                guard result, let `self` = self else { return }
                self.collectingActicle?.collect = false
                if item.id == self.collectingActicle?.id ?? 0 {
                    item.collect = false
                    self.favorButton.isSelected = false
                }
                self.collectingActicle = nil
            }.disposed(by: disposeBag)
        } else {
            ApiHelper.collect(id: item.id).subscribe { [weak self] result in
                guard result, let `self` = self else { return }
                self.collectingActicle?.collect = true
                if item.id == self.collectingActicle?.id ?? 0 {
                    item.collect = true
                    self.favorButton.isSelected = true
                }
                self.collectingActicle = nil
            }.disposed(by: disposeBag)
        }
    }
}

extension ArticleCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCell = collectionView.dequeueReusableCell(indexPath)
        if let data = article {
            let tag = data.tags[indexPath.row]
            cell.item = tag
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = article {
            return data.tags.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let data = article {
            let tag = data.tags[indexPath.row]
            return CGSize(width: tag.name.width(.systemFont(ofSize: 12)) + 16, height: 20)
        }
        return CGSize(width: 24, height: 20)
    }
}

private class TagCell: UICollectionViewCell {

    var item: Tag? = nil {
        didSet {
            guard let t = item else { return }
            tagLabel.text = t.name
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupView()
    }

    private func setupView() {
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        mainView.layer.borderColor = Colors.orange_100.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.cornerRadius(10, Colors.orange_100, 1)
        return view
    }()

    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.textHint
        return label
    }()
}
