//
//  HomeViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/13.
//

import RxSwift

class HomeViewModel: AutoDisposed {
    typealias FetchResult = (isRefresh: Bool, isEnd: Bool)

    var banners = [Banner]()
    var articles = [Article]()

    var loadedSubject = PublishSubject<FetchResult>()

    private var page: Int = 0

    func refresh() {
        page = 0
        Observable.zip(ApiHelper.fetchBanner(), ApiHelper.fetchTop(), ApiHelper.fetchHomeArticle(page))
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (banners, articles, list) in
                guard let `self` = self else { return }
                self.banners = banners
                self.articles.removeAll()
                self.articles.append(contentsOf: articles)
                self.articles.append(contentsOf: list.datas)
                self.page = list.curPage

                self.loadedSubject.onNext((true, list.over))
            })
            .disposed(by: disposeBag)
    }

    func load() {
        ApiHelper.fetchHomeArticle(page).subscribe(onNext: { [weak self] list in
            guard let `self` = self else { return }
            self.page = list.curPage

            self.articles.append(contentsOf: list.datas)
            self.loadedSubject.onNext((true, list.over))
        }).disposed(by: disposeBag)
    }
}
