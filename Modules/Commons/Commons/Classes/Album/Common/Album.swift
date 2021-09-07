//
//  Album.swift
//  Commons
//
//  Created by Yang on 2021/9/2.
//

import Foundation
import Photos

struct Album {
    var title: String
    var assets: PHFetchResult<PHAsset>

    var count: Int { assets.count }

    var cover: PHAsset? { assets.lastObject }
}

extension Album: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title && lhs.count == rhs.count && lhs.cover?.localIdentifier == rhs.cover?.localIdentifier
    }
}
