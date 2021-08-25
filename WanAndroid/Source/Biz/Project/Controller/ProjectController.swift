//
//  ProjectController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/19.
//

import UIKit
import SnapKit
import JXSegmentedView
import Commons

class ProjectController: UIViewController {
    private let viewModel = ProjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.background
        setupView()
        bindAction()
        viewModel.load()
    }

    private lazy var containerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        return view
    }()

    private lazy var dataSource: JXSegmentedTitleDataSource = {
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
        view.dataSource = dataSource
        view.indicators = [indicator]
        view.listContainer = containerView

        return view
    }()
}

extension ProjectController: AutoDisposed {
    private func setupView() {
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

    private func bindAction() {
        viewModel.loadedSubject.subscribe { [weak self] titles in
            guard let `self` = self else { return }
            self.dataSource.titles = titles
            self.segmentedView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension ProjectController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        viewModel.chapters.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        ProjectItemController(chapterId: viewModel.chapters[index].id)
    }
}
