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
    var friends : [Friend] = []
    
    var lastSeenTime = ""
    
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.dateStyle = .short
        
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
            let calendar = NSCalendar.current
            let date1 = calendar.startOfDay(for: friends[0].lastSeen!)
            let date2 = calendar.startOfDay(for: Date())
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            lastSeenTime = String(describing: components)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This makes it so there are multiple labels in the cell to fill in the information
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        let friend = friends[indexPath.row]
        let birthDate = formatter.string(from: friend.birthdate!)
        cell.friendNameLabel?.text = friend.name!
        cell.birthDateLabel?.text = birthDate
        //lastSeenTime contains days: <amount> LeapYear: true or false. Lets try to change that so we only get that amount
        cell.lastSeenDateLabel?.text = "Days not seen: " + lastSeenTime
        
        // This doesn't show any birthdate, somehow i dunno man
        //cell.textLabel?.text =  DateFormatter().string(from: friend.birthdate!)
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

}

