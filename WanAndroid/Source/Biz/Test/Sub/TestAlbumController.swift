//
//  TestAlbumController.swift
//  WanAndroid
//
//  Created by Yang on 2021/9/1.
//

import UIKit
import SnapKit
import Commons

class TestAlbumController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.backgroundPrimary

        view.addSubview(selectPhotoButton)
        selectPhotoButton.snp.makeConstraints { make in
            make.leading.equalTo(32)
            make.top.equalTo(32)
        }

        view.addSubview(selectPhotoButton2)
        selectPhotoButton2.snp.makeConstraints { make in
            make.top.equalTo(selectPhotoButton)
            make.trailing.equalTo(-32)
        }
    }

    private lazy var selectPhotoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("选择照片(内置)", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.action = { [weak self] in
            guard let `self` = self else { return }
            let selection = MediaSelection()
            selection.show(self)
        }
        return btn
    }()

    private lazy var selectPhotoButton2: UIButton = {
        let btn = UIButton()
        btn.setTitle("选择照片(扩展)", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.action = { [weak self] in
            guard let `self` = self else { return }
            let selection = MediaSelection()
            var config = MediaSelectedConfiguration()
            config.albumStyle = .external
            selection.show(self, configuration: config)
        }
        return btn
    }()
}
