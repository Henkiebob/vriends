//
//  ViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var friends: [Friend] = []
    var flower: [String] = ["F_12.png","F_11.png", "F_10.png", "F_09.png", "F_08.png", "F_07.png", "F_06.png", "F_05.png", "F_04.png", "F_03.png", "F_02.png", "F_01.png", "F_00.png"]
    
    var addFriend = AddFriendViewController()
    
    var lastSeenTime = ""
    var lastSeenArray:[String] = []
    
    let formatter = DateFormatter()
    
    var i = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        formatter.dateFormat = "dd/mm/yyyy"
        formatter.dateStyle = .long
        

        // Do any additional setup after loading the view, typically from a nib.
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
        tableView.reloadData()
        
        //print(friends[0].birthdate!)
        //yayy you got friends
        //print("you have " + String(friends.count) + " friends" )
        
        //Checks Last seen date and date now and calculates the diffrence
        if friends.count != 0{
            for friend in friends {
                let calendar = NSCalendar.current
                let date1 = calendar.startOfDay(for: friend.lastSeen!)
                let date2 = calendar.startOfDay(for: Date())
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                lastSeenTime = String(describing: components.day!)
                lastSeenArray.append(lastSeenTime)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row selected: \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This makes it so there are multiple labels in the cell to fill in the information
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
        let birthDate = formatter.string(from: friend.birthdate!)
        cell.friendNameLabel?.text = friend.name!
        cell.birthDateLabel?.text = birthDate
        cell.lastSeenDateLabel?.text = "Days not seen: " + String(lastSeenArray[indexPath.row])
        cell.backgroundColor = addFriend.uiColorFromHex(rgbValue: Int(friends[indexPath.row].favoriteColor!)!)
        let badFriend = Int(lastSeenArray[indexPath.row])! / Int(friend.wishToSee!)!
        cell.leaf.image = UIImage(named: flower[badFriend])
                
        switch (lastSeenArray[indexPath.row]) {
        case "1":
            cell.greyScaleBackground.alpha = 0.1
        case "5":
            cell.greyScaleBackground.alpha = 0.7
        default:
            cell.greyScaleBackground.alpha = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete{
            let friend = friends[indexPath.row]
            context.delete(friend)
            
            // save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            reload()
        }
    }
    // You really should get some friends 🔥 (sick burn)
    func getFriends() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            friends = try context.fetch(Friend.fetchRequest())
        }
        catch {
            print("I can't fetch any friends from the database, hah loser!")
        }
        
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test"
        {
            let friend = friends[0].name
            
            
        }
    }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainToProfileSegue", let destination = segue.destination as? VriendViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                var friend = friends[indexPath.row]
                destination.friend = friend
            }
        }
    }

}

