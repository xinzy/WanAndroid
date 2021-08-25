//
//  SettingController.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/19.
//

import Eureka
import Commons
import SnapKit
import Kingfisher

class SettingController: FormViewController {
    static func showController(_ navigationController: UINavigationController?) {
        let controller = SettingController()
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculateDiskStorageSize()
    }

    override func insertAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        .fade
    }

    override func deleteAnimation(forSections sections: [Section]) -> UITableView.RowAnimation {
        .fade
    }
}

extension SettingController {

    private func setupView() {
        view.backgroundColor = Colors.backgroundPrimary
        tableView.separatorStyle = .none

        form +++ Section()
            <<< SettingItemLabelRow("Clean Cache", {
                $0.iconImage = .iconMineCleanCache
                $0.titleText = "清理缓存"
                $0.isArrowHidden = true
            })
            .onCellSelection { [weak self] _, _ in
                self?.clearCache()
            }

        if #available(iOS 13.0, *) {
            form +++ Section(header: "主题模式", footer: "开启后，将根据系统打开或关闭深色模式")
                <<< SettingItemSwitchRow("Theme Mode", {
                    $0.iconImage = .iconMineMode
                    $0.titleText = "跟随系统"
                    $0.isOn = ThemeManager.shared.isSystemTheme
                })
                .onChange {
                    ThemeManager.shared.isSystemTheme = $0.value ?? true
                }

            +++ Section("手动选择") {
                    $0.hidden = .function(["Theme Mode"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowBy(tag: "Theme Mode")
                        return (row.value ?? false) == true
                    })
                }
                <<< SettingThemeSelectorRow("Theme Selector", {
                    $0.value = ThemeManager.shared.userTheme
                })
                .onChange {
                    ThemeManager.shared.setTheme($0.value ?? .light)
                }
        }
    }

    private func calculateDiskStorageSize() {
        ImageCache.default.calculateDiskStorageSize { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let size):
                let text: String
                if size > 1024 * 1024 {
                    text = String(format: "%.2fM", Float(size) / 1024 / 1024)
                } else if size > 1024 {
                    text = String(format: "%.2fK", Float(size) / 1024)
                } else {
                    text = "\(size)B"
                }
                if let row = self.form.rowBy(tag: "Clean Cache") as? SettingItemLabelRow {
                    row.tipText = text
                }
            case .failure: break
            }
        }
    }

    private func clearCache() {
        let controller = UIAlertController(title: "现在要清理缓存么？", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "立即清理", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            HUD.show(.progress)
            ImageCache.default.clearDiskCache {
                HUD.hide()
                if let row = self.form.rowBy(tag: "Clean Cache") as? SettingItemLabelRow {
                    row.tipText = "0K"
                }
            }
        }
        controller.addAction(action)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(controller, animated: true)
    }
}
