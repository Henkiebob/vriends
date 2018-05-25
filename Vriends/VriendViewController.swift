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
    @IBOutlet weak var giftLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveGift(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        nameLabel.text = friend.name
        
        if let gift = friend.gift {
            for case let gift as Gift in gift {
                giftLabel.text = gift.note
            }
        }
        
        let gifManager = SwiftyGifManager.defaultManager
        let gif = UIImage(gifName: "Flower")
        self.imageView.setGifImage(gif, manager: gifManager, loopCount: 1)
        self.imageView.delegate = (self as SwiftyGifDelegate)
        
        let imageWidth: CGFloat = 60
        let imageHeight: CGFloat = 60
        
        imageView.frame = CGRect(x: 20, y: 300, width: imageWidth, height: imageHeight)
        view.addSubview(imageView)
    }
}
extension VriendViewController: SwiftyGifDelegate {
    func gifDidLoop(sender: UIImageView) {
        self.imageView.currentImage = UIImage(named: "F_12")
    }
}
