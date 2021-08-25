//
//  UICollectionView+.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public extension UICollectionReusableView {
    static var identifier: String {
        "\(self)"
    }
}

public extension UICollectionViewCell {
    func clearBackground() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

public extension UICollectionView {

    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: T.identifier)
    }

    func register<T: UICollectionViewCell>(withCellRegister type: T.Type) where T: CellRegister {
        guard let nib = T.nib else {
            fatalError("\(self) expected has a nib file")
        }
        register(nib, forCellWithReuseIdentifier: T.cellIdentifier)
    }

    func register<T: UICollectionReusableView>(_ type: T.Type, forSupplementaryViewOfKind: String) {
        register(T.classForCoder(), forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withCellRegister indexPath: IndexPath) -> T where T: CellRegister {
        return dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as! T
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, _ indexPath: IndexPath, forKind: String) -> T {
        return dequeueReusableSupplementaryView(ofKind: forKind, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

    func reloadItem(at indexPath: IndexPath) {
        reloadItems(at: [indexPath])
    }

    func reloadItem(row: Int, section: Int = 0) {
        reloadItem(at: IndexPath(row: row, section: section))
    }

    func reloadSection(at section: Int) {
        reloadSections(IndexSet(integer: section))
    }

    func insertItem(_ indexPath: IndexPath) {
        insertItems(at: [indexPath])
    }

    func insertItem(row: Int, section: Int = 0) {
        insertItem(IndexPath(row: row, section: section))
    }

    func insertSection(_ section: Int) {
        insertSections(IndexSet(integer: section))
    }

    func deleteItem(_ indexPath: IndexPath) {
        deleteItems(at: [indexPath])
    }

    func deleteItem(row: Int, section: Int = 0) {
        deleteItem(IndexPath(row: row, section: section))
    }

    func deleteSection(_ section: Int) {
        deleteSections(IndexSet(integer: section))
    }
}
