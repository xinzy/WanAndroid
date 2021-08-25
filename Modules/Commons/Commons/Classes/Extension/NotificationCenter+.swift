//
//  NotificationCenter+.swift
//  Component
//
//  Created by Yang on 2021/2/3.
//

import Foundation

public extension NotificationCenter {

    func post(name notificationName: String) {
        post(Notification(name: Notification.Name(rawValue: notificationName)))
    }

    func post(name notificationName: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        post(Notification(name: Notification.Name(rawValue: notificationName), object: object, userInfo: userInfo))
    }
}
