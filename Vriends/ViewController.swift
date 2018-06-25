//
//  ViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var friends: [Friend] = []
    var friendNames: [String] = []
    var flower: [String] = ["F_12.png","F_11.png", "F_10.png", "F_09.png", "F_08.png", "F_07.png", "F_06.png", "F_05.png", "F_04.png", "F_03.png", "F_02.png", "F_01.png", "F_00.png"]
    var addFriend = AddFriendViewController()
    var lastSeenTime = ""
    
    let formatter = DateFormatter()
    var i = 0
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("No notifications for you")
            }
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        // lets clear up those pesky notifications
        center.removeAllPendingNotificationRequests()
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        formatter.dateFormat = "dd/mm/yyyy"
        formatter.dateStyle = .long
        
        //Anchors make collection view as big as the screen its on
        let parent = self.view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalToConstant: (parent?.frame.width)!).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: (parent?.frame.height)!).isActive = true
        
        ADataManager.shared.viewController = self
        
    }
    
    func dismiss(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        // if this returns nothing.. 😢
        getFriends()

        collectionView.reloadData()
    }
    
    // You really should get some friends 🔥 (sick burn)
    func getFriends() {
        let context = CoreDataStack.instance.managedObjectContext
        do {
            friends = try context.fetch(Friend.fetchRequest())
        }
        catch {
            print("I can't fetch any friends from the database, hah loser!")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToProfileSegue", let destination = segue.destination as? VriendViewController {
            if let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
                let friend = friends[indexPath.row]
                destination.friend = friend
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! friendCollectionCell

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        
        cell.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer : UILongPressGestureRecognizer!) {
        
        if gestureReconizer.state != .ended {
            let p = gestureReconizer.location(in: self.collectionView)
            
            if let indexPath = self.collectionView.indexPathForItem(at: p) {
                let cell = self.collectionView.cellForItem(at: indexPath) as! friendCollectionCell
                
                cell.leaf.image = UIImage(named: flower[0])
   
                let friend = friends[indexPath.row]
                friend.lastSeen = Date()
                
                cell.leaf.rotate360Degrees()
                CoreDataStack.instance.saveContext()
            }
            return
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 13.33, bottom: 10, right: 13.33)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! friendCollectionCell
        let calendar = NSCalendar.current
        let birthdate = friends[indexPath.row].birthdate
        let notification_name = friends[indexPath.row].name
        let weekOfYearNow = calendar.component(.weekOfYear, from: Date())
        
        let weekOfYearBirthDay = calendar.component(.weekOfYear, from: birthdate!)
        if (weekOfYearNow == (weekOfYearBirthDay + 1)){
            cell.birthdayImage.image = UIImage(named: "birthday-gift" )
            
            let triggerForSoon = UNTimeIntervalNotificationTrigger(timeInterval: 3600,
                                                            repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Don't forget!"
            content.body = "It's \(notification_name ?? "a friend") birthday soon"
            content.sound = UNNotificationSound.default()
            //content.badge = 1
            
            let identifier = "BirthdaySoon"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: triggerForSoon)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    print("not added")
                }
            })
            
            
        }else{
            cell.birthdayImage.image = nil
        }
        
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
        
        cell.nameLabel.fullWidth(parent: cell)
        let friend = friends[indexPath.row]
        let parent = collectionView
        
        //Put birthday to this year and check the days between
        let date1 = calendar.startOfDay(for: friend.lastSeen!)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        var lastSeen = components.day!
        let badFriend = components.day! / Int(friend.wishToSee!)!
        
        if(badFriend > 9) {
            let date = Date(timeIntervalSinceNow: 3600)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Oh oh.."
            content.body = "You haven't seen \(notification_name ?? "a friend") in a while!"
            content.sound = UNNotificationSound.default()
            
            let identifier = "SeeFriend"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    print("not added")
                }
            })
        }
        
        cell.lastSeenLabel.text = String(lastSeen) + " days ago"
        cell.layer.cornerRadius = 8
        
        cell.leaf.image = UIImage(named: flower[badFriend])
        
        cell.nameLabel?.text = friend.name!
        cell.backgroundColor = addFriend.uiColorFromHex(rgbValue: Int(friends[indexPath.row].favoriteColor!)!)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parent2 = collectionView
        return CGSize(width: parent2.frame.width / 2 - 20, height: parent2.frame.width / 2 - 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 0.5, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 5.0)
        rotateAnimation.duration = duration
        
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

class ADataManager {
    static let shared = ADataManager()
    var viewController = ViewController()
}

