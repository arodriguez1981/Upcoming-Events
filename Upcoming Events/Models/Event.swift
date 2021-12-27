//
//  Event.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import Foundation

class Event: Codable{
    var title : String!
    var start: Date!
    var end: Date!
    var max: Date!
    
    var left: Event?
    var right: Event?
    var isConflicted: Bool!
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try? container.decode(String.self, forKey: .title)
        let startString = try? container.decode(String.self, forKey: .start)
        let endString = try? container.decode(String.self, forKey: .end)
        start = Formatter.customDateTime.date(from: startString!)
        end = Formatter.customDateTime.date(from: endString!)
        max = Formatter.customDateTime.date(from: endString!)
        isConflicted = false
    }
}

extension Event{
    enum CodingKeys: String, CodingKey {
        case title
        case start
        case end
        case max
    }    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(title, forKey: .title)
        try? container.encode(start, forKey: .start)
        try? container.encode(end, forKey: .end)
        try? container.encode(max, forKey: .max)
    }
}

extension Event: Comparable {
    static func < (lhs: Event, rhs: Event) -> Bool { lhs.start < rhs.start }
    static func <= (lhs: Event, rhs: Event) -> Bool { lhs.start <= rhs.start }
    static func == (lhs: Event, rhs: Event) -> Bool { lhs.start == rhs.start}
    static func > (lhs: Event, rhs: Event) -> Bool { lhs.start > rhs.start }
    static func >= (lhs: Event, rhs: Event) -> Bool { lhs.start >= rhs.start }
    static func != (lhs: Event, rhs: Event) -> Bool { lhs.title != rhs.title }
    
}

extension Event: CustomStringConvertible {
    var description: String {
        "Inicio: " + (Formatter.customDateTime.string(from: start)) + "\nFin: " + (Formatter.customDateTime.string(from: end))
    }
}
