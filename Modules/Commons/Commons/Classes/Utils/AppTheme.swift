//
//  AppTheme.swift
//  Themes
//
//  Created by Yang on 2021/7/7.
//

import UIKit


@available(iOS 13.0, *)
public class ThemeManager {
    private static let keyUseSystemTheme = "keyUseSystemTheme"
    private static let keyThemeMode = "keyThemeMode"
    public static let shared: ThemeManager = ThemeManager()

    public var isSystemTheme: Bool {
        get { UserDefaults.standard.value(forKey: Self.keyUseSystemTheme) as? Bool ?? true }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.keyUseSystemTheme)
            changeThemeWithAnimation(newValue ? .unspecified : currentTheme)
        }
    }

    public var currentTheme: UIUserInterfaceStyle {
        isSystemTheme ? .unspecified : userTheme
    }

    public var userTheme: UIUserInterfaceStyle {
        UIUserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: Self.keyThemeMode)) ?? .light
    }

    public func setTheme(_ style: UIUserInterfaceStyle) {
        if currentTheme == style { return }
        UserDefaults.standard.setValue(style.rawValue, forKey: Self.keyThemeMode)
        changeThemeWithAnimation(style)
    }

    private func changeThemeWithAnimation(_ style: UIUserInterfaceStyle) {
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: animationDuration, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = style
        }
    }
}
