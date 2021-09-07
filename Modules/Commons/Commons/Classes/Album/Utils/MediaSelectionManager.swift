//
//  MediaSelectionManager.swift
//  Commons
//
//  Created by Yang on 2021/9/2.
//

import Photos

class MediaSelectionManager {

    static func getAlbums(config: MediaSelectedConfiguration, _ block: @escaping ([Album]) -> Void) {
        let option = createFetchOptions(with: config)

        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: option) as! PHFetchResult<PHCollection>
        let album = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil) as! PHFetchResult<PHCollection>
        let streamAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil) as! PHFetchResult<PHCollection>
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil) as! PHFetchResult<PHCollection>
        let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil) as! PHFetchResult<PHCollection>

        let albums = [smartAlbum, album, streamAlbums, syncedAlbums, sharedAlbums]
        let options = createFetchOptions(with: config, true)

        var albumData = [Album]()

        albums.forEach { album in

            album.enumerateObjects { collection, _, _ in
                guard let collection = collection as? PHAssetCollection else { return }

                if collection.assetCollectionSubtype == .smartAlbumAllHidden { return }
                if collection.assetCollectionSubtype.rawValue > PHAssetCollectionSubtype.smartAlbumLongExposures.rawValue { return }

                let assets = PHAsset.fetchAssets(in: collection, options: options)
                if assets.count == 0 { return }

                let albumTitle = collectionTitle(collection)

                if collection.assetCollectionSubtype == .smartAlbumUserLibrary {
                    albumData.insert(Album(title: albumTitle, assets: assets), at: 0)
                } else {
                    albumData.append(Album(title: albumTitle, assets: assets))
                }
            }
        }

        DispatchQueue.main.sync {
            block(albumData)
        }
    }



    private static func createFetchOptions(with config: MediaSelectedConfiguration, _ useSort: Bool = false) -> PHFetchOptions {
        let option = PHFetchOptions()

        option.includeHiddenAssets = false
        if useSort {
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: config.assetsSortType == .ascending)]
        }

        switch config.allowMediaType {
        case .image:
            option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        case .video:
            option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        default: break
        }
        return option
    }

    private static func collectionTitle(_ collection: PHAssetCollection) -> String {
        collectTitles[collection.assetCollectionSubtype] ?? collection.localizedTitle ?? "所有照片"
    }

    private static let collectTitles: [PHAssetCollectionSubtype: String] = [
        .smartAlbumUserLibrary: "最近项目",
        .smartAlbumPanoramas: "全景照片",
        .smartAlbumVideos: "视频",
        .smartAlbumFavorites: "个人收藏",
        .smartAlbumTimelapses: "延时摄影",
        .smartAlbumRecentlyAdded: "最近添加",
        .smartAlbumBursts: "连拍快照",
        .smartAlbumSlomoVideos: "慢动作",
        .smartAlbumSelfPortraits: "自拍",
        .smartAlbumScreenshots: "屏幕快照",
        .smartAlbumDepthEffect: "人像",
        .smartAlbumLivePhotos: "Live Photos",
        .smartAlbumAnimated: "动图",
        .albumMyPhotoStream: "我的照片流"
    ]
}
