//
//  KnowledgeItemController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/28.
//

import UIKit
import JXSegmentedView

class KnowledgeItemController: UIViewController {
    private let item: SquareItem
    private let viewModel: KnowledgeItemViewModel

    init(item: SquareItem) {
        self.item = item
        self.viewModel = KnowledgeItemViewModel(item: item)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindAction()
        tableView.refresh()
    }

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.addRefreshHeader(self, #selector(onRefresh))
        view.addRefreshFooter(self, #selector(onLoadMore))

        view.register(ArticleCell.self)
        view.dataSource = self
        view.delegate = self

        return view
    }()
}

extension KnowledgeItemController: AutoDisposed {
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindAction() {
        viewModel.resultSubject.subscribe { [weak self] result in
            guard let `self` = self else { return }
            if result.isRefresh {
                self.tableView.endRefresh()
            }
            self.tableView.endLoadMore(result.isEnd)
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }

    @objc private func onRefresh() {
        viewModel.refresh()
    }

    @objc private func onLoadMore() {
        viewModel.loading()
    }
}

extension KnowledgeItemController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(indexPath)
        cell.article = viewModel.articles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        WebViewController.showController(navigationController, article.link)
    }
}

extension KnowledgeItemController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
