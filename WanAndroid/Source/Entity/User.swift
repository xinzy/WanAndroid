//
//  User.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

//MARK: - 用户
struct User: HandyJSON {
    var id: Int = 0
    var nickname: String = ""
    var publicName: String = ""
    var username: String = ""
    var email: String = ""
    var token: String = ""
    var icon: String = ""
    var type: Int = 0
    var admin: Bool = false

    var collectIds: [Int] = [Int]()

    var favorCount: Int = 0

    var isLogin: Bool {
        id != 0
    }
    static var me: User = User()

    private static let KEY_LOGIN_ID = "LoginId"
    private static let KEY_LOGIN_USERNAME = "LoginUsername"
    private static let KEY_LOGIN_NICKNAME = "LoginNickname"
    private static let KEY_LOGIN_FAVOR_COUNT = "LoginFavorCount"

    static func autoLogin() {
        let id = UserDefaults.user.integer(forKey: User.KEY_LOGIN_ID)
        guard id > 0 else { return }

        User.me.id = id
        User.me.username = UserDefaults.user.string(forKey: User.KEY_LOGIN_USERNAME) ?? ""
        User.me.nickname = UserDefaults.user.string(forKey: KEY_LOGIN_USERNAME) ?? ""
        User.me.favorCount = UserDefaults.user.integer(forKey: KEY_LOGIN_FAVOR_COUNT)
    }

    mutating func login(_ user: User) {
        self.id = user.id
        self.username = user.username
        self.nickname = user.nickname
        self.favorCount = user.collectIds.count

        UserDefaults.user.set(self.id, forKey: User.KEY_LOGIN_ID)
        UserDefaults.user.set(self.username, forKey: User.KEY_LOGIN_USERNAME)
        UserDefaults.user.set(self.nickname, forKey: User.KEY_LOGIN_NICKNAME)
        UserDefaults.user.set(self.favorCount, forKey: User.KEY_LOGIN_FAVOR_COUNT)
    }

    mutating func logout() {
        self.id = 0
        self.username = ""
        self.nickname = ""

        UserDefaults.user.set(0, forKey: User.KEY_LOGIN_ID)
        UserDefaults.user.set("", forKey: User.KEY_LOGIN_USERNAME)
        UserDefaults.user.set("", forKey: User.KEY_LOGIN_NICKNAME)
        UserDefaults.user.set(0, forKey: User.KEY_LOGIN_FAVOR_COUNT)
    }
}

fileprivate extension UserDefaults {
    static let user: UserDefaults = UserDefaults(suiteName: "UserInfo")!
}
