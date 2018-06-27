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
    
    func setupBirthDaySoonNotifications(friends: [Friend]) {
        for friend in friends{
            if( isBirthDayNextWeek(birthdate: friend.birthdate!) ) {
                let triggerForSoon = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                                       repeats: false)
                let content = UNMutableNotificationContent()
                content.title = "Don't forget!"
                content.body = "It's \(friend.name ?? "a friend") birthday next week"
                content.sound = UNNotificationSound.default()

                let identifier = "BirthdaySoon"
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: triggerForSoon)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
    }
    
    func setupBirthdayTodayNotifications(friends: [Friend]) {
//        let content = UNMutableNotificationContent()
//        content.title = "Don't forget"
//        content.body = "It's \(notification_name ?? "a friend") birthday today!"
//        content.sound = UNNotificationSound.default()
//
//        let triggerDate = Calendar.current.dateComponents([.day,.month,], from: birthdate!)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//        let identifier = "Birthday today"
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: content, trigger: trigger)
//        center.add(request, withCompletionHandler: { (error) in
//            if let error = error {
//                // Something went wrong
//                print("not added")
//            }
//        })
    }
    
    func friendShipFailingNotifications(friends: [Friend]) {
        for friend in friends {
            let calendar = NSCalendar.current
            let date1 = calendar.startOfDay(for: friend.lastSeen!)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            let badFriend = components.day! / Int(friend.wishToSee!)!
            
            if(badFriend > 9) {
                let date = Date(timeIntervalSinceNow: 30)
                let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let content = UNMutableNotificationContent()
                content.title = "Oh oh.."
                content.body = "You haven't seen \(friend.name ?? "a friend") in a while!"
                content.sound = UNNotificationSound.default()

                let identifier = "SeeFriend"
                let request = UNNotificationRequest(identifier: identifier,
                                                    content: content, trigger: trigger)
                center.add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
            }
        }
    }
    
    private func isBirthDayNextWeek(birthdate: Date) -> Bool {
        let today = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let weekfromnow = cal!.date(byAdding: NSCalendar.Unit.day, value: 7, to: today as Date, options: NSCalendar.Options.matchLast)
        
        // so let's check if the birthweek is the same as a week from now
        let birthweek = NSCalendar.current.component(.weekOfYear, from: birthdate)
        let nextweek  = NSCalendar.current.component(.weekOfYear, from: weekfromnow!)
        
        if(birthweek == nextweek) {
            return true
        } else {
            return false
        }
    }
}
