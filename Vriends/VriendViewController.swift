//
//  VriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 31/03/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit
import JJFloatingActionButton

class VriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate {
    
    var friend:Friend!
    var gift: Gift!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    var lastTimeSeen = 0
    
    var selectedSegment = 1

    var giftsArray: [Gift] = []
    var notesArray: [Note] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var giftNoteTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.shared.vriendViewController = self
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        nameLabel.text = friend.name
        birthdayLabel.text = formatter.string(for: friend.birthdate)
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: friend.lastSeen!)
        let date2 = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        lastTimeSeen = components.day!
        
        switch lastTimeSeen {
        case 0:
             lastSeenLabel.text = "Today"
        case 1:
             lastSeenLabel.text = "Yesterday"
        default:
             lastSeenLabel.text = String(lastTimeSeen) + " days ago"
        }
       
        giftNoteTableView.dataSource = self
        giftNoteTableView.delegate = self
        
        if let giftForFriend = friend.gift {
            giftsArray = giftForFriend.map({$0}) as! [Gift]
        }

        if let noteForFriend = friend.note {
            notesArray = noteForFriend.map({$0}) as! [Note]
        }
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.blue
            ], for: .selected)
        
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor(red: 0.27, green: 0.66, blue: 0.95, alpha: 1)
        actionButton.layer.shadowColor = UIColor.black.cgColor
        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        actionButton.layer.shadowOpacity = Float(0.4)
        actionButton.layer.shadowRadius = CGFloat(2)
        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.itemAnimationConfiguration = .slideIn(withInterItemSpacing: 14)
        
        let addGiftButton = actionButton.addItem()
        addGiftButton.titleLabel.text = "Add gift"
        addGiftButton.imageView.image = UIImage(named: "add-gift")
        addGiftButton.action = { item in
            self.performSegue(withIdentifier: "addGiftSegue", sender: nil)
        }
        
        let addNoteButton = actionButton.addItem()
        addNoteButton.titleLabel.text = "Add note"
        addNoteButton.imageView.image = UIImage(named: "add-note")
        addNoteButton.action = { item in
            self.performSegue(withIdentifier: "addNoteSegue", sender: nil)
        }
        
        actionButton.display(inViewController: self)
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            selectedSegment = 1
        }else{
            selectedSegment = 2
        }
        giftNoteTableView.reloadData()
    }
    
    @IBAction func deleteVriend(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to delete " + friend.name! + " ?", message: "This will permanently delete this vriend from Vriends.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let context = CoreDataStack.instance.managedObjectContext
            context.delete(self.friend)
            CoreDataStack.instance.saveContext()
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(destroyAction)
        self.present(alertController, animated: true) {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedSegment == 1) {
            return notesArray.count
        } else {
            return giftsArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let giftCell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath) as! giftCells
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! noteCells
        
        if(selectedSegment == 1){
            noteCell.noteTitle.text = notesArray[indexPath.row].title
            noteCell.noteText.text = notesArray[indexPath.row].text

            return noteCell
        } else {
            giftCell.giftTitle.text = giftsArray[indexPath.row].title
            giftCell.giftNote.text = giftsArray[indexPath.row].note
            return giftCell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGiftSegue", let destination = segue.destination as? GiftViewController {
                let friend = self.friend
                destination.friend = friend
        }
        if segue.identifier == "addNoteSegue", let destination = segue.destination as? NoteViewController {
            let friend = self.friend
            destination.friend = friend
        }
    }
}

class DataManager {
    static let shared = DataManager()
    var vriendViewController = VriendViewController()
}
