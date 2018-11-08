//
//  ViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let formatter = DateFormatter()
    let notificationHelper = NotificationHelper.instance
    let NO_FRIEND_TAG = 1;

    var friends: [Friend] = []
    var friendNames: [String] = []
    var flower: [String] = ["F_12.png","F_11.png", "F_10.png", "F_09.png", "F_08.png", "F_07.png", "F_06.png", "F_05.png", "F_04.png", "F_03.png", "F_02.png", "F_01.png", "F_00.png"]
    var addFriend = AddFriendViewController()
    var lastSeenTime = ""
    var lastTimeSeen = 0
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = isAppAlreadyLaunchedOnce()
        collectionView.dataSource = self
        collectionView.delegate = self
        formatter.dateFormat = "dd/mm/yyyy"
        formatter.dateStyle = .long
        notificationHelper.setupPermissions()
        
        NotificationCenter.default.addObserver(forName: .save, object: nil, queue: .main) {_ in
            self.view.viewWithTag(self.NO_FRIEND_TAG)?.isHidden = true
        }
        
        
    }
    
    func isAppAlreadyLaunchedOnce()->Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            performSegue(withIdentifier: "FirstLaunchSegue", sender: self)
            return false
        }
    }
    
    func dismiss(_ segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reload() {
        getFriends()
        collectionView.reloadData()
        
        // create no friends label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 200, y: 285)
        label.textAlignment = .center
        label.text = "No friends yet, add some!"
        label.tag = NO_FRIEND_TAG
        
        if(friends.count == 0) {
            self.view.addSubview(label)
        }
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 13.33, bottom: 10, right: 13.33)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! friendCollectionCell
        let calendar = NSCalendar.current
        let friend = friends[indexPath.row]
        let lastSeenDate = calendar.startOfDay(for: friend.lastSeen!)
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: lastSeenDate, to: today)
        
        var badFriend = components.day! / Int(friend.wishToSee!)!
        
        // can't be higher then 12
        if badFriend > 12 {
            badFriend = 12
        }
        
        // can't get this to work quite yet, its still beta
        if badFriend > 7 {
            notificationHelper.setBadFriendNotification(friend: friend)
        }
        
        cell.layer.cornerRadius = 8
        cell.leaf.image = UIImage(named: flower[badFriend])
        cell.nameLabel?.text = friend.name!
        cell.backgroundColor = addFriend.uiColorFromHex(rgbValue: Int(friends[indexPath.row].favoriteColor!)!)
        cell.nameLabel.fullWidth(parent: cell)

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

class ADataManager {
    static let shared = ADataManager()
    var viewController = ViewController()
}


extension Notification.Name {
    static let save = Notification.Name("save")
}
