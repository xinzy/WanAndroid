//
//  MediaSelectionController.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import UIKit
import SnapKit
import Photos

public class MediaSelectionController: UIViewController {

//    private let viewModel: MediaSelectionViewModels

    private let configuration: MediaSelectedConfiguration

    init(configuration: MediaSelectedConfiguration) {
        self.configuration = configuration
//        self.viewModel = MediaSelectionViewModel(configuration: configuration)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "最近项目"
        view.backgroundColor = Colors.backgroundPrimary
        setupView()
        loadAlbum()
    }

    private lazy var bottomBar: MediaSelectionBottomBar = {
        let bar = MediaSelectionBottomBar()
        return bar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var cancelBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))
        return item
    }()

    private lazy var albumTitleView: EmbedAlbumTitleView = {
        let titleView = EmbedAlbumTitleView()
        titleView.selectedChangedAction = self.onEmbedAlbumAction(_:)
        titleView.title = "默认相册"
        return titleView
    }()

    private lazy var embedAlbumListView: EmbedAlbumListView = {
        let view = EmbedAlbumListView()
        view.isHidden = true
        return view
    }()
}

extension MediaSelectionController {

    private func setupView() {

        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
            make.bottom.equalTo(-safeAreaBottom)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }

        if configuration.albumStyle == .embed {
            navigationItem.titleView = albumTitleView
            navigationItem.leftBarButtonItem = cancelBarItem

            view.addSubview(embedAlbumListView)
            embedAlbumListView.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(collectionView)
                make.bottom.equalToSuperview()
            }
        }
    }

    private func onEmbedAlbumAction(_ selectAlbum: Bool) {
        selectAlbum ? embedAlbumListView.show() : embedAlbumListView.hide()
    }

    @objc private func cancelClick() {
        navigationController?.dismiss(animated: true)
    }
}

extension MediaSelectionController {
    private func loadAlbum() {
        checkPermission { [weak self] in
            guard let `self` = self else { return }
            
            MediaSelectionManager.getAlbums(config: self.configuration) { [weak self] albums in
                guard let `self` = self else { return }
                if self.configuration.albumStyle == .embed {
                    self.albumTitleView.title = albums.first?.title ?? ""
                    self.embedAlbumListView.data = albums
                }
            }
        }
    }

    private func checkPermission(_ block: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let `self` = self else { return }
            switch status {
            case .denied: fallthrough
            case .restricted:
                let controller = UIAlertController(title: "暂无权限", message: "App需要访问您的相册权限，请到设置里打开", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in

                }))
                controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self.present(controller, animated: true)
            case .limited: fallthrough
            case .authorized:
                block()
            default: break
            }
        }
    }
}
