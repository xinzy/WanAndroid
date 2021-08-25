//
//  FavorViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/8/23.
//

import RxSwift

class FavorViewModel: MineBaseListViewModel<Favor> {

    let uncollectSubject = PublishSubject<IndexPath>()

    override var firstPage: Int { 0 }
    
    override var fetchApi: ((Int) -> Observable<List<Favor>>) {
        ApiHelper.fetchFavor(_:)
    }

    func uncollect(_ indexPath: IndexPath) {
        let favor = dataSource[indexPath.row]
        ApiHelper.uncollect(idInFavor: favor.id, favor.originId).subscribe { [weak self] b in
            guard let `self` = self else { return }
            self.dataSource.remove(at: indexPath.row)
            self.uncollectSubject.onNext(indexPath)
        }.disposed(by: disposeBag)
    }
}
