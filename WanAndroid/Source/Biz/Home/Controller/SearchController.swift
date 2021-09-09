//
//  SearchController.swift
//  WanAndroid
//
//  Created by Yang on 2021/9/7.
//

import UIKit
import Commons
import SnapKit
import FDFullscreenPopGesture

class SearchController: UIViewController {

    static func showController(from controller: UIViewController) {
        let navigationController = ThemeNavigationController(rootViewController: SearchController())
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary
        setupView()
    }

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

    private lazy var tagGroup: TagGroup = {
        let group = TagGroup()
        return group
    }()

    private lazy var searchBar: SearchBar = {
        let bar = SearchBar(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44))
        bar.delegate = self
        return bar
    }()
}

extension SearchController {

    private func setupView() {
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(tagGroup)
        tagGroup.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func refresh() {

    }

    @objc private func loadMore() {

    }
}

// MARK: - SearchBar Delegate
extension SearchController: SearchBarDelegate {
    func searchBarShouldCancel(_ searchBar: SearchBar) {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension SearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
