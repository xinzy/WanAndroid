//
//  Readme.swift
//  Commons
//
//  Created by Yang on 2021/8/27.
//

import UIKit

public class MediaSelection {

    public init() { }

    public func show(_ controller: UIViewController, configuration: MediaSelectedConfiguration = MediaSelectedConfiguration()) {

        let navigationController: ThemeNavigationController

        switch configuration.albumStyle {
        case .embed: navigationController = ThemeNavigationController(rootViewController: MediaSelectionController(configuration: configuration))
        case .external:
            navigationController = ThemeNavigationController()
            let children: [UIViewController] = [ExternalAlbumController(), MediaSelectionController(configuration: configuration)]
            navigationController.setViewControllers(children, animated: false)
        }
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true)
    }
}
