//
//  SettingItemCell.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/18.
//

import Eureka
import Commons
import SnapKit

class SettingItemLabelCell: Cell<String>, CellType {

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()

        tintAdjustmentMode = .automatic
        selectionStyle = .blue
        self.height = { 48 }
    }

    override func didSelect() {
        super.didSelect()
        row.deselect()
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = Colors.backgroundPrimary

        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(horizontalPadding)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            make.trailing.equalTo(arrow.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textPrimary
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    let tipLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 12)
        label.textColor = Colors.textHint
        return label
    }()

    let arrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .iconArrowRight
        return imageView
    }()
}

final class SettingItemLabelRow: Row<SettingItemLabelCell>, RowType {

    var titleText: String? {
        get { cell.titleLabel.text }
        set { cell.titleLabel.text = newValue }
    }

    var tipText: String? {
        get { cell.tipLabel.text }
        set { cell.tipLabel.text = newValue }
    }

    var iconImage: UIImage? {
        get { cell.icon.image }
        set { cell.icon.image = newValue }
    }

    var isArrowHidden: Bool {
        get { cell.arrow.isHidden }
        set { cell.arrow.isHidden = newValue }
    }

    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SettingItemLabelCell>()
    }
}

class SettingItemSwitchCell: Cell<Bool>, CellType {

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        switcher.removeTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    override func setup() {
        super.setup()
        selectionStyle = .none
        self.height = { 48 }
        switcher.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    override func update() {
        super.update()
        switcher.isOn = row.value ?? false
        switcher.isEnabled = !row.isDisabled
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = Colors.backgroundPrimary

        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(horizontalPadding)
        }

        contentView.addSubview(switcher)
        switcher.snp.makeConstraints { make in
            make.trailing.equalTo(-horizontalPadding)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(switcher.snp.leading)
            make.centerY.equalToSuperview()
        }
    }

    @objc private func valueChanged() {
        row.value = switcher.isOn
    }

    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(ofSize: 16)
        label.textColor = Colors.textPrimary
        return label
    }()

    let switcher: UISwitch = {
        let switcher = UISwitch()
        return switcher
    }()
}

final class SettingItemSwitchRow: Row<SettingItemSwitchCell>, RowType {

    var titleText: String? {
        get { cell.titleLabel.text }
        set { cell.titleLabel.text = newValue }
    }

    var iconImage: UIImage? {
        get { cell.icon.image }
        set { cell.icon.image = newValue }
    }

    var isOn: Bool {
        get { cell.row.value ?? false }
        set { cell.row.value = newValue }
    }

    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SettingItemSwitchCell>()
        displayValueFor = nil
    }
}

@available(iOS 12.0, *)
class SettingThemeSelectorCell: Cell<UIUserInterfaceStyle>, CellType {

    var items: [(UIUserInterfaceStyle, String)] = [
        (UIUserInterfaceStyle.light, "普通模式"),
        (UIUserInterfaceStyle.dark, "深色模式")
    ]

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        selectionStyle = .none
        self.height = { CGFloat(48) * self.items.count }

        items.forEach { item in
            let itemView = ItemView()
            itemView.tag = item.0.rawValue
            itemView.titleLabel.text = item.1
            itemView.icon.isHidden = item.0 == row.value ?? .light
            itemView.addTarget(self, action: #selector(onItemClick(_:)), for: .touchUpInside)

            self.stackView.addArrangedSubview(itemView)
        }
    }

    override func update() {
        super.update()

        let style = row.value ?? .light
        for v in stackView.arrangedSubviews where v is ItemView {
            let itemView = v as! ItemView
            itemView.icon.isHidden = itemView.tag != style.rawValue
        }
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = Colors.backgroundPrimary

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func onItemClick(_ sender: ItemView) {
        row.value = UIUserInterfaceStyle(rawValue: sender.tag) ?? .light
        update()
    }

    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()

    class ItemView: UIControl {

        var isIconHidden: Bool {
            get { icon.isHidden }
            set { icon.isHidden = newValue }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(horizontalPadding)
                make.centerY.equalToSuperview()
            }

            addSubview(icon)
            icon.snp.makeConstraints { make in
                make.trailing.equalTo(-horizontalPadding)
                make.centerY.equalToSuperview()
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let icon: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .iconMineSelected
            imageView.isHidden = true
            return imageView
        }()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .font(ofSize: 16)
            label.textColor = Colors.textPrimary
            return label
        }()
    }
}

@available(iOS 12.0, *)
final class SettingThemeSelectorRow: Row<SettingThemeSelectorCell>, RowType {

    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SettingThemeSelectorCell>()
        displayValueFor = nil
    }
}
