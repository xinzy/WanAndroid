//
//  Chapter.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 分类
struct Chapter: HandyJSON {
    var id: Int = 0
    var parentChapterId: Int = 0
    var courseId: Int = 0
    var order: Int = 0
    var visible: Int = 0
    var name: String = ""
    var children: [Chapter] = [Chapter]()
    var url: String = ""

    var childrenNames: [String] {
        var names = [String]()
        children.forEach {
            names.append($0.name)
        }
        return names
    }

    var displayName: String {
        filterHtmlTag(name)
    }
}
