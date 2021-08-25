//
//  Navi.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 收藏
struct Favor: HandyJSON {
    var id: Int = 0
    var author: String = ""
    var chapterId: Int = 0
    var chapterName: String = ""
    var desc: String = ""
    var envelopePic: String = ""
    var link: String = ""
    var origin: String = ""
    var originId: Int = 0
    var publishTime: Int = 0
    var title: String = ""
    var userId: Int = 0
    var visible: Int = 0
    var zan: Int = 0
    var niceDate: String = ""

    var displayTitle: String {
        filterHtmlTag(title)
    }

    var displayAuthor: String {
        author.isNotEmpty ? author : "匿名"
    }

    var displayTime: String {
        formatTime(millisecond: publishTime)
    }
}
