//
//  WechatItemController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/16.
//

import UIKit
import Commons
import JXSegmentedView

class WechatItemController: UIViewController {
    private let viewModel: WechatItemViewModel

    init(chapterId: Int) {
        viewModel = WechatItemViewModel(chapterId: chapterId)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bindAction()
        tableView.refresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: - 搜索功能
    private lazy var searchField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.leftViewMode = .always
        return field
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.addRefreshHeader(self, #selector(refresh))
        tableView.addRefreshFooter(self, #selector(loadMore))

        tableView.register(ArticleCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension WechatItemController: AutoDisposed {
    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    private func bindAction() {
        viewModel.loadedSubject.subscribe { [weak self] action in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            if action.isFirstPage {
                self.tableView.endRefresh()
            }
            self.tableView.endLoadMore(action.isEnd)
        }.disposed(by: disposeBag)
    }

    @objc private func refresh() {
        viewModel.refresh()
    }

    @objc private func loadMore() {
        viewModel.load()
    }
}

extension WechatItemController: UITableViewDataSource, UITableViewDelegate {
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

extension WechatItemController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}
