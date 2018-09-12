//
//  TimeFormatHelper.swift
//  NewsReader
//
//  Created by Florian Marcu on 3/28/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation

class TimeFormatHelper {
    static func timeAgoString(date: Date) -> String {
        let secondsInterval = Date().timeIntervalSince(date).rounded()
        if (secondsInterval < 10) {
            return "now"
        }
        if (secondsInterval < 60) {
            return String(Int(secondsInterval)) + " seconds ago"
        }
        let minutes = (secondsInterval / 60).rounded()
        if (minutes < 60) {
            return String(Int(minutes)) + " minutes ago"
        }
        let hours = (minutes / 60).rounded()
        if (hours < 24) {
            return String(Int(hours)) + " hours ago"
        }
        let days = (hours / 60).rounded()
        if (days < 30) {
            return String(Int(days)) + " days ago"
        }
        let months = (days / 30).rounded()
        if (months < 12) {
            return String(Int(months)) + " months ago"
        }
        let years = (months / 12).rounded()
        return String(Int(years)) + " years ago"
    }

    static func string(for date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func chatString(for date: Date) -> String {
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date) {
            return self.string(for: date, format: "HH:mm")
        }
        return self.string(for: date, format: "MMM dd")
    }
}
