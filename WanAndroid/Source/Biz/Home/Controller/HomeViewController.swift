//
//  HomeViewController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/9.
//

import UIKit
import Commons
import SnapKit

class HomeViewController: UIViewController, AutoDisposed {
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary
        setupView()
        bindAction()
        tableView.refresh()
    }

    private lazy var bannerView: BannerView = {
        let view = BannerView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 192))
        view.onItemClick = { [weak self] _, _, banner in
            guard let `self` = self else { return }
            WebViewController.showController(self.navigationController, banner.url)
        }
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableHeaderView = bannerView
        tableView.addRefreshHeader(self, #selector(refresh))
        tableView.addRefreshFooter(self, #selector(loadMore))

        tableView.register(ArticleCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

extension HomeViewController {

    private func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .iconSearch, style: .plain, target: self, action: #selector(search))
    }

    private func bindAction() {
        viewModel.loadedSubject.subscribe { [weak self] result in
            guard let `self` = self else { return }
            if result.isRefresh {
                self.bannerView.banners = self.viewModel.banners
                self.tableView.endRefresh()
            }
            self.tableView.reloadData()
            self.tableView.endLoadMore(result.isEnd)
        }.disposed(by: disposeBag)
    }

    @objc private func search() {
        SearchController.showController(from: self)
    }

    @objc private func refresh() {
        viewModel.refresh()
    }

    @objc private func loadMore() {
        viewModel.load()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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
