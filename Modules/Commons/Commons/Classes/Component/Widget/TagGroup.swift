//
//  TagGroup.swift
//  Alamofire
//
//  Created by Yang on 2021/7/23.
//

import UIKit

public protocol TagGroupDelegate: AnyObject {
    func tagGroup(_ group: TagGroup, didSelectedItemAt index: Int)

    func tagGroup(_ group: TagGroup, itemWidthAt index: Int) -> CGFloat
}

public extension TagGroupDelegate {
    func tagGroup(_ group: TagGroup, itemWidthAt index: Int) -> CGFloat {
        -1
    }
}

public class TagGroup: UIView {

    public enum SelectionStyle {
        case single
        case multiple
        case none
    }

    public enum SizeMode {
        case fix(CGFloat)
        case auto
    }

    public struct Appearance {
        public var horizontalSpacing: CGFloat = 8
        public var verticalSpacing: CGFloat = 6
        public var horizontalPadding: CGFloat = 6
        public var verticalPadding: CGFloat = 6

        public var itemHeight: CGFloat = 20
        public var itemHorizontalPadding: CGFloat = 6
        public var itemRadius: SizeMode = .auto

        public var itemNormalFont: UIFont = .systemFont(ofSize: 14)
        public var itemSelectedFont: UIFont = .systemFont(ofSize: 14)
        public var itemNormalTextColor: UIColor = .black
        public var itemSelectedTextColor: UIColor = .red

        public var itemNormalBackgroundColor: UIColor = .clear
        public var itemSelectedBackgroundColor: UIColor = .clear

        public var itemNormalBorderWidth: CGFloat = 1
        public var itemSelectedBorderWidth: CGFloat = 1

        public var itemNormalBorderColor: UIColor = .clear
        public var itemSelectedBorderColor: UIColor = .clear
    }

    public weak var delegate: TagGroupDelegate?

    public var selectionStyle: SelectionStyle = .none {
        didSet {
            selectedIndexes.removeAll()
            for child in subviews where child is TagItemView {
                (child as! TagItemView).isSelected = false
            }
        }
    }
    public var appearance: Appearance = Appearance() {
        didSet {
            createItems()
        }
    }

    public var selectedIndexes: Set<Int> = [] {
        didSet {
            switch selectionStyle {
            case .single:
                if selectedIndexes.count > 1 {
                    selectedIndexes.removeAll()
                }
                fallthrough
            case .multiple:
                for child in subviews where child is TagItemView {
                    (child as! TagItemView).isSelected = selectedIndexes.contains(child.tag)
                }
            case .none:
                selectedIndexes.removeAll()
            }
        }
    }

    public private(set) var titles: [String] = []

    public override var intrinsicContentSize: CGSize {
        if width == 0 {
            return CGSize(width: Self.noIntrinsicMetric, height: appearance.verticalPadding * 2)
        } else if subviews.isEmpty {
            return CGSize(width: Self.noIntrinsicMetric, height: appearance.verticalPadding * 2)
        }
        var x: CGFloat = appearance.horizontalPadding
        var height: CGFloat = appearance.verticalPadding
        var newLine = true

        subviews.forEach { child in
            layoutItem(child: child, x: &x, top: &height, newLine: &newLine, false)
        }
        height += appearance.itemHeight + appearance.verticalPadding

        return CGSize(width: Self.noIntrinsicMetric, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard width > 0 else { return }

        var x: CGFloat = appearance.horizontalPadding
        var top: CGFloat = appearance.verticalPadding
        var newLine = true

        subviews.forEach { child in
            layoutItem(child: child, x: &x, top: &top, newLine: &newLine)
        }
        if intrinsicContentSize.height != bounds.height {
            invalidateIntrinsicContentSize()
        }
    }

    private func layoutItem(child: UIView, x: inout CGFloat, top: inout CGFloat, newLine: inout Bool, _ needLayout: Bool = true) {
        // 当前行放不下
        if child.width + x > width - appearance.horizontalPadding {
            if newLine { // 如果当前行是新行
                if child.width > width - appearance.horizontalPadding * 2 { // 一行都放不下一个item，则item 宽度适配
                    if needLayout {
                        child.frame = CGRect(x: x, y: top, width: width - appearance.horizontalPadding * 2, height: child.height)
                    }
                    x += appearance.horizontalSpacing
                    top += child.height + appearance.verticalSpacing
                } else {
                    if needLayout {
                        child.frame = CGRect(x: x, y: top, width: child.width, height: child.height)
                    }
                    x += child.width + appearance.horizontalSpacing
                    newLine = false
                }
            } else {
                newLine = true
                x = appearance.horizontalPadding
                top += appearance.itemHeight + appearance.verticalSpacing
                layoutItem(child: child, x: &x, top: &top, newLine: &newLine, needLayout)
            }
        } else {
            if needLayout {
                child.frame = CGRect(x: x, y: top, width: child.width, height: child.height)
            }
            x += child.width + appearance.horizontalSpacing
            newLine = false
        }
    }

    @objc private func onItemClick(_ sender: TagItemView) {
        switch selectionStyle {
        case .single:
            if let selectedIndex = selectedIndexes.popFirst() {
                if selectedIndex == sender.tag {    // 当前ItemView是选中态
                    sender.isSelected = false
                    selectedIndexes.removeAll()
                } else {
                    selectedIndexes.removeAll()
                    if let child = subviews.first(where: { $0.tag == selectedIndex }) as? TagItemView {
                        child.isSelected = false
                    }
                    sender.isSelected = true
                    selectedIndexes.insert(sender.tag)
                }
            } else {
                sender.isSelected = true
                selectedIndexes.insert(sender.tag)
            }
        case .multiple:
            if selectedIndexes.contains(sender.tag) {
                selectedIndexes.remove(sender.tag)
                sender.isSelected = false
            } else {
                selectedIndexes.insert(sender.tag)
                sender.isSelected = true
            }
        case .none: break
        }
        delegate?.tagGroup(self, didSelectedItemAt: sender.tag)
    }
}

public extension TagGroup {

