//
//  GiftViewController.swift
//  Vriends
//
//  Created by Geart Otten on 26/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class GiftViewController: UIViewController, UITextViewDelegate {
    
    var friend: Friend!
    var vriendViewController: VriendViewController!
    
    @IBOutlet weak var giftTitle: UITextField!
    @IBOutlet weak var giftInfo: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftInfo.text = "Think of something awesome.."
        giftInfo.textColor = .lightGray
        
        giftInfo.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addGift(_ sender: Any) {
        let context = CoreDataStack.instance.managedObjectContext
        
        let gift = Gift(context: context)
        
        gift.title = giftTitle.text
        gift.note = giftInfo.text
        
        friend.addToGift(gift)
        CoreDataStack.instance.saveContext()
        DataManager.shared.vriendViewController.giftsArray.append(gift)
        
        DataManager.shared.vriendViewController.giftNoteTableView.reloadData()
        dismiss(animated: true, completion: nil)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
}
