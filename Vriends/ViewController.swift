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
    
    var friends: [Friend] = []
    var friendNames: [String] = []
    var flower: [String] = ["F_12.png","F_11.png", "F_10.png", "F_09.png", "F_08.png", "F_07.png", "F_06.png", "F_05.png", "F_04.png", "F_03.png", "F_02.png", "F_01.png", "F_00.png"]
    var addFriend = AddFriendViewController()
    var lastSeenTime = ""
    var lastSeenArray:[String] = []
    let formatter = DateFormatter()
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func fillFriendArray() {
        if friends.count != 0 {
            for friend in friends {
                let calendar = NSCalendar.current
                let date1 = calendar.startOfDay(for: friend.lastSeen!)
                let date2 = calendar.startOfDay(for: Date())
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                lastSeenTime = String(describing: components.day!)
                lastSeenArray.append(lastSeenTime)
                
                if(friendNames.count == 0){
                    friendNames.append(friend.name!)
                }
               
            }
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
       
                    var images = [UIImage]()
                    
                    var i = 11
                    while i > 0 {
                        i = i - 1
                        images.append(UIImage(named: flower[i])!)
                    }
                
                    cell.leaf.animationImages = images
                    cell.leaf.animationDuration = 2
                    cell.leaf.animationRepeatCount = 1
                    cell.leaf.startAnimating()
            
                    let friend = friends[indexPath.row]
                    friend.lastSeen = Date()
//                    print(lastSeenArray)
                    CoreDataStack.instance.saveContext()
            }
            return
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! friendCollectionCell
        cell.nameLabel.fullWidth(parent: cell)
        let friend = friends[indexPath.row]
        let parent = collectionView
        // compare dates and generate lastseendate
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: friend.lastSeen!)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        let badFriend = components.day! / Int(friend.wishToSee!)!
        cell.lastSeenLabel.text = String(badFriend) + " days ago"
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
    
}

class ADataManager {
    static let shared = ADataManager()
    var viewController = ViewController()
}

