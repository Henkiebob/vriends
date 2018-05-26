//
//  VriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 31/03/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class VriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friend:Friend!
    
    var giftsArray: [String] = []

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var giftLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var giftTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveGift(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        nameLabel.text = friend.name
        giftTableView.dataSource = self
        giftTableView.delegate = self
        if let gift = friend.gift {
            for case let gift as Gift in gift {
                giftLabel.text = gift.note
                giftsArray.append(gift.note!)
//                print(giftsArray)
            }
        }
    }
    
    func tableView(_ giftTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftsArray.count
    }

    func tableView(_ giftTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row selected: \(indexPath.row)")
    }

    func tableView(_ giftTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This makes it so there are multiple labels in the cell to fill in the information
        let cell = giftTableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath) as! giftsCells
        
        let gift = giftsArray[indexPath.row]
        print(gift)
        cell.giftLabel.text = gift
        return cell
    }
}
