//
//  FriendCell.swift
//  Vriends
//
//  Created by Geart Otten on 02/03/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

class FriendCell: UITableViewCell{
    @IBOutlet weak var leaf: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
}
class giftCells: UITableViewCell {
    @IBOutlet weak var giftTitle: UILabel!
    @IBOutlet weak var giftNote: UILabel!
}
class noteCells: UITableViewCell {
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteText: UILabel!
    
}
class friendCollectionCell: UICollectionViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leaf: UIImageView!
}

class colorCollectionCell: UICollectionViewCell{
    @IBOutlet weak var selectedImage: UIImageView!
}
