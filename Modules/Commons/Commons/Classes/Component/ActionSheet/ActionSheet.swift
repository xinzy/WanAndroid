//
//  ActionSheet.swift
//  Alamofire
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import SnapKit

public typealias ActionSheetHandler = () -> Void

public struct ActionSheetItem {
    var title: String = ""
    var textColor: UIColor = Colors.textPrimary
    var font: UIFont = .font(ofSize: 14)
    var height: CGFloat = 48
    var handler: ActionSheetHandler?
}

open class ActionSheet {
    private var actionSheetItems = [ActionSheetItem]()

    private var actionSheetController = ActionSheetController()

    public var showDefaultCancelButton: Bool = true

    public var titleText: String {
        get { headerView.title }
        set { headerView.title = newValue }
    }
    public var titleView: UIView? {
        get { headerView.titleView }
        set { headerView.titleView = newValue }
    }

    private var contentView: UIView?

    public lazy var defaultCancelItem: ActionSheetItem = ActionSheetItem(title: "取消", textColor: Colors.red_500) { [weak self] in
        self?.dismiss()
    }

    public func addLeftButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        headerView.addLeftButton(title, fontSize: fontSize, titleColor: titleColor, handler: handler)
    }

    public func addRightButton(_ title: String, fontSize: CGFloat = 14, titleColor: UIColor = Colors.blue_600, handler: ActionSheetHandler? = nil) {
        headerView.addRightButton(title, fontSize: fontSize, titleColor: titleColor, handler: handler)
    }

    public func setContentView(_ contentView: UIView, _ height: CGFloat) {
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: height)
        self.contentView = contentView
    }

    public func addActionItem(_ title: String, textColor: UIColor = Colors.textPrimary, font: UIFont = .font(ofSize: 14),
                              height: CGFloat = 48, handler: ActionSheetHandler? = nil) {
        actionSheetItems.append(ActionSheetItem(title: title, textColor: textColor, font: font, height: height, handler: handler))
    }

    public func show(from controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        actionSheetController.presentSheet(from: controller, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        actionSheetController.dismiss(animated: animated, completion: completion)
    }

    public lazy var headerView: ActionSheetHeader = {
        let header = ActionSheetHeader(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 52))
        header.cornerRadius(8, corners: [.topLeft, .topRight])
        header.actionSheet = self
        return header
    }()
}

public class ActionSheetHeader: UIView {

    private var leftHandler: ActionSheetHandler?
    private var rightHandler: ActionSheetHandler?

    fileprivate weak var actionSheet: ActionSheet?

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
        actionSheet?.dismiss()
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
        label.font = .font(ofSize: 16)
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

public class ActionSheetItemView: UIView {

}

public class ActionSheetController: SheetViewController {
    public override var controllerHeight: CGFloat { 0 }

    
}
