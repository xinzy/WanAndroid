//
//  SquareItemController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/28.
//

import UIKit
import RxSwift
import JXSegmentedView
import Commons

class SquareItemController: UIViewController {

    var items: [SquareItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loading()
    }

    func loading() {}

    func itemClick(item: SquareItem, index: Int) { }

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()

    private lazy var parentTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = 44
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(SquareItemParentTableViewCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var childrenTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.register(SquareItemChildrenTableViewCell.self)
        view.dataSource = self
        return view
    }()
}

extension SquareItemController: AutoDisposed {
    private func setupView() {
        view.addSubview(parentTableView)
        parentTableView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(120)
        }

        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(parentTableView)
            make.width.equalTo(1)
        }

        view.addSubview(childrenTableView)
        childrenTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(separatorView.snp.trailing)
            make.width.equalTo(ScreenWidth - 120)
        }
    }

    func reloadData() {
        parentTableView.reloadData()
        childrenTableView.reloadData()
    }
}

extension SquareItemController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        if tableView == parentTableView {
            let cell: SquareItemParentTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.title = item.title
            return cell
        } else {
            let cell: SquareItemChildrenTableViewCell = tableView.dequeueReusableCell(indexPath)
            cell.item = item
            cell.onItemClickAction = { [weak self] item, index in
                self?.itemClick(item: item, index: index)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == parentTableView {
            childrenTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
               let cell = tableView.cellForRow(at: selectedIndexPath) {
                cell.setSelected(false, animated: true)
            }

            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }
}

extension SquareItemController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        view
    }
}

class KnowledgeSystemController: SquareItemController {
    override func loading() {
        showLoading()
        ApiHelper.fetchKnowledgeList().subscribe { [weak self] chapters in
            guard let `self` = self else { return }
            self.hideLoading()
            self.items = SquareItem.convert(chapters: chapters)
            self.reloadData()
        }.disposed(by: disposeBag)
    }

    override func itemClick(item: SquareItem, index: Int) {
        KnowledgeController.showController(navigationController, item: item, defaultIndex: index)
    }
}

class SiteNavigationController: SquareItemController {
    override func loading() {
        showLoading()
        ApiHelper.fetchNaviList().subscribe { [weak self] sites in
            guard let `self` = self else { return }
            self.hideLoading()
            self.items = SquareItem.convert(sites: sites)
            self.reloadData()
        }.disposed(by: disposeBag)
    }

    override func itemClick(item: SquareItem, index: Int) {
        WebViewController.showController(navigationController, item.children[index].link)
    }
}
