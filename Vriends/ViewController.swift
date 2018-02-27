//
//  ViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 26/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var friends : [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name!
        
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

