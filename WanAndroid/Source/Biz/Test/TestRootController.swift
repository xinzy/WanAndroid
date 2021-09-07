//
//  TestRootController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/31.
//

import UIKit
import SnapKit
import Commons

class TestRootController: UIViewController {
    static func showController(_ navigationController: UINavigationController?) {
        let controller = TestRootController()
        navigationController?.pushViewController(controller, animated: true)
    }

    private let items: [(String, UIViewController.Type)] = [
        ("Popup", TestPopupController.self),
        ("Slide", TestSlideController.self),
        ("照片选择", TestAlbumController.self),
        ("密码输入框", TestPasswordInputController.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

extension TestRootController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        let item = items[indexPath.row]
        cell.textLabel?.text = item.0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let controller = item.1.init()
        controller.title = item.0
        navigationController?.pushViewController(controller, animated: true)
    }
}
