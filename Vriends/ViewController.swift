//
//  ViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    @IBOutlet weak var tableView: UITableView!
    let userDefaults = UserDefaults(suiteName: "group.nl.vriends")
    
//    let defaults = UserDefaults.standard
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
//        tableView.dataSource = self
//        tableView.delegate = self
        formatter.dateFormat = "dd/mm/yyyy"
        formatter.dateStyle = .long
        
        
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
        
        // reload!
//        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! friendCollectionCell
        
        let friend = friends[indexPath.row]
        let badFriend = Int(lastSeenArray[indexPath.row])! / Int(friend.wishToSee!)!
        
        cell.layer.cornerRadius = 8
        
        cell.leaf.image = UIImage(named: flower[badFriend])
        cell.nameLabel?.text = friend.name!
        cell.backgroundColor = addFriend.uiColorFromHex(rgbValue: Int(friends[indexPath.row].favoriteColor!)!)
        
        return cell
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return friends.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //This makes it so there are multiple labels in the cell to fill in the information
//        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
//        let friend = friends[indexPath.row]
//        let birthDate = formatter.string(from: friend.birthdate!)
//        cell.friendNameLabel?.text = friend.name!
//        cell.birthDateLabel?.text = birthDate
////        cell.lastSeenDateLabel?.text = "Days not seen: " + String(lastSeenArray[indexPath.row])
//        cell.backgroundColor = addFriend.uiColorFromHex(rgbValue: Int(friends[indexPath.row].favoriteColor!)!)
////        let badFriend = Int(lastSeenArray[indexPath.row])! / Int(friend.wishToSee!)!
////        cell.leaf.image = UIImage(named: flower[badFriend])
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        if editingStyle == .delete{
//            let friend = friends[indexPath.row]
//            context.delete(friend)
//
//            // save
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//            reload()
//        }
//    }
    


    // You really should get some friends 🔥 (sick burn)
    func getFriends() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            friends = try context.fetch(Friend.fetchRequest())
        }
        catch {
            print("I can't fetch any friends from the database, hah loser!")
        }
        
        fillFriendArray()
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
        userDefaults?.set(friendNames, forKey: "SavedFriends")
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

class ADataManager {
    static let shared = ADataManager()
    var viewController = ViewController()
}

