//
//  File.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

///搜索热词
struct HotKey: HandyJSON {
    var id: Int = 0
    var link: String = ""
    var name: String = ""
    var order: Int = 1
    var visible: Int = 0
}
