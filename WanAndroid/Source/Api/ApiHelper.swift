//
//  ApiHelper.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/12.
//

import RxSwift
import Alamofire
import HandyJSON

struct ApiHelper {

    // MARK: - 首页

    /// 首页banner
    static func fetchBanner() -> Observable<[Banner]> {
        return get(path: "banner/json", [Banner].self)
    }

    /// 首页置顶文章
    static func fetchTop() -> Observable<[Article]> {
        return get(path: "article/top/json", [Article].self)
    }

    /// 首页文章列表
    static func fetchHomeArticle(_ page: Int) -> Observable<List<Article>> {
        return get(path: "article/list/\(page)/json", List<Article>.self)
    }

    /// 热搜词汇
    static func fetctHotKeyword() -> Observable<[HotKey]> {
        return get(path: "hotkey/json", [HotKey].self)
    }

    /// 友情链接
    static func fetchFriend() -> Observable<[FriendLink]> {
        return get(path: "friend/json", [FriendLink].self)
    }

    // MARK: - 微信

    /// 获取微信列表
    static func fetchWechatList() -> Observable<[Chapter]> {
        return get(path: "wxarticle/chapters/json", [Chapter].self)
    }

    /// 微信文章列表
    static func fetchWechatArticle(_ chapterId: Int, _ page: Int, _ keyword: String? = nil) -> Observable<List<Article>> {
        let path = "wxarticle/list/\(chapterId)/\(page)/json"
        var param = [String: String]()

        if let k = keyword, k.isNotEmpty {
            param["k"] = k
        }
        return get(path: path, List<Article>.self, param)
    }

    // MARK: - 项目

    /// 获取项目分类
    static func fetchProjectList() -> Observable<[Chapter]> {
        return get(path: "project/tree/json", [Chapter].self)
    }

    /// 获取项目文章列表
    static func fetchProjectList(_ chapterId: Int, _ page: Int) -> Observable<List<Article>> {
        let path = "project/list/\(page)/json?cid=\(chapterId)"
        return get(path: path, List<Article>.self)
    }

    // MARK: - 体系

    /// 体系数据
    static func fetchKnowledgeList() -> Observable<[Chapter]> {
        let path = "tree/json"
        return get(path: path, [Chapter].self)
    }

    /// 获取体系下文章数据
    static func fetchKnowledgeArticle(_ chapterId: Int, _ page: Int) -> Observable<List<Article>> {
        let path = "article/list/\(page)/json?cid=\(chapterId)"
        return get(path: path, List<Article>.self)
    }

    // MARK: - 导航

    /// 导航数据
    static func fetchNaviList() -> Observable<[SiteNavigation]> {
        let path = "navi/json"
        return get(path: path, [SiteNavigation].self)
    }

    // MARK: - 搜索

    /// 搜索
    static func search(_ keyword: String, _ page: Int) -> Observable<List<Article>> {
        let param = ["k": keyword]
        let path = "article/query/\(page)/json"
        return post(path: path, List<Article>.self, param)
    }

    // MARK: - 用户

    /// 用户登录
    static func login(_ username: String, _ password: String) -> Observable<User> {
        let path = "user/login"
        let param = ["username": username, "password": password]
        return post(path: path, User.self, param, defaultValue: User())
    }

    /// 退出登录
    static func logout() -> Observable<Bool> {
        let path = "user/logout/json"
        return get(path: path)
    }

    /// 用户积分
    static func fetchScore() -> Observable<Score> {
        let path = "lg/coin/userinfo/json"
        return get(path: path, Score.self)
    }

    /// 用户积分历史
    static func fetchScoreHistory(_ page: Int) -> Observable<List<ScoreHistory>> {
        let path = "lg/coin/list/\(page)/json"
        return get(path: path, List<ScoreHistory>.self)
    }

    /// 积分排行
    static func fetchRank(_ page: Int) -> Observable<List<Score>> {
        let path = "coin/rank/\(page)/json"
        return get(path: path, List<Score>.self)
    }

    /// 收藏列表
    static func fetchFavor(_ page: Int) -> Observable<List<Favor>> {
        let path = "lg/collect/list/\(page)/json"
        return get(path: path, List<Favor>.self)
    }

    /// 收藏站内文章
    static func favor(_ id: Int) -> Observable<Bool> {
        let path = "lg/collect/\(id)/json"
        return post(path: path)
    }

    /// 收藏站外文章
    static func favor(title: String, author: String, link: String) -> Observable<Bool> {
        let param = ["title": title, "author": author, "link": link]
        let path = "lg/collect/add/json"
        return post(path: path, param)
    }

    /// 更新收藏
    static func favor(_ id: Int, title: String, author: String, link: String) -> Observable<Bool> {
        let param = ["title": title, "author": author, "link": link]
        let path = "lg/collect/user_article/update/\(id)/json"
        return post(path: path, param)
    }

    /// 取消收藏 文章列表中使用
    static func uncollect(idInList: Int) -> Observable<Bool> {
        let path = "lg/uncollect_originId/\(idInList)/json"
        let param = ["id": idInList]
        return post(path: path, param)
    }

    /// 取消收藏  收藏列表中使用
    static func uncollect(idInFavor: Int, _ originId: Int = -1) -> Observable<Bool> {
        let path = "lg/uncollect/\(idInFavor)/json"
        let param = ["id": idInFavor, "originId": originId]
        return post(path: path, param)
    }
}

extension ApiHelper {
    private static let BASE_URL = "https://www.wanandroid.com"

    private static func get<T>(path: String, _ type: T.Type, _ params: Parameters? = nil, defaultValue: T = T.init()) -> Observable<T> where T: HandyJSON {
        let url = "\(BASE_URL)/\(path)"
        return ApiUtils.get(url: url, ApiResult<T>.self, params).map { $0.data ?? defaultValue }
    }

    private static func post<T>(path: String, _ type: T.Type, _ params: Parameters? = nil, defaultValue: T = T.init()) -> Observable<T> where T: HandyJSON {
        let url = "\(BASE_URL)/\(path)"
        return ApiUtils.post(url: url, ApiResult<T>.self, params).map { $0.data ?? defaultValue }
    }

    private static func get(path: String, _ params: Parameters? = nil) -> Observable<Bool> {
        let url = "\(BASE_URL)/\(path)"
        return ApiUtils.get(url: url, ApiResult<Any>.self, params).map { $0.isSuccess }
    }

    private static func post(path: String, _ params: Parameters? = nil) -> Observable<Bool> {
        let url = "\(BASE_URL)/\(path)"
        return ApiUtils.post(url: url, ApiResult<Any>.self, params).map { $0.isSuccess }
    }
}

extension Array: HandyJSON { }
