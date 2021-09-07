//
//  PhotoSelectConfig.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import Foundation

/// 媒体选择配置
public class MediaSelectedConfiguration {
    public static let shared = MediaSelectedConfiguration()

    /// 最大选择数量 默认值9
    @RangeValueWrapper(range: 1...99, defaultValue: 9)
    public var maxSelectedCount: Int

    /// 相册一行默认展示图片张数
    @RangeValueWrapper(range: 3...5, defaultValue: 4)
    public var displayNumberPerRow: Int

    /// 允许选择的类型
    public var allowAssetType: AssetType = [.gif, .jpg, .png, .video]

    /// 允许的媒体类型
    public var allowMediaType: MediaType = .all

    /// 相册排序方式
    public var assetsSortType: AssetsSort = .ascending

    /// 相册类型
    public var albumStyle: AlbumStyle = .embed

    public init() { }
}

/// 媒体类型
public enum MediaType {
    case image, video, all
}

/// 媒体资源类型
public struct AssetType: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Gif
    public static let gif = AssetType(rawValue: 1 << 0)
    // Jpg
    public static let jpg = AssetType(rawValue: 1 << 1)
    // Png
    public static let png = AssetType(rawValue: 1 << 2)
    // 视频
    public static let video = AssetType(rawValue: 1 << 3)
    // 实况照片
    public static let live = AssetType(rawValue: 1 << 4)
}

/// 相册选择样式
public enum AlbumStyle {
    case embed
    case external
}

public enum AssetsSort {
    case ascending, descending
}
