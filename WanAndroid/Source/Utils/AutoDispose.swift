//
//  AutoDispose.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/16.
//

import RxSwift

protocol AutoDisposed {
    var disposeBag: DisposeBag { get }
}

private var DisposeBagKey = "DisposeBagKey"
extension AutoDisposed {
    var disposeBag: DisposeBag {
        get {
            if let bag = objc_getAssociatedObject(self, &DisposeBagKey) as? DisposeBag { return bag }
            let bag = DisposeBag()
            objc_setAssociatedObject(self, &DisposeBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return bag
        }
    }
}
