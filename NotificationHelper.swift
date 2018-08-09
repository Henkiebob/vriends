//
//  NotificationHelper.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/06/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHelper {
    static let instance = NotificationHelper()

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];

    func clearUpNotifications() {
        return center.removeAllPendingNotificationRequests()
    }

    func setupPermissions() {
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("No notifications for you")
            }
        }
    }
    
    func setBirthDaySoonNotification(friend: Friend) {
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "It's \(friend.name ?? "a friend") birthday soon!"
        content.sound = UNNotificationSound.default()
        
        var triggerDate = Calendar.current.dateComponents([.day,.month,], from: friend.triggerdate!)
        triggerDate.hour = 12
        triggerDate.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let identifier = "BirthdaySoon"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func setupBirthDayNotification(friend: Friend) {
        let content = UNMutableNotificationContent()
        content.title = "Party time!"
        content.body = "It's \(friend.name ?? "a friend") birthday today!"
        content.sound = UNNotificationSound.default()
        
        var triggerDate = Calendar.current.dateComponents([.day,.month,], from: friend.birthdate!)
        triggerDate.hour = 12
        triggerDate.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let identifier = "BirthdayToday"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func setupNoteNotification(note: Note) {
        let content = UNMutableNotificationContent()
        content.title = note.title ?? "Note"
        content.body = note.text ?? "Note"
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.day,.month,.hour,.minute], from: note.date!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "Note"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func setBadFriendNotification(friend: Friend) {
        let content = UNMutableNotificationContent()
        content.title = "Oh oh.."
        content.body = "You haven't seen \(friend.name ?? "a friend") for a while now"
        content.sound = UNNotificationSound.default()
        let today_in_10_minutes = Date(timeIntervalSinceNow: 60)
        let triggerDate = Calendar.current.dateComponents([.day,.month,.hour,.minute], from: today_in_10_minutes)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let identifier = "BadFriend"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
}
