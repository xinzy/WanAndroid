//
//  WechatItemViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/19.
//

import RxSwift

class WechatItemViewModel: AutoDisposed {
    typealias LoadedAction = (isFirstPage: Bool, isEnd: Bool)

    let chapterId: Int
    var articles: [Article] = []
    var loadedSubject = PublishSubject<LoadedAction>()

    private var page: Int = 1

    init(chapterId: Int) {
        self.chapterId = chapterId
    }

    func refresh() {
        page = 1
        load()
    }

    func load() {
        ApiHelper.fetchWechatArticle(chapterId, page).subscribe { [weak self] list in
            guard let `self` = self else { return }

            if self.page == 1 {
                self.articles.removeAll()
            }
            self.articles.append(contentsOf: list.datas)
            self.page = list.curPage + 1
            self.loadedSubject.onNext((isFirstPage: list.curPage == 1, isEnd: list.over))
        }.disposed(by: disposeBag)
    }
}
