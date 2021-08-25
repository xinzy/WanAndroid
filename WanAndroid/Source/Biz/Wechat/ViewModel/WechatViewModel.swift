//
//  WechatViewModel.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/16.
//

import RxSwift

class WechatViewModel: AutoDisposed {
    var chapters: [Chapter] = []

    let chapterSubject = PublishSubject<[String]>()

    func loadWechatList() {
        ApiHelper.fetchWechatList().subscribe { [weak self] chapters in
            guard let `self` = self else { return }
            self.chapters = chapters
            self.chapterSubject.onNext(chapters.map { $0.displayName })
        }.disposed(by: disposeBag)
    }
}
