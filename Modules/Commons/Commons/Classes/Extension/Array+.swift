//
//  Array+Extension.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import Foundation

public extension Array {

    subscript(safe at: Int) -> Element? {
        at >= count ? nil : self[at]
    }

    var isNotEmpty: Bool {
        !isEmpty
    }

    func forEach(_ body: (Int, Element) throws -> Void) rethrows {
        for (index, item) in enumerated() {
            try body(index, item)
        }
    }
}
