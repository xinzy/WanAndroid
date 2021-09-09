//
//  ActionSheet.swift
//  Alamofire
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import SnapKit

fileprivate let defaultItemHeight: CGFloat = 48
public typealias ActionSheetHandler = () -> Void

public struct ActionSheetItem {
    var title: String = ""
    var textColor: UIColor = Colors.textPrimary
    var font: UIFont = .font(ofSize: 16)
    var height: CGFloat = defaultItemHeight
    var handler: ActionSheetHandler?
}

open class ActionSheet {
    private let actionSheetController: ActionSheetController = ActionSheetController()

    public var showDefaultCancelButton: Bool {
        get { actionSheetController.showDefaultCancelButton }
        set { actionSheetController.showDefaultCancelButton = newValue }
    }
    public var panToDismiss: Bool {
        get { actionSheetController.panToDismiss }
        set { actionSheetController.panToDismiss = newValue }
    }
    public var defaultCancelText: String {
        get { actionSheetController.defaultCancelItem.title }
        set { actionSheetController.defaultCancelItem.title = newValue }
    }
    public var defaultCacelTextColor: UIColor {
        get { actionSheetController.defaultCancelItem.textColor }
        set { actionSheetController.defaultCancelItem.textColor = newValue }
    }
    public var defaultCacelTextFont: UIFont {
        get { actionSheetController.defaultCancelItem.font }
        set { actionSheetController.defaultCancelItem.font = newValue }
    }

    public var titleText: String {
        get { actionSheetController.headerView.title }
        set { actionSheetController.headerView.title = newValue }
    }
    public var titleView: UIView? {
        get { actionSheetController.headerView.titleView }
        set { actionSheetController.headerView.titleView = newValue }
    }
    private var containerView: UIView? {
        get { actionSheetController.containerView }
        set { actionSheetController.containerView = newValue }
    }

    public init() { }

    public func addLeftButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        actionSheetController.headerView.addLeftButton(title, fontSize: fontSize, titleColor: titleColor, handler: handler)
    }

    public func addRightButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        actionSheetController.headerView.addRightButton(title, fontSize: fontSize, titleColor: titleColor, handler: handler)
    }

    public func setContentView(_ contentView: UIView, _ height: CGFloat) {
        showDefaultCancelButton = false
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        self.containerView = contentView
    }

    public func addActionItem(_ title: String, textColor: UIColor = Colors.textPrimary, font: UIFont = .font(ofSize: 16),
                              height: CGFloat = 48, handler: ActionSheetHandler? = nil) {
        actionSheetController.actionSheetItems.append(ActionSheetItem(title: title, textColor: textColor, font: font, height: height, handler: handler))
    }

    public func show(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        actionSheetController.present(from: controller, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        actionSheetController.dismiss(animated: animated, completion: completion)
    }
}

public class ActionSheetHeader: UIView {

    private var leftHandler: ActionSheetHandler?
    private var rightHandler: ActionSheetHandler?

