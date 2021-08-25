//
//  ScoreHistory.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 积分历史记录
struct ScoreHistory: HandyJSON {
    var coinCount: Int = 0
    var date: Int = 0
    var id: Int = 0
    var userId: Int = 0
    var type: Int = 0
    var desc: String = ""
    var reason: String = ""
    var userName: String = ""

    var displayTime: String {
        formatTime(millisecond: date)
    }
}
