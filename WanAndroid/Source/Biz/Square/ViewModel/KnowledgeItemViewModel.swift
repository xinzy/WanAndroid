//
//  KnowledgeItemViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/28.
//

import RxSwift

class KnowledgeItemViewModel: AutoDisposed {
    typealias FetchResult = (isRefresh: Bool, isEnd: Bool)

    private let item: SquareItem
    private var page = 0

    var articles: [Article] = []
    var resultSubject = PublishSubject<FetchResult>()

    private var isFirstPage: Bool { page == 0 }

    init(item: SquareItem) {
        self.item = item
    }

    func refresh() {
        page = 0
        loading()
    }

    func loading() {
        ApiHelper.fetchKnowledgeArticle(item.id, page).subscribe { [weak self] list in
            guard let `self` = self else { return }
            if self.isFirstPage {
                self.articles.removeAll()
            }
            self.articles.append(contentsOf: list.datas)
            self.resultSubject.onNext((isRefresh: self.isFirstPage, isEnd: list.over))
            self.page += 1
        }.disposed(by: disposeBag)
    }
}
