//
//  Score.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 积分
struct Score: HandyJSON {
    var coinCount: Int = 0
    var level: Int = 0
    var rank: Int = 0
    var userId: Int = 0
    var username: String = ""
}
