//
//  MineController.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/23.
//

import UIKit
import Commons
import Eureka
import SnapKit
import FDFullscreenPopGesture

class MineController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        fd_prefersNavigationBarHidden = true
        view.backgroundColor = Colors.backgroundSecondary
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUI()
    }

    private lazy var headerView: HeaderWrapperView = {
        let view = HeaderWrapperView()
        view.headerView.loginAction = { [weak self] in
            guard let `self` = self else { return }
            if User.me.isLogin {
                TestRootController.showController(self.navigationController)
            } else {
                self.login()
            }
        }
        return view
    }()

    private lazy var logoutButton: LogoutButton = {
        let button = LogoutButton()
        button.action = logout
        return button
    }()

    private var counter = 0
    private var lastTapTime: TimeInterval = 0
}

extension MineController {

    private func setupView() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 8

        tableView.tableHeaderView = headerView
        tableView.tableFooterView = logoutButton

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        form +++ Section()
            <<< SettingItemLabelRow("Score", { row in
                row.iconImage = .iconMineScore
                row.titleText = "我的积分"
                row.tipText = ""
            })
            .onCellSelection { [weak self] _, _ in
                guard let `self` = self else { return }
                if User.me.isLogin {
                    ScoreHistoryController.showController(self.navigationController)
                } else {
                    self.login()
                }
            }
            <<< SettingItemLabelRow("Rank", { row in
                row.iconImage = .iconMineRank
                row.titleText = "我的排行"
                row.tipText = ""
            })
            .onCellSelection { [weak self] _, _ in
                guard let `self` = self else { return }
                if User.me.isLogin {
                    RankController.showController(self.navigationController)
                } else {
                    self.login()
                }
            }
            <<< SettingItemLabelRow("Favor", { row in
                row.iconImage = .iconMineFavor
                row.titleText = "我的收藏"
            })
            .onCellSelection { [weak self] _, _ in
                guard let `self` = self else { return }
                if User.me.isLogin {
                    FavorController.showController(self.navigationController)
                } else {
                    self.login()
                }
            }

            +++ Section()
            <<< SettingItemLabelRow("Message", { row in
                row.iconImage = .iconMineMessage
                row.titleText = "消息"
            })
            .onCellSelection { _, _ in
                // do nothing
            }
            <<< SettingItemLabelRow("Setting", { row in
                row.iconImage = .iconMineSetting
                row.titleText = "设置"
            })
            .onCellSelection { [weak self] _, _ in
                guard let `self` = self else { return }
                SettingController.showController(self.navigationController)
            }
    }

    private func refreshUI() {
        headerView.headerView.user = User.me
        logoutButton.isHidden = !User.me.isLogin
        loadScore()
    }

    private func logout() {
        let controller = UIAlertController(title: "确认要退出登录么？", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { [weak self] _ in
            self?.logoutRequest()
        })
        controller.addAction(okAction)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    private func login() {
        LoginController.showController(self)
    }
}

extension MineController: AutoDisposed {
    private func loadScore() {
        let scoreRow = form.rowBy(tag: "Score") as? SettingItemLabelRow
        let rankRow = form.rowBy(tag: "Rank") as? SettingItemLabelRow
        if !User.me.isLogin {
            scoreRow?.tipText = ""
            rankRow?.tipText = ""
            return
        }
        ApiHelper.fetchScore().subscribe { score in
            scoreRow?.tipText = "\(score.coinCount)"
            rankRow?.tipText = "\(score.rank)"
        }.disposed(by: disposeBag)
    }

    private func logoutRequest() {
        ApiHelper.logout().subscribe { [weak self] b in
            guard let `self` = self else { return }
            if b {
                User.me.logout()
                self.refreshUI()
            } else {
                HUD.tip(text: "退出登录失败")
            }
        }.disposed(by: disposeBag)
    }
}
