//
//  SquareItem.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/28.
//

import Foundation

struct SquareItem {
    var id: Int = 0
    var title: String = ""
    var link: String = ""
    var children: [SquareItem] = []

    var childrenNames: [String] {
        children.map { $0.title }
    }

    static func convert(chapters: [Chapter]) -> [SquareItem] {
        chapters.map { chapter in
            let children = chapter.children.map { SquareItem(id: $0.id, title: $0.displayName) }
            return SquareItem(id: chapter.id, title: chapter.displayName, link: "", children: children)
        }
    }

    static func convert(sites: [SiteNavigation]) -> [SquareItem] {
        sites.map { site in
            let children = site.articles.map { SquareItem(id: $0.id, title: $0.title, link: $0.link) }
            return SquareItem(id: site.cid, title: site.name, link: "", children: children)
        }
    }
}
