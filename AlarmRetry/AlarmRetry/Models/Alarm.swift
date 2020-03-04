//
//  Alarm.swift
//  AlarmRetry
//
//  Created by Anthroman on 3/3/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    
    init(fireDate: Date, name: String, enabled: Bool) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = UUID().uuidString
    }
    
    var fireTimeAsString: String {
        return "\(fireDate.formatted)"
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
