//
//  WechatController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/16.
//

import UIKit
import Commons
import SnapKit
import JXSegmentedView

class WechatController: UIViewController {

    private let viewModel = WechatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        setupView()
        bindAction()
        viewModel.loadWechatList()
    }

    private lazy var containerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()

    private lazy var segmentedTitleDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedFont = .font(ofSize: 16, type: .semibold)
        dataSource.titleNormalFont = .font(ofSize: 14)
        dataSource.titleSelectedColor = Colors.red_600
        dataSource.titleNormalColor = Colors.textHint
        dataSource.isItemSpacingAverageEnabled = false
        return dataSource
    }()

    private lazy var segmentedView: JXSegmentedView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 3
        indicator.indicatorColor = Colors.red_600

        let view = JXSegmentedView()
        view.backgroundColor = Colors.cell
        view.dataSource = segmentedTitleDataSource
        view.indicators = [indicator]
        view.listContainer = containerView

        return view
    }()
}

extension WechatController: AutoDisposed {
    private func setupView() {
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(44)
        }

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindAction() {
        viewModel.chapterSubject.subscribe { [weak self] titles in
            guard let `self` = self else { return }
            self.segmentedTitleDataSource.titles = titles
            self.segmentedView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension WechatController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        viewModel.chapters.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        WechatItemController(chapterId: viewModel.chapters[index].id)
    }
}
