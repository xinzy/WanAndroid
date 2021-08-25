//
//  UITableView+.swift
//  Themes
//
//  Created by Yang on 2021/7/8.
//

import UIKit
import MJRefresh

public extension UIScrollView {
    typealias RefreshingAction = () -> Void

    var isRefreshFooterHidden: Bool {
        get { mj_footer?.isHidden ?? true }
        set { mj_footer?.isHidden = newValue }
    }

    func addRefreshHeader(_ block: @escaping RefreshingAction) {
        mj_header = BallRefreshHeaderView(refreshingBlock: block)
    }

    func addRefreshHeader(_ target: Any, _ action: Selector) {
        mj_header = BallRefreshHeaderView(refreshingTarget: target, refreshingAction: action)
    }

    func addRefreshFooter(_ block: @escaping RefreshingAction) {
        mj_footer = BallRefreshFooterView(refreshingBlock: block)
    }

    func addRefreshFooter(_ target: Any, _ action: Selector) {
        mj_footer = BallRefreshFooterView(refreshingTarget: target, refreshingAction: action)
    }

    func refresh() {
        mj_header?.beginRefreshing()
    }

    func loadMore() {
        mj_footer?.beginRefreshing()
    }

    func endRefresh() {
        mj_header?.endRefreshing()
    }

    func endLoadMore(_ end: Bool = false) {
        mj_footer?.state = end ? .noMoreData : .idle
    }
}
