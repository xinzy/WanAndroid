//
//  BannerView.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/12.
//

import UIKit
import SnapKit
import Commons
import Kingfisher

class BannerView: UIView {
    var onItemClick: ((BannerView, Int, Banner) -> Void)?

    var banners: [Banner] = [] {
        didSet {
            suspendTimer()

            collectionView.reloadData()
            pageControl.numberOfPages = banners.count
            pageControl.currentPage = 0

            resumeTimer()
        }
    }

    private var isSuspended = true
    private lazy var timer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource(queue: .global())
        timer.schedule(deadline: .now(), repeating: 3)
        timer.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.handCountdown()
            }
        }
        return timer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    deinit {
        releaseTimer()
    }

    private func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    @objc private func onPageChanged(_ control: UIPageControl) {
        collectionView.scrollToItem(at: IndexPath(row: control.currentPage, section: 0), at: .left, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = Colors.textHint
        control.currentPageIndicatorTintColor = Colors.brand_600
        control.addTarget(self, action: #selector(onPageChanged(_:)), for: .valueChanged)
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(BannerCell.self)
        view.dataSource = self
        view.delegate = self
        return view
    }()
}

extension BannerView {
    private func handCountdown() {
        var index = pageControl.currentPage
        index = index >= banners.count - 1 ? 0 : index + 1
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
    }

    private func suspendTimer() {
        if isSuspended { return }
        isSuspended = true
        timer.suspend()
    }

    private func resumeTimer() {
        if !isSuspended { return }
        isSuspended = false
        timer.resume()
    }

    private func releaseTimer() {
        resumeTimer()
        timer.cancel()
    }
}

extension BannerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerCell = collectionView.dequeueReusableCell(indexPath)
        cell.banner = banners[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemClick?(self, indexPath.row, banners[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffsetX / scrollView.width)
        pageControl.currentPage = index
    }
}

private class BannerCell: UICollectionViewCell {
    var banner: Banner = Banner() {
        didSet {
            imageView.kf.setImage(with: URL(string: banner.imagePath))
            label.text = banner.title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        clearBackground()
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        gradientView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(24)
            make.trailing.equalTo(-24)
            make.centerY.equalToSuperview()
        }
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var gradientView: UIView = {
        let view = UIView()
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.4).cgColor]
        layer.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 44)
        view.layer.addSublayer(layer)
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
}
