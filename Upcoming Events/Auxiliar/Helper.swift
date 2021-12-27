//
//  Helper.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import Foundation

extension Formatter {
    static let customDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        return dateFormatter
    }()
    
    static let customDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }()
}

extension Date {
    var day: Int? {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day
    }
    
    var hour: Int? {
        let components = Calendar.current.dateComponents([.hour], from: self)
        return components.hour
    }
    
    var minute: Int? {
        let components = Calendar.current.dateComponents([.minute], from: self)
        return components.minute
    }
}
