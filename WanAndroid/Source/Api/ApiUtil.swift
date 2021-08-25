//
//  ApiHelper.swift
//  WanAndroid
//
//  Created by Yang on 2021/7/12.
//

import RxSwift
import HandyJSON
import Alamofire

enum RequestError: Error {
    case notLogin
    case network
    case unknow

    static let codeNotLogin = -1001
}

struct ApiUtils {

    private static func httpRequest<T: HandyJSON>(url: URLConvertible, _ method: HTTPMethod = .get, _ type: T.Type, observer: AnyObserver<T>, params: Parameters? = nil) {
        AF.request(url, method: method, parameters: params).responseString { response in
            switch response.result {
            case .success(let content):
                if let result = JSONDeserializer<T>.deserializeFrom(json: content) {
                    observer.onNext(result)
                } else {
                    observer.onError(RequestError.network)
                }
            case .failure:
                observer.onError(RequestError.network)
            }
            observer.onCompleted()
        }
    }
}

extension ApiUtils {

    /// Get 请求
    static func get<T: HandyJSON>(url: URLConvertible, _ type: T.Type, _ params: Parameters? = nil) -> Observable<T> {
        return Observable<T>.create { (observer: AnyObserver<T>) -> Disposable in
            httpRequest(url: url, .get, type, observer: observer, params: params)
            return Disposables.create()
        }.subscribe(on: MainScheduler.instance)
    }

    /// Post 请求
    static func post<T: HandyJSON>(url: URLConvertible, _ type: T.Type, _ params: Parameters? = nil) -> Observable<T> {
        return Observable<T>.create { (observer: AnyObserver<T>) -> Disposable in
            httpRequest(url: url, .post, type, observer: observer, params: params)
            return Disposables.create()
        }.subscribe(on: MainScheduler.instance)
    }

    /// Put 请求
    static func put<T: HandyJSON>(url: URLConvertible, _ type: T.Type, _ params: Parameters? = nil) -> Observable<T> {
        return Observable<T>.create { (observer: AnyObserver<T>) -> Disposable in
            httpRequest(url: url, .put, type, observer: observer, params: params)
            return Disposables.create()
        }.subscribe(on: MainScheduler.instance)
    }

    /// Delete 请求
    static func delete<T: HandyJSON>(url: URLConvertible, _ type: T.Type, _ params: Parameters? = nil) -> Observable<T> {
        return Observable<T>.create { (observer: AnyObserver<T>) -> Disposable in
            httpRequest(url: url, .delete, type, observer: observer, params: params)
            return Disposables.create()
        }.subscribe(on: MainScheduler.instance)
    }
}
