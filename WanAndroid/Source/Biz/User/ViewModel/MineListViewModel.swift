//
//  MineViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import RxSwift
import HandyJSON

class MineBaseListViewModel<T: HandyJSON>: AutoDisposed {
    typealias FetchResult = (isRefresh: Bool, isEnd: Bool)

    var resultSubject = PublishSubject<FetchResult>()
    var dataSource: [T] = []

    var fetchApi: ((_ page: Int) -> Observable<List<T>>) {
        get { fatalError("Sub Class should be override") }
    }
    var firstPage: Int { 1 }

    private var page = 1
    private var isFirstPage: Bool { page == firstPage }

    required init() { }

    func refresh() {
        page = firstPage
        load()
    }

    func load() {
        fetchApi(page).subscribe { [weak self] list in
            guard let `self` = self else { return }
            let isFirstPage = self.isFirstPage
            if isFirstPage {
                self.dataSource.removeAll()
            }
            self.dataSource.append(contentsOf: list.datas)
            self.page += 1
            self.resultSubject.onNext((isFirstPage, list.over))
        }.disposed(by: disposeBag)
    }
}

// MARK: - 排行榜
class RankViewModel: MineBaseListViewModel<Score> {

    override var fetchApi: ((Int) -> Observable<List<Score>>) {
        ApiHelper.fetchRank(_:)
    }
}

// MARK: - 积分记录
class ScoreHistoryViewModel: MineBaseListViewModel<ScoreHistory> {

    override var fetchApi: ((Int) -> Observable<List<ScoreHistory>>) {
        ApiHelper.fetchScoreHistory(_:)
    }
}
