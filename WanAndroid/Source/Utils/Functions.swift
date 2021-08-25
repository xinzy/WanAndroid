//
//  Functions.swift
//  Wan
//
//  Created by Yang on 2021/2/5.
//

import Commons

func filterHtmlTag(_ input: String) -> String {
    let dict = [
        "&ldquo;" : "“",
        "&rdquo;" : "”",
        "&mdash;" : "-",
        "&nbsp;" : " ",
        "&quot;":"\"",
        "&lt;" : "<",
        "&gt;" : ">",
        "&amp;" : "&",
        "&apos;" : "'",
        "&cent;" : "￠",
        "&pound;" : "£",
        "&yen;" : "¥",
        "&euro;" : "€",
        "&#167;" : "§",
        "&copy;" : "©",
        "&reg;" : "®",
        "&trade;" : "™",
        "&times;" : "×",
        "&divide;" : "÷",
    ]
    return input.replaceAll(dict)
}

/// 格式化时间
func formatTime(millisecond: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(millisecond / 1000))
    return date.niceTime
}
