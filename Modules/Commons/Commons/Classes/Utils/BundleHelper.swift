//
//  UIColor+.swift
//  Themes
//
//  Created by Yang on 2021/7/6.
//

import UIKit

private class BundleFetcher { }

var currentBundle: Bundle {
    let path = Bundle(for: BundleFetcher.self).path(forResource: "Commons", ofType: "bundle")!
    return Bundle(path: path)!
}
