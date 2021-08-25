//
//  SiteNavigation.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Foundation
import HandyJSON

/// 导航数据
struct SiteNavigation: HandyJSON {
    var cid: Int = 0
    var name: String = ""
    var articles: [Article] = [Article]()

    func toChapter() -> Chapter {
        var chapter = Chapter(id: cid, parentChapterId: 0, courseId: 0, order: 0, visible: 0, name: name)
        articles.forEach { item in
            let child = Chapter(id: item.id, parentChapterId: cid, courseId: item.courseId, order: 0, visible: 1, name: item.title, url: item.link)
            chapter.children.append(child)
        }
        return chapter
    }
}
