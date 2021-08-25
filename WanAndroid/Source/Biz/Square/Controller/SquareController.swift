//
//  SquareController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/20.
//

import UIKit
import Commons
import JXSegmentedView
import SnapKit

class SquareController: UIViewController {

    private let itemConfigs: [(String, JXSegmentedListContainerViewListDelegate)] = [
        ("体系", KnowledgeSystemController()),
        ("导航", SiteNavigationController())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        setupView()
    }

    private lazy var containerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()

    private lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = false
        dataSource.itemSpacing = 12
        dataSource.titleSelectedFont = .font(ofSize: 16, type: .semibold)
        dataSource.titleNormalFont = .font(ofSize: 16)
        dataSource.titleSelectedColor = Colors.red_600
        dataSource.titleNormalColor = Colors.textHint
        dataSource.titles = itemConfigs.map { $0.0 }
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

        return view
    }()
}

extension SquareController {
    private func setupView() {
        navigationItem.titleView = segmentedView

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SquareController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        itemConfigs.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        itemConfigs[index].1
    }
}
