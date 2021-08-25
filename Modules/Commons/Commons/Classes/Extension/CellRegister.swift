//
//  CellRegister.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public protocol CellRegister {

    static var cellIdentifier: String { get }

    static var nib: UINib? { get }
}

public extension CellRegister {

    static var cellIdentifier: String {
        "\(self)"
    }

    static var nib: UINib? {
        UINib(nibName: Self.cellIdentifier, bundle: nil)
    }
}

public protocol NibLoadable: AnyObject {

    static var nib: UINib { get}
}

public extension NibLoadable {

    static var nib: UINib {
        UINib(nibName: "\(self)", bundle: Bundle(for: self))
    }
}

public extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

protocol StoryboardLoadable {
    static var storyboard: UIStoryboard { get }
}

extension StoryboardLoadable {
    static var storyboard: UIStoryboard {
        UIStoryboard(name: String(describing: self), bundle: nil)
    }
}

extension StoryboardLoadable where Self: UIViewController {
    static func loadFromStoryboard() -> Self {
        guard let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            fatalError("")
        }
        return controller
    }
}
