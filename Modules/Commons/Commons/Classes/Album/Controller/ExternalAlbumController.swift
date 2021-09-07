//
//  ExternalAlbumController.swift
//  Commons
//
//  Created by Yang on 2021/9/2.
//

import UIKit

public class ExternalAlbumController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "选择相册"
        navigationItem.leftBarButtonItem = cancelBarItem
        view.backgroundColor = Colors.backgroundPrimary
    }



    private lazy var cancelBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))
        return item
    }()
}

extension ExternalAlbumController {

    @objc private func cancelClick() {
        navigationController?.dismiss(animated: true)
    }
}
