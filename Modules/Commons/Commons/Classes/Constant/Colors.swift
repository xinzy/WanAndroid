//
//  Colors.swift
//  Commons
//
//  Created by Yang on 2021/8/25.
//

import UIKit

public struct Colors {

    public static var navigationTint: UIColor { color("tintNavigation") }

    public static var tabbarTint: UIColor { color("tintTabbar") }

    public static var separator: UIColor { color("separator") }

    /// 背景色
    public static var backgroundPrimary: UIColor { color("backgroundPrimary") }

    /// Cell 背景色
    public static var backgroundSecondary: UIColor { color("backgroundSecondary") }

    /// 标题颜色
    public static var textPrimary: UIColor { color("textPrimary") }

    /// 正文颜色
    public static var textSecondary: UIColor { color("textSecondary") }

    /// 说明颜色
    public static var textInfo: UIColor { color("textInfo") }

    /// 禁用颜色
    public static var textHint: UIColor { color("textHint") }

    /// 黑色反色卡片      light: #1212630 dark: #FFFFFF
    static var black_card: UIColor { color("black_card") }

    /// 白色卡片背景      light: #FFFFFF dark: #1212630
    static var white_card: UIColor { color("white_card") }


    // MARK: - 中性色

    /// 白色卡片，在深色模式下反转       light: #FFFFFF dark: #191E26
    static var bluegrey_00: UIColor { color("bluegrey_00") }

    /// 页面内淡灰色背景    light: #F7F8F9 dark: #262C36
    static var bluegrey_05: UIColor { color("bluegrey_05") }

    /// 淡灰色页面背景     light: #F7F8F9 dark: #0B1117
    static var bluegrey_50: UIColor { color("bluegrey_05") }

    /// 3级按钮，分割线颜色      light: #F2F3F4 dark: #262D38
    static var bluegrey_100: UIColor { color("bluegrey_100") }

    /// 边框颜色        light: #E4E6E8 dark: #2D3440
    static var bluegrey_300: UIColor { color("bluegrey_300") }

    /// 禁用文字颜色      light: #B7BBBF dark: #4D5666
    static var bluegrey_500: UIColor { color("bluegrey_500") }

    /// 描述和说明文字颜色   light: #81858C dark: #707C8C
    static var bluegrey_700: UIColor { color("bluegrey_700") }

    /// 正文颜色    light: #4E5359 dark: #A3AFBF
    static var bluegrey_800: UIColor { color("bluegrey_800") }

    /// 标题和重点文字颜色   light: #1D2126 dark: #E2ECFA
    static var bluegrey_900: UIColor { color("bluegrey_900") }


    //MARK: - 彩色

    //
    // 100: 页面内浅色背景元素
    // 500: 页面内彩色元素背景
    // 600: 页面内彩色文字
    //

    // light: #EDF4FF dark: #213452
    public static var blue_100: UIColor { color("blue_100") }

    // light: #CCE0FF dark: #324563
    public static var blue_200: UIColor { color("blue_200") }

    // light: #4F94FF dark: #6B99DE
    public static var blue_500: UIColor { color("blue_500") }

    // light: #1970F2 dark: #7FA6E2
    public static var blue_600: UIColor { color("blue_600") }

    // light: #FFFCD4 dark: #424035
    public static var brand_100: UIColor { color("brand_100") }

    // light: #FFD630 dark: #FFD630
    public static var brand_500: UIColor { color("brand_500") }

    // light: #F2C121 dark: #D9B629
    public static var brand_600: UIColor { color("brand_600") }

    // light: #E1F9FA dark: #233738
    public static var cyan_100: UIColor { color("cyan_100") }

    // light: #00D1D9 dark: #5DC3C6
    public static var cyan_500: UIColor { color("cyan_500") }

    // light: #00B9BF dark: #6DD1D4
    public static var cyan_600: UIColor { color("cyan_600") }

    // light: #E8F7F0 dark: #203A32
    public static var green_100: UIColor { color("green_100") }

    // light: #00CC66 dark: #61BA8D
    public static var green_500: UIColor { color("green_500") }

    // light: #00B058 dark: #71C99D
    public static var green_600: UIColor { color("green_600") }

    // light: #FFF0DB dark: #3C3325
    public static var orange_100: UIColor { color("orange_100") }

    // light: #FFA319 dark: #E6A15C
    public static var orange_500: UIColor { color("orange_500") }

    // light: #FF8C00 dark: #F2AF6C
    public static var orange_600: UIColor { color("orange_600") }

    // light: #F2F0FD dark: #343146
    public static var purple_100: UIColor { color("purple_100") }

    // light: #8C79F2 dark: #8C79F2
    public static var purple_500: UIColor { color("purple_500") }

    // light: #6A54E0 dark: #988BDC
    public static var purple_600: UIColor { color("purple_600") }

    // light: #FFEDED dark: #3D2929
    public static var red_100: UIColor { color("red_100") }

    // light: #FF6666 dark: #DA7171
    public static var red_500: UIColor { color("red_600") }

    // light: #EB3B3B dark: #E48484
    public static var red_600: UIColor { color("red_600") }

    // light: #FFEDE5 dark: #3E322E
    public static var redorange_100: UIColor { color("redorange_100") }

    // light: #FF6D2E dark: #DA825E
    public static var redorange_500: UIColor { color("redorange_500") }

    // light: #FF4D00 dark: #E69472
    public static var redorange_600: UIColor { color("redorange_600") }

    private static func color(_ name: String) -> UIColor {
        UIColor(named: name, in: currentBundle, compatibleWith: nil)!
    }
}
