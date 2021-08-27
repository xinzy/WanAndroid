//
//  FavorController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import Commons
import SnapKit
import RxSwift

class FavorController: MineBaseListController<Favor, FavorViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的收藏"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .iconAdd, style: .plain, target: self, action: #selector(addFavor))
    }

    override func config(tableView: UITableView) {
        tableView.register(FavorCell.self)
        tableView.delegate = self
    }

    override func bindAction() {
        super.bindAction()

        viewModel.uncollectSubject.subscribe { [weak self] indexPath in
            self?.tableView.deleteRow(indexPath)
        }.disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavorCell = tableView.dequeueReusableCell(indexPath)
        cell.favor = viewModel.dataSource[indexPath.row]
        return cell
    }
}

extension FavorController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favor = viewModel.dataSource[indexPath.row]
        WebViewController.showController(navigationController, favor.link)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        [
            UITableViewRowAction(style: .default, title: "取消收藏", handler: { [weak self] action, indexPath in
                self?.viewModel.uncollect(indexPath)
            }),
            UITableViewRowAction(style: .normal, title: "编辑", handler: { [weak self] action, indexPath in
                guard let `self` = self else { return }
                let favor = self.viewModel.dataSource[indexPath.row]
                self.editFavor(favor)
            })
        ]
    }
}

extension FavorController {
    @objc private func addFavor() {
        editFavor(nil)
    }

    private func editFavor(_ favor: Favor?) {
        let controller = EditFavorController(favor)
        controller.editResultAction = { [weak self] _ in
            self?.tableView.refresh()
        }
        controller.present(from: self)
    }
}
