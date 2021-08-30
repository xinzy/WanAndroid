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
    private var contentView: UIView? {
        get { actionSheetController.contentView }
        set { actionSheetController.contentView = newValue }
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
        self.contentView = contentView
    }

    public func addActionItem(_ title: String, textColor: UIColor = Colors.textPrimary, font: UIFont = .font(ofSize: 16),
                              height: CGFloat = 48, handler: ActionSheetHandler? = nil) {
        actionSheetController.actionSheetItems.append(ActionSheetItem(title: title, textColor: textColor, font: font, height: height, handler: handler))
    }

    public func show(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        actionSheetController.presentSheet(from: controller, animated: animated, completion: completion)
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

    public func addLeftButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        leftHandler = handler

        leftButton.titleFont = .font(ofSize: fontSize)
        leftButton.setTitleColor(titleColor, for: .normal)
        leftButton.setTitle(title, for: .normal)

        if leftButton.superview == nil {
            addSubview(leftButton)
            leftButton.snp.makeConstraints { make in
                make.leading.equalTo(horizontalPadding)
                make.centerY.equalToSuperview()
            }
        }
    }

    public func addRightButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        rightHandler = handler

        rightButton.titleFont = .font(ofSize: fontSize)
        rightButton.setTitleColor(titleColor, for: .normal)
        rightButton.setTitle(title, for: .normal)

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

fileprivate class ActionSheetItemView: UIControl {
    private let actionSheetItem: ActionSheetItem
    private let showDivider: Bool

    fileprivate weak var actionSheetController: ActionSheetController?

    init(item: ActionSheetItem, showDivider: Bool = true) {
        self.actionSheetItem = item
        self.showDivider = showDivider
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: item.height))

        setupView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = Colors.separator
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = .clear
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Colors.backgroundPrimary
        addSubview(label)

        if showDivider {
            dividerView.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
            addSubview(dividerView)
        }

        addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }

    @objc private func onClick() {
        actionSheetItem.handler?()
        actionSheetController?.dismiss(animated: true)
    }

    private lazy var label: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textColor = actionSheetItem.textColor
        label.text = actionSheetItem.title
        label.font = actionSheetItem.font
        label.textAlignment = .center
        return label
    }()
    private let dividerView: UIView = UIView().then { $0.backgroundColor = Colors.separator }
}

public class ActionSheetController: SheetViewController {
    public override var controllerHeight: CGFloat {
        var height: CGFloat = headerView.height

        if let contentView = contentView {
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
    public var contentView: UIView?
    public lazy var defaultCancelItem: ActionSheetItem = ActionSheetItem(title: "取消", textColor: Colors.red_600)
    public var showDefaultCancelButton: Bool = true
    public var panToDismiss: Bool = true

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary
        view.addGestureRecognizer(panGestureRecognizer)
        setupView()
    }

    private func setupView() {
        view.addSubview(headerView)

        if let contentView = contentView {
            let contentFrame = contentView.frame
            contentView.frame = CGRect(x: 0, y: headerView.height, width: contentFrame.width, height: contentFrame.height)
            view.addSubview(contentView)
        } else {
            view.addSubview(sheetView)

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

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGestureRecognizer(_:)))
        recognizer.minimumNumberOfTouches = 1
        recognizer.delegate = self
        return recognizer
    }()
}

extension ActionSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        panToDismiss
    }

    @objc private func onPanGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began: break
        case .changed:
            let translation = recognizer.translation(in: view)
            if abs(translation.x) > abs(translation.y) { break }
            if translation.y <= 0 {
                view.transform = .identity
            } else {
                view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            let translation = recognizer.translation(in: view)
            if translation.y >= controllerHeight / 2 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.view.transform = .identity
                }
            }
        case .cancelled:
            UIView.animate(withDuration: 0.25) {
                self.view.transform = .identity
            }
        default: break
        }
    }
}
