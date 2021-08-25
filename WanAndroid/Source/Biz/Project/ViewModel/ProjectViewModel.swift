//
//  ProjectViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/19.
//

import RxSwift

class ProjectViewModel: AutoDisposed {
    var chapters: [Chapter] = []

    let loadedSubject = PublishSubject<[String]>()

    func load() {
        ApiHelper.fetchProjectList().subscribe { [weak self] chapters in
            guard let `self` = self else { return }
            self.chapters = chapters
            self.loadedSubject.onNext(chapters.map { $0.displayName })
        }.disposed(by: disposeBag)
    }
}
