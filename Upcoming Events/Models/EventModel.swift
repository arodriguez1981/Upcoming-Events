//
//  Event.swift
//  Upcoming Events
//
//  Created by Alex Rodriguez on 22/12/21.
//

import Foundation

class EventModel: Codable{
    var title : String!
    var start: Date!
    var end: Date!
    var max: Date!
    
    var left: EventModel?
    var right: EventModel?
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

extension EventModel{
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

extension EventModel: Comparable {
    static func < (lhs: EventModel, rhs: EventModel) -> Bool { lhs.start < rhs.start }
    static func <= (lhs: EventModel, rhs: EventModel) -> Bool { lhs.start <= rhs.start }
    static func == (lhs: EventModel, rhs: EventModel) -> Bool { lhs.start == rhs.start}
    static func > (lhs: EventModel, rhs: EventModel) -> Bool { lhs.start > rhs.start }
    static func >= (lhs: EventModel, rhs: EventModel) -> Bool { lhs.start >= rhs.start }
    static func != (lhs: EventModel, rhs: EventModel) -> Bool { lhs.title != rhs.title }
    
}

extension EventModel: CustomStringConvertible {
    var description: String {
        "Inicio: " + (Formatter.customDateTime.string(from: start)) + "\nFin: " + (Formatter.customDateTime.string(from: end))
    }
}
