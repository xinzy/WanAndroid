//
//  Functions.swift
//  Commons
//
//  Created by Yang on 2021/8/27.
//

import Foundation

public func synchronized(_ lock: AnyObject, block: () throws -> Void) rethrows {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    try block()
}