    fileprivate weak var actionSheetController: ActionSheetController?

    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    public var titleView: UIView? {
        didSet {
            title = ""
            titleLabel.removeAllSubviews()
            guard let v = titleView else { return }
            titleLabel.addSubview(v)
            v.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.backgroundPrimary
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(96)
            make.trailing.equalTo(-96)
            make.top.bottom.equalToSuperview()
        }

        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    public func addLeftButton(_ title: String = "", image: UIImage? = nil, fontSize: CGFloat = 13, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        leftHandler = handler

        leftButton.titleFont = .font(ofSize: fontSize)
        leftButton.setTitleColor(titleColor, for: .normal)
        leftButton.setTitle(title, for: .normal)
        leftButton.setImage(image, for: .normal)

        if leftButton.superview == nil {
            addSubview(leftButton)
            leftButton.snp.makeConstraints { make in
                make.leading.equalTo(horizontalPadding)
                make.centerY.equalToSuperview()
            }
        }
    }

    public func addRightButton(_ title: String = "", image: UIImage? = nil, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        rightHandler = handler

        rightButton.titleFont = .font(ofSize: fontSize)
        rightButton.setTitleColor(titleColor, for: .normal)
        rightButton.setTitle(title, for: .normal)
        rightButton.setImage(image, for: .normal)

        if rightButton.superview == nil {
            addSubview(rightButton)
            rightButton.snp.makeConstraints { make in
                make.trailing.equalTo(-horizontalPadding)
                make.centerY.equalToSuperview()
            }
        }
    }

    @objc private func onButtonClick(_ sender: UIButton) {
        actionSheetController?.dismiss(animated: true)
        if sender.tag == 1 {
            leftHandler?()
        } else if sender.tag == 2 {
            rightHandler?()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public lazy var titleLabel: UILabel = UILabel().then { label in
        label.textColor = Colors.textPrimary
        label.font = .font(ofSize: 16, type: .semibold)
        label.textAlignment = .center
    }

    private lazy var leftButton: UIButton = {
        let btn = UIButton()
        btn.tag = 1
        btn.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var rightButton: UIButton = {
        let btn = UIButton()
        btn.tag = 2
        btn.addTarget(self, action: #selector(onButtonClick(_:)), for: .touchUpInside)
        return btn
    }()

    private let dividerView = UIView().then { $0.backgroundColor = Colors.separator }
}

fileprivate class ActionSheetItemView: UIView {
    private let actionSheetItem: ActionSheetItem
    private let showDivider: Bool

    fileprivate weak var actionSheetController: ActionSheetController?

    init(item: ActionSheetItem, showDivider: Bool = true) {
        self.actionSheetItem = item
        self.showDivider = showDivider
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: item.height))

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Colors.backgroundPrimary
        addSubview(contentButton)

        if showDivider {
            dividerView.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
            addSubview(dividerView)
        }
        contentButton.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
    }

    @objc private func onClick(_ sender: UIControl) {
        actionSheetItem.handler?()
        actionSheetController?.dismiss(animated: true)
    }

    private lazy var contentButton: UIButton = {
        let button = UIButton(frame: self.bounds)
        button.setTitleColor(actionSheetItem.textColor, for: .normal)
        button.setTitle(actionSheetItem.title, for: .normal)
        button.titleFont = actionSheetItem.font
        button.setBackgroundColor(.clear, for: .normal)
        button.setBackgroundColor(Colors.separator, for: .highlighted)
        return button
    }()
    
    private let dividerView: UIView = UIView().then { $0.backgroundColor = Colors.separator }
}

public class ActionSheetController: SlideViewController {
    public override var controllerSize: CGFloat {
        var height: CGFloat = headerView.height

        if let contentView = containerView {
            height += contentView.height
        } else {
            actionSheetItems.forEach { height += $0.height }
            if showDefaultCancelButton {
                height += 8 + defaultItemHeight
            }
        }
        height += safeAreaBottom

        return height
    }

    public lazy var headerView: ActionSheetHeader = {
        let header = ActionSheetHeader(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 52))
        header.actionSheetController = self
        return header
    }()
    public var actionSheetItems = [ActionSheetItem]()
    public var containerView: UIView?
    public lazy var defaultCancelItem: ActionSheetItem = ActionSheetItem(title: "取消", textColor: Colors.red_600)
    public var showDefaultCancelButton: Bool = true

    public override func viewDidLoad() {
        super.viewDidLoad()

        contentView.backgroundColor = Colors.backgroundPrimary
        dismissWhenTouchOutside = true
        setupView()
    }

    private func setupView() {
        contentView.addSubview(headerView)

        if let contentView = containerView {
            let contentFrame = contentView.frame
            contentView.frame = CGRect(x: 0, y: headerView.height, width: contentFrame.width, height: contentFrame.height)
            contentView.addSubview(contentView)
        } else {
            contentView.addSubview(sheetView)

            var y: CGFloat = 0
            actionSheetItems.forEach { item in
                let itemView = ActionSheetItemView(item: item)
                itemView.actionSheetController = self
                itemView.frame.origin.y = y
                sheetView.addSubview(itemView)

                y += item.height
            }

            if showDefaultCancelButton {
                let separatorView = UIView(frame: CGRect(x: 0, y: y, width: ScreenWidth, height: 8))
                separatorView.backgroundColor = Colors.backgroundSecondary
                sheetView.addSubview(separatorView)

                let cancelView = ActionSheetItemView(item: defaultCancelItem, showDivider: false)
                cancelView.frame.origin.y = y + 8
                cancelView.actionSheetController = self
                sheetView.addSubview(cancelView)
            }
        }
    }

    private var contentHeight: CGFloat {
        var height: CGFloat = 0
        actionSheetItems.forEach { height += $0.height }
        if showDefaultCancelButton {
            height += 8 + defaultItemHeight
        }
        return height
    }

    private lazy var sheetView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: headerView.height, width: ScreenWidth, height: contentHeight))
        return view
    }()
}
