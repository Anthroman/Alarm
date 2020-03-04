//
//  AlarmController.swift
//  AlarmRetry
//
//  Created by Anthroman on 3/3/20.
//  Copyright © 2020 Anthroman. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default
        
        var date = DateComponents()
        date.hour = 8
        date.minute = 30
        let uuid = alarm.uuid
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {

    //shared instance
    static let sharedInstance = AlarmController()
    
    init() {
        loadFromPersistence()
    }
    
    //source of truth
    var alarms: [Alarm] = []
    
    //MARK: - CRUD
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let alarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(alarm)
        saveToPersistentStorage(alarms: alarms)
        scheduleUserNotifications(for: alarm)
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStorage(alarms: alarms)
        scheduleUserNotifications(for: alarm)
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistentStorage(alarms: alarms)
        cancelUserNotification(for: alarm)
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotification(for: alarm)
        }
    }

    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "AlarmRetry.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage(alarms: [Alarm]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([Alarm].self, from: data)
            self.alarms = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }

}

