//
//  FriendLink.swift
//  Wan
//
//  Created by Yang on 2021/2/23.
//

import Foundation
import HandyJSON

/// 友情链接
struct FriendLink: HandyJSON {
    var category: String = ""
    var icon: String = ""
    var link: String = ""
    var name: String = ""
    var id: Int = 0
    var order: Int = 0
    var visible: Int = 0
}
