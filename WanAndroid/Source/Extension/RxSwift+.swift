//
//  RxSwift+.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/13.
//

import RxSwift

extension Observable {

    func subscribe(next: @escaping (Element) -> Void) -> Disposable {
        return subscribe { element in
            next(element)
        } onError: { error in
        } onCompleted: {
        } onDisposed: {
        }
    }
}
