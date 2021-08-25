//
//  Article.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 文章
struct Article: HandyJSON {
    var id: Int = 0
    var title: String = ""
    var chapterId: Int = 0
    var chapterName: String = ""
    var superChapterId: Int = 0
    var superChapterName: String = ""
    var author: String = ""
    var canEdit: Bool = false
    var collect: Bool = false
    var desc: String = ""
    var link: String = ""
    var projectLink: String = ""
    var publishTime: Int = 0
    var envelopePic: String = ""
    var shareUser: String = ""
    var niceDate: String = ""
    var niceShareDate: String = ""
    var courseId: Int = 0

    var fresh: Bool = false
    var type: Int = 0
    var userId: Int = 0
    var visible: Int = 0
    var zan: Int = 0
    var tags: [Tag] = []

    var displayTitle: String {
        filterHtmlTag(title)
    }

    var displayDesc: String {
        filterHtmlTag(desc)
    }

    var displayAuthor: String {
        author.isNotEmpty ? author : (shareUser.isNotEmpty ? shareUser : "匿名")
    }

    /// 是否置顶文章
    var top: Bool {
        type == 1
    }

    var category: String {
        superChapterName + " / " + chapterName
    }
}
