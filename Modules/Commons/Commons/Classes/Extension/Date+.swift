//
//  Date+.swift
//  Commons
//
//  Created by Yang on 2021/5/7.
//

import Foundation

public extension Date {

    /// 获取日程通用 DateComponents
    static func defaultDateComponents() -> DateComponents {
        var components = DateComponents()
        components.timeZone = .current
        components.calendar = Calendar.current
        return components
    }

    /// 格式化
    var niceTime: String {
        let delta = Date().timeIntervalSince1970 - timeIntervalSince1970
        if delta < 60 {
            return "刚刚"
        }
        var time = delta / 60
        if time < 60 {
            return "\(Int(time))分钟前"
        }
        time /= 60
        if time < 24 {
            return "\(Int(time))小时前"
        }
        time /= 24
        if time < 30 {
            return "\(Int(time))天前"
        }
        return format(format: "yyyy-MM-dd")
    }

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }

    var second: Int {
        Calendar.current.component(.second, from: self)
    }

    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    var weekString: String {
        return ["周日", "周一", "周二", "周三", "周四", "周五", "周六"][weekday - 1]
    }

    var timestamp: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }

    // 是否是闰年
    var isLeapYear: Bool {
        let year = self.year
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }

    var isToday: Bool {
        if fabs(self.timeIntervalSinceNow) > 24 * 60 * 60 {
            return false
        }
        return Date().day == self.day
    }

    var isThisYear: Bool {
        return Date().year == self.year
    }

    /// 一个月的开始时间，如：2019-09-01 00:00:00
    var monthBegin: Date {
        var components = Date.defaultDateComponents()
        components.year = self.year
        components.month = self.month
        return Calendar.current.date(from: components) ?? self
    }

    /// 一个月的结束时间，如：2019-09-31 23:59:59
    var monthEnd: Date {
        var components = Date.defaultDateComponents()
        components.year = self.year
        components.month = self.month
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Calendar.current.date(from: components) ?? self) ?? self
        return nextMonth.addingTimeInterval(-1)
    }

    /// 一天的开始时间，如：2019-09-11 00:00:00
    var dayBegin: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /// 一天的结束时间，如：2019-09-11 23:59:59
    var dayEnd: Date {
        var components = Date.defaultDateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(from: components) ?? self
    }

    /// 一个小时的开始时间，如：2019-09-01 08:00:00
    var hourBegin: Date {
        var components = Date.defaultDateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        components.hour = self.hour
        return Calendar.current.date(from: components) ?? self
    }

    /// 一个小时的结束时间，如：2019-09-31 23:59:59
    var hourEnd: Date {
        var components = Date.defaultDateComponents()
        components.year = self.year
        components.month = self.month
        components.day = self.day
        components.hour = self.hour
        let nextHour = Calendar.current.date(byAdding: .hour, value: 1, to: Calendar.current.date(from: components) ?? self) ?? self
        return nextHour.addingTimeInterval(-1)
    }

    func isSameDay(_ other: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: other)
    }

    func format(format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current

        return formatter.string(from: self)
    }

    func dateByAdding(year: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: year, to: self) ?? self
    }

    func dateByAdding(month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: self) ?? self
    }

    func dateByAdding(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: self) ?? self
    }

    func dateByAdding(hour: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hour, to: self) ?? self
    }

    func dateByAdding(minute: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minute, to: self) ?? self
    }
}
