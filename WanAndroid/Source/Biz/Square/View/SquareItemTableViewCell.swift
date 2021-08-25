//
//  KnowledgeTableViewCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/20.
//

import UIKit
import Commons
import SnapKit

class SquareItemParentTableViewCell: UITableViewCell {
    var title: String = "" {
        didSet {
            label.text = title
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(separatorView.snp.top)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? Colors.backgroundSecondary : .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var label: UILabel = {
        let lable = UILabel()
        lable.textColor = Colors.textPrimary
        lable.font = .font(ofSize: 14)
        return lable
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}

class SquareItemChildrenTableViewCell: UITableViewCell {
    var onItemClickAction: ((SquareItem, Int) -> Void)?

    var item: SquareItem? {
        didSet {
            guard let item = item else { return }
            tagGroup.setTitles(item.childrenNames)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    private func setupView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        contentView.addSubview(tagGroup)
        tagGroup.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.bottom.equalTo(separatorView.snp.top)
            make.width.equalTo(ScreenWidth - 120)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tagGroup: TagGroup = {
        let group = TagGroup()
        group.appearance.itemNormalTextColor = Colors.textSecondary
        group.appearance.itemNormalBorderColor = Colors.orange_100
        group.appearance.itemNormalBorderWidth = 1
        group.delegate = self
        return group
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
}

extension SquareItemChildrenTableViewCell: TagGroupDelegate {
    func tagGroup(_ group: TagGroup, didSelectedItemAt index: Int) {
        guard let item = item else { return }
        onItemClickAction?(item, index)
    }
}
