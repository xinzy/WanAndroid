//
//  ApiResult.swift
//  Wan
//
//  Created by Yang on 2021/2/4.
//

import Foundation
import HandyJSON

struct ApiResult<T> {
    var code: Int = 0
    var message: String = ""
    var data: T?

    var isSuccess: Bool {
        code == 0
    }
}

extension ApiResult: HandyJSON {

    mutating func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &code, name: "errorCode")
        mapper.specify(property: &message, name: "errorMsg")
    }
}
