//
//  List.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 列表
struct List<T: HandyJSON>: HandyJSON{
    var curPage: Int = 0
    var offset: Int = 0
    var over: Bool = false
    var pageCount: Int = 0
    var size: Int = 0
    var total: Int = 0

    var datas: [T] = [T]()
}
