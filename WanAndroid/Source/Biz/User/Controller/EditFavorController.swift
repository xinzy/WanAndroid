//
//  EditFavorController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import SnapKit
import Commons

class EditFavorController: SheetViewController {

    override var controllerHeight: CGFloat { 320 }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private lazy var mainView: UIView = UIControl().then {
        $0.backgroundColor = Colors.backgroundPrimary
        $0.cornerRadius(12)
        $0.shadow(Colors.textPrimary, radius: 5)
        $0.action = { self.dismiss(animated: true, completion: nil) }
    }
}
