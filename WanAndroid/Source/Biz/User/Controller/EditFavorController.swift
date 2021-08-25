//
//  EditFavorController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import UIKit
import SnapKit
import Commons

class EditFavorController: UIViewController, OverlayHost {

    var overlaySize: CGSize? = CGSize(width: 320, height: 320)


    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(320)
//            make.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }

    private lazy var mainView: UIView = UIControl().then {
        $0.backgroundColor = Colors.background
        $0.cornerRadius(12)
        $0.shadow(Colors.textPrimary, radius: 5)
        $0.action = { self.dismissOverlay() }
    }
}
