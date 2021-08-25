//
//  MainViewController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/9.
//

import UIKit
import Commons

class MainViewController: UITabBarController {

    typealias TabbarItem = (controller: UIViewController.Type, title: String,
                            defaultImage: () -> UIImage, selectedImage: () -> UIImage)

    private let tabConfigs: [TabbarItem] = [
        (HomeViewController.self, "首页", { .tabbarHomeNormal }, { .tabbarHomeSelected }),
        (WechatController.self, "微信", { .tabbarWechatNormal }, { .tabbarWechatSelected }),
        (ProjectController.self, "项目", { .tabbarProjectNormal }, { .tabbarProjectSelected }),
        (SquareController.self, "广场", { .tabbarSquareNormal }, { .tabbarSquareSelected }),
        (MineController.self, "我的", { .tabbarMineNormal }, { .tabbarMineSelected })
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        initTheme()
        setupTabbar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        children.forEach { index, item in
            item.tabBarItem.image = tabConfigs[index].defaultImage()
            item.tabBarItem.selectedImage = tabConfigs[index].selectedImage()
        }
    }

    private func initTheme() {
        tabBar.barTintColor = Colors.tabbarTint.withAlphaComponent(0.1)
        tabBar.tintColor = Colors.textPrimary
    }

    private func setupTabbar() {
        tabConfigs.forEach { item in
            let controller = item.controller.init()
            controller.title = item.title
            let navigationController = ThemeNavigationController(rootViewController: controller)
            navigationController.title = item.title
            navigationController.tabBarItem.title = item.title
            navigationController.tabBarItem.image = item.defaultImage()
            navigationController.tabBarItem.selectedImage = item.selectedImage()

            addChild(navigationController)
        }
    }
}
