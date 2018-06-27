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

    var friends: [Friend] = []
    var friendNames: [String] = []
    var flower: [String] = ["F_12.png","F_11.png", "F_10.png", "F_09.png", "F_08.png", "F_07.png", "F_06.png", "F_05.png", "F_04.png", "F_03.png", "F_02.png", "F_01.png", "F_00.png"]
    var addFriend = AddFriendViewController()
    var lastSeenTime = ""
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        isAppAlreadyLaunchedOnce()

        collectionView.dataSource = self
        collectionView.delegate = self
        formatter.dateFormat = "dd/mm/yyyy"
        formatter.dateStyle = .long

        notificationHelper.setupPermissions()

        //Anchors make collection view as big as the screen its on
        let parent = self.view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalToConstant: (parent?.frame.width)!).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: (parent?.frame.height)!).isActive = true
        ADataManager.shared.viewController = self
        self.navigationItem.setHidesBackButton(true, animated:true);

    }

    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
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
        // Dispose of any resources that can be recreated.
    }

    func reload() {
        getFriends()
        
        // @TODO add a check if the user actually agreed to receive notifications..
        notificationHelper.setupBirthDaySoonNotifications(friends: friends)
        notificationHelper.friendShipFailingNotifications(friends: friends)

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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

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
        let weekOfYearNow = calendar.component(.weekOfYear, from: Date())
        let weekOfYearBirthDay = calendar.component(.weekOfYear, from: birthdate!)

        if (weekOfYearNow == (weekOfYearBirthDay + 1)) {
            cell.birthdayImage.image = UIImage(named: "birthday-gift" )
        } else {
            cell.birthdayImage.image = nil
        }

        cell.nameLabel.fullWidth(parent: cell)
        let friend = friends[indexPath.row]

        //Put birthday to this year and check the days between
        let date1 = calendar.startOfDay(for: friend.lastSeen!)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)

        let lastSeen = components.day!
        let badFriend = components.day! / Int(friend.wishToSee!)!
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
