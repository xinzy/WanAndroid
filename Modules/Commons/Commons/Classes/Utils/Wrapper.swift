//
//  NumberWrapper.swift
//  Commons
//
//  Created by Yang on 2021/9/1.
//

import Foundation

@propertyWrapper
public struct RangeValueWrapper<T: Comparable> {
    private var value: T

    private var range: ClosedRange<T>
    private var defaultValue: T?

    public init(range: ClosedRange<T>, defaultValue: T? = nil) {
        self.range = range
        self.defaultValue = defaultValue
        self.value = defaultValue ?? range.upperBound
    }

    public var wrappedValue: T {
        get { value }
        set {
            if range.contains(newValue) {
                value = newValue
            } else {
                value = defaultValue ?? range.upperBound
            }
        }
    }
}
