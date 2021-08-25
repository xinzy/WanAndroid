//
//  Banner.swift
//  Wan
//
//  Created by Yang on 2021/2/4.
//

import HandyJSON

/// 首页Banner
struct Banner: HandyJSON {
    var id: Int = 0
    var desc: String = ""
    var imagePath: String = ""
    var title: String = ""
    var url: String = ""
    var isVisible: Int = 0
    var order: Int = 0
    var type: Int = 0
}
