//
//  DateFormatter.swift
//  GithubChat
//
//  Created by ShihTing on 2019/02/01.
//  Copyright © 2019 STH. All rights reserved.
//

import Foundation

/// A formatter with style "Fri 12:00"
struct WeekDateTimeFormatter {
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE hh:mm"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
