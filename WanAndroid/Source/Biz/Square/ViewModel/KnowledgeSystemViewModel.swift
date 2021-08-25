//
//  KnowledgeSystemViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/20.
//

import RxSwift

class KnowledgeSystemViewModel: AutoDisposed {

    let loadingSubject = PublishSubject<Bool>()
    let loadedSubject = PublishSubject<Bool>()

    var chapters: [Chapter] = []

    func load() {
        loadingSubject.onNext(true)

        ApiHelper.fetchKnowledgeList().subscribe { [weak self] chapters in
            guard let `self` = self else { return }
            self.chapters = chapters
            self.loadingSubject.onNext(false)
            self.loadedSubject.onNext(true)
        }.disposed(by: disposeBag)
    }
}
