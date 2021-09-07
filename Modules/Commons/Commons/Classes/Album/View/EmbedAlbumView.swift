//
//  EmbedAlbumListView.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import UIKit

/// 内置相册选择
class EmbedAlbumListView: UIView, UITableViewDelegate, UITableViewDataSource{
    private static let cellHeight: CGFloat = 48

    var data: [Album] = [] {
        didSet {
            tableView.reloadData()
            let viewHeight = Self.cellHeight * ((data.count > 6) ? 6 : data.count)
            tableView.snp.updateConstraints { make in
                make.height.equalTo(viewHeight)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(128)
        }
    }

    func show() {
        backgroundView.alpha = 0
        tableView.transform = CGAffineTransform(translationX: 0, y: -height)
        isHidden = false
        UIView.animate(withDuration: animationDuration) {
            self.backgroundView.alpha = 1
            self.tableView.transform = .identity
        }
    }

    func hide() {
        UIView.animate(withDuration: animationDuration) {
            self.backgroundView.alpha = 0
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.height)
        } completion: { _ in
            self.isHidden = true
        }
    }

    @objc private func onDismissAction() {
        hide()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = data[indexPath.row]
        let cell: AlbumCell = tableView.dequeueReusableCell(indexPath)
        cell.album = album
        return cell
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.backgroundPrimary
        tableView.rowHeight = Self.cellHeight
        tableView.separatorStyle = .none
        tableView.register(AlbumCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var backgroundView: UIControl = {
        let control = UIControl()
        control.backgroundColor = .black.withAlphaComponent(0.75)
        control.addTarget(self, action: #selector(onDismissAction), for: .touchUpInside)
        return control
    }()
}

fileprivate class AlbumCell: UITableViewCell {

    var album: Album? {
        didSet {
            guard let item = album else { return }
            titleLabel.text = item.title
            countLabel.text = "(\(item.count))"
//            albumImageView.image = item.cover.
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

        contentView.addSubview(albumImageView)
        albumImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(64)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView).offset(8)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
        }
    }

    private let albumImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textPrimary
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textSecondary
        return label
    }()

    private let selectedImageView: UIImageView = {
        let view = UIImageView()
        view.image = getImage(named: "ic_tick")
        return view
    }()
}

/// 内置相册title
class EmbedAlbumTitleView: UIControl {
    var selectedChangedAction: ((Bool) -> Void)?

    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @objc private func onClick() {
        isSelected.toggle()
        selectedChangedAction?(isSelected)
        UIView.animate(withDuration: animationDuration) {
            self.arrowImageView.transform = self.isSelected ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }

    private func setupView() {
        backgroundColor = Colors.backgroundSecondary
        addTarget(self, action: #selector(onClick), for: .touchUpInside)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.centerY.equalToSuperview()
        }

        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.trailing.equalTo(-8)
            make.width.height.equalTo(20)
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
        cornerRadius(16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel: UILabel = UILabel().then { label in
        label.textColor = Colors.textPrimary
        label.font = .font(ofSize: 16)
    }

    private let arrowImageView: UIImageView = UIImageView().then { imageView in
        imageView.image = getImage(named: "ic_arrow_down")
    }
}
