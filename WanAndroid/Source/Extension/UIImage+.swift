//
//  UIImage+.swift
//  Themes
//
//  Created by Yang on 2021/7/7.
//

import UIKit

public extension UIImage {

    static var iconBack: UIImage { imageOf("ic_back") }

    static var iconClose: UIImage { imageOf("icon_close") }

    static var iconAdd: UIImage { imageOf("ic_add") }

    static var iconAvatar: UIImage { imageOf("ic_avatar") }

    static var iconTop: UIImage { imageOf("ic_top") }

    static var iconHot: UIImage { imageOf("ic_hot") }

    static var iconFavor: UIImage { imageOf("ic_favor") }

    static var iconFavored: UIImage { imageOf("ic_favored") }

    static var iconSearch: UIImage { imageOf("ic_search") }

    static var placeholder: UIImage { imageOf("placeholder") }

    static var iconPasswordHidden: UIImage { imageOf("icon_passwd_invisible") }

    static var iconPasswordShown: UIImage { imageOf("icon_passwd_visible") }

    static var iconArrowRight: UIImage { imageOf("icon_arrow_right") }

    static var iconHeaderAvatar: UIImage { imageOf("icon_avatar") }

    private static func imageOf(_ name: String, in bundle: Bundle = .main) -> UIImage {
        UIImage(named: name, in: bundle, compatibleWith: nil)!
    }
}

// MARK: - 首页Tabbar
public extension UIImage {
    static var tabbarHomeNormal: UIImage { imageOf("tabbar_home_normal") }

    static var tabbarHomeSelected: UIImage { imageOf("tabbar_home_selected") }

    static var tabbarWechatNormal: UIImage { imageOf("tabbar_wechat_normal") }

    static var tabbarWechatSelected: UIImage { imageOf("tabbar_wechat_selected") }

    static var tabbarProjectNormal: UIImage { imageOf("tabbar_project_normal") }

    static var tabbarProjectSelected: UIImage { imageOf("tabbar_project_selected") }

    static var tabbarSquareNormal: UIImage { imageOf("tabbar_square_normal") }

    static var tabbarSquareSelected: UIImage { imageOf("tabbar_square_selected") }

    static var tabbarMineNormal: UIImage { imageOf("tabbar_mine_normal") }

    static var tabbarMineSelected: UIImage { imageOf("tabbar_mine_selected") }
}

// MARK: - 我的
public extension UIImage {

    static var iconMineFavor: UIImage { imageOf("icon_mine_favor") }

    static var iconMineScore: UIImage { imageOf("icon_mine_score") }

    static var iconMineRank: UIImage { imageOf("icon_mine_rank") }

    static var iconMineMessage: UIImage { imageOf("icon_mine_message") }

    static var iconMineSetting: UIImage { imageOf("icon_mine_setting") }

    static var iconMineCleanCache: UIImage { imageOf("icon_mine_clean_cache") }

    static var iconMineMode: UIImage { imageOf("icon_mine_mode") }

    static var iconMineSelected: UIImage { imageOf("icon_mine_selected") }
}