    func setTitles(_ titles: [String]) {
        self.titles = titles
        createItems()
    }

    func remove(title: String) {
        guard let index = titles.firstIndex(of: title) else { return }
        remove(at: index)
    }

    func remove(at index: Int) {
        titles.remove(at: index)
        for child in subviews where child.tag >= index {
            if child.tag == index {
                child.removeFromSuperview()
            } else {
                child.tag = child.tag - 1
            }
        }

        layoutIfNeeded()
    }

    func append(_ title: String) {
        titles.append(title)
        let child = createItem(title: title, tag: subviews.count)
        addSubview(child)

        layoutIfNeeded()
    }

    private func createItems() {
        removeAllSubviews()

        titles.forEach { index, item in
            let child = createItem(title: item, tag: index)
            addSubview(child)
        }
        layoutIfNeeded()
    }

    private func createItem(title: String, tag: Int) -> TagItemView {
        let child = TagItemView(appearance: appearance, text: title)
        child.tag = tag
        child.addTarget(self, action: #selector(onItemClick(_:)), for: .touchUpInside)
        return child
    }
}

private class TagItemView: UIControl {
    var appearance: TagGroup.Appearance
    var text: String

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? appearance.itemSelectedBackgroundColor : appearance.itemNormalBackgroundColor
            layer.borderWidth = isSelected ? appearance.itemSelectedBorderWidth : appearance.itemNormalBorderWidth
            layer.borderColor = isSelected ? appearance.itemSelectedBorderColor.cgColor : appearance.itemNormalBorderColor.cgColor

            label.textColor = isSelected ? appearance.itemSelectedTextColor : appearance.itemNormalTextColor
            label.font = isSelected ? appearance.itemSelectedFont : appearance.itemNormalFont
        }
    }

    init(appearance: TagGroup.Appearance, text: String) {
        self.text = text
        self.appearance = appearance

        let itemWidth = ceil(text.width(appearance.itemNormalFont))
        let frame = CGRect(x: 0, y: 0, width: itemWidth + appearance.itemHorizontalPadding * 2, height: appearance.itemHeight)
        super.init(frame: frame)

        setup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layer.borderColor = isSelected ? appearance.itemSelectedBorderColor.cgColor : appearance.itemNormalBorderColor.cgColor
    }

    private func setup() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.itemHorizontalPadding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.itemHorizontalPadding),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        backgroundColor = appearance.itemNormalBackgroundColor
        switch appearance.itemRadius {
        case .auto:
            cornerRadius(appearance.itemHeight / 2, appearance.itemNormalBorderColor, appearance.itemNormalBorderWidth)
        case let .fix(radius):
            cornerRadius(radius, appearance.itemNormalBorderColor, appearance.itemNormalBorderWidth)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = appearance.itemNormalFont
        label.textColor = appearance.itemNormalTextColor
        label.text = text
        return label
    }()
}
