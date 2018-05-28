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
    @IBOutlet weak var greyScaleBackground: UIView!
}
class giftsCells: UITableViewCell {
    @IBOutlet weak var giftLabel: UILabel!
}
