//
//  ThemeNavigationController.swift.swift
//  Themes
//
//  Created by Yang on 2021/7/6.
//

import UIKit

public class ThemeNavigationController: UINavigationController, UINavigationControllerDelegate {

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = Colors.navigationTint
        navigationBar.tintColor = Colors.textPrimary
        navigationBar.isTranslucent = false
        delegate = self
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.isNotEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if viewControllers.first != viewController && viewController.autoCreateBackItem {
            viewController.navigationItem.leftBarButtonItem = defaultBackItem
        }
    }

    @objc private func onBackClick() {
        popViewController(animated: true)
    }

    private var defaultBackItem: UIBarButtonItem {
        let image = UIImage(named: "ic_back", in: currentBundle, compatibleWith: nil)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onBackClick), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
