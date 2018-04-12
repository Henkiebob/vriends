//
//  VriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 31/03/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class VriendViewController: UIViewController {
    
    var friend:Friend!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func saveGift(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        nameLabel.text = friend.name
    }
    
}
