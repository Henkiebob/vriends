//
//  GiftTableViewController.swift
//  Vriends
//
//  Created by Geart Otten on 02/06/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

class GiftTableViewController: UITableViewController {
    
    @IBOutlet weak var giftTableView: UITableView!
    
    var friend: Friend!
    var giftsArray: [Gift] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let giftForFriend = friend.gift {
//            giftsArray = giftForFriend.map({$0}) as! [Gift]
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (friend.gift?.count)!
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //This makes it so there are multiple labels in the cell to fill in the information
//        let cell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath) as! giftCells
//        cell.giftTitle.text = giftsArray[indexPath.row].title
//        cell.giftNote.text = giftsArray[indexPath.row].note
//
//        return cell
//    }
    }
}

