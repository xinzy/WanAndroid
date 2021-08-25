//
//  KnowledgeController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/28.
//

import UIKit
import JXSegmentedView
import SnapKit
import Commons

class KnowledgeController: UIViewController {
    private let item: SquareItem
    private let defaultSelectedIndex: Int

    init(item: SquareItem, index: Int) {
        self.item = item
        self.defaultSelectedIndex = index

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = item.title
        setupView()
    }

    private lazy var containerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        view.defaultSelectedIndex = defaultSelectedIndex
        return view
    }()

    private lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedFont = .font(ofSize: 16, type: .semibold)
        dataSource.titleNormalFont = .font(ofSize: 14)
        dataSource.titleSelectedColor = Colors.red_600
        dataSource.titleNormalColor = Colors.textInfo
        dataSource.titles = item.childrenNames
        return dataSource
    }()

    private lazy var segmentedView: JXSegmentedView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 3
        indicator.indicatorColor = Colors.red_600

        let view = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: 108, height: 44))
        view.dataSource = dataSource
        view.indicators = [indicator]
        view.listContainer = containerView
        view.defaultSelectedIndex = defaultSelectedIndex

        return view
    }()
}

extension KnowledgeController {

    static func showController(_ navigationController: UINavigationController?, item: SquareItem, defaultIndex: Int) {
        let controller = KnowledgeController(item: item, index: defaultIndex)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }

    private func setupView() {
        view.backgroundColor = Colors.backgroundPrimary
        
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
}

extension KnowledgeController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        item.children.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        KnowledgeItemController(item: item.children[index])
    }
}
