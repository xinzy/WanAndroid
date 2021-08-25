//
//  Cell+.swift
//  Component
//
//  Created by Yang on 2021/2/2.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String {
        "\(self)"
    }
}

public extension UITableView {

    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: T.identifier)
    }

    func register<T: UITableViewCell>(withCellRegister type: T.Type) where T: CellRegister {
        guard let nib = T.nib else {
            fatalError("\(self) expected has a nib file")
        }
        register(nib, forCellReuseIdentifier: T.cellIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

    func dequeueReusableCell<T: UITableViewCell>(withCellRegister indexPath: IndexPath) -> T where T: CellRegister {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
    }

    func reloadRow(_ indexPath: IndexPath, with animation: RowAnimation = .automatic) {
        reloadRows(at: [indexPath], with: animation)
    }

    func reloadRow(row: Int, section: Int = 0, with animation: RowAnimation = .automatic) {
        reloadRow(IndexPath(row: row, section: section), with: animation)
    }

    func reloadSection(_ section: Int, with animation: RowAnimation = .automatic) {
        reloadSections(IndexSet(integer: section), with: animation)
    }

    func insertRow(_ indexPath: IndexPath, with animation: RowAnimation = .automatic) {
        insertRows(at: [indexPath], with: animation)
    }

    func insertRow(row: Int, section: Int = 0, with animation: RowAnimation = .automatic) {
        insertRow(IndexPath(row: row, section: section), with: animation)
    }

    func insertSection(_ section: Int, with animation: RowAnimation = .automatic) {
        insertSections(IndexSet(integer: section), with: animation)
    }

    func deleteRow(_ indexPath: IndexPath, with animation: RowAnimation = .automatic) {
        deleteRows(at: [indexPath], with: animation)
    }

    func deleteRow(row: Int, section: Int = 0, with animation: RowAnimation = .automatic) {
        deleteRow(IndexPath(row: row, section: section), with: animation)
    }

    func deleteSection(_ section: Int, with animation: RowAnimation = .automatic) {
        deleteSections(IndexSet(integer: section), with: animation)
    }
}

public extension UITableViewCell {
    func clearBackground() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}
