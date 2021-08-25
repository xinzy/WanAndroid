//
//  MineListController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import Commons
import SnapKit
import RxSwift
import HandyJSON

class MineBaseListController<T: HandyJSON, VM: MineBaseListViewModel<T>>: UIViewController, AutoDisposed, UITableViewDataSource {

    let viewModel = VM.init()

    static func showController(_ navigationController: UINavigationController?) {
        let controller = Self.init()
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindAction()
        tableView.refresh()
    }

    private func setupView() {
        view.backgroundColor = Colors.backgroundPrimary
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bindAction() {
        viewModel.resultSubject.subscribe { [weak self] result in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            if result.isRefresh {
                self.tableView.endRefresh()
            }
            self.tableView.endLoadMore(result.isEnd)
        }.disposed(by: disposeBag)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Sub class should be override")
    }

    func config(tableView: UITableView) { }

    @objc func onRefresh() {
        viewModel.refresh()
    }

    @objc func onLoadMore() {
        viewModel.load()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.addRefreshHeader(self, #selector(onRefresh))
        tableView.addRefreshFooter(self, #selector(onLoadMore))

        config(tableView: tableView)
        tableView.dataSource = self

        return tableView
    }()
}

class RankController: MineBaseListController<Score, RankViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "排行榜"
    }

    override func config(tableView: UITableView) {
        tableView.rowHeight = 48
        tableView.register(RankCell.self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RankCell = tableView.dequeueReusableCell(indexPath)
        cell.score = viewModel.dataSource[indexPath.row]
        return cell
    }
}

class ScoreHistoryController: MineBaseListController<ScoreHistory, ScoreHistoryViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "积分记录"
    }

    override func config(tableView: UITableView) {
        tableView.register(ScoreHistoryCell.self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScoreHistoryCell = tableView.dequeueReusableCell(indexPath)
        cell.history = viewModel.dataSource[indexPath.row]
        return cell
    }
}
