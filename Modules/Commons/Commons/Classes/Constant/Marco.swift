//
//  Marco.swift
//  Component
//
//  Created by Yang on 2021/2/24.
//

import Foundation
import UIKit

/// 屏幕边框
public let ScreenBounds: CGRect = UIScreen.main.bounds

/// 屏幕尺寸
public let ScreenSize: CGSize = ScreenBounds.size

/// 屏幕宽度
public let ScreenWidth: CGFloat = ScreenSize.width

/// 屏幕高度
public let ScreenHeight: CGFloat = ScreenSize.height

public let horizontalPadding: CGFloat = 16

public let verticalPadding: CGFloat = 12

/// 是否是全面屏设备
public var isFullScreen: Bool {
    guard let window = UIApplication.shared.keyWindow else {
        return false
    }
    return window.safeAreaInsets.bottom > 0
}

/// 状态栏高度
public var statusBarHeight: CGFloat {
    UIApplication.shared.statusBarFrame.height
}

/// 设备底部高度
public var safeAreaBottom: CGFloat {
    UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
}

// 动画时长
let animationDuration: TimeInterval = 0.35
