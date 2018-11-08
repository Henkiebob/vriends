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
    }
}

