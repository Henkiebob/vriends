//
//  GiftViewController.swift
//  Vriends
//
//  Created by Geart Otten on 26/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

class GiftViewController: UIViewController{
    
    var friend: Friend!
    
    @IBOutlet weak var giftTitleTextField: UITextField!
    @IBOutlet weak var giftNoteTextView: UITextView!
    
    override func viewDidLoad() {
    }
    
    @IBAction func AddGift(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
        let gift = Gift(context: context)
        
        gift.title = giftTitleTextField.text
        gift.note = giftNoteTextView.text
        
        print(gift)
            
        friend.addToGift(gift)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "addGiftToProfileSegue", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGiftToProfileSegue", let destination = segue.destination as? VriendViewController {
                var friend = self.friend
                destination.friend = friend
        }
    }
    
}
