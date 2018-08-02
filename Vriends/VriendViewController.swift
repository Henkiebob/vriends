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
    var note: Note!
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
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var keepInTouchLabel: UILabel!
    
    @IBAction func RefreshFriendship(_ sender: Any) {
        friend.lastSeen = Date()
        CoreDataStack.instance.saveContext()
        
        let alert = UIAlertController(title: "You saw " + friend.name!, message: "Hope you had fun!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Woop woop", comment: "Default action"), style: .default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.vriendViewController = self
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        nameLabel.text = friend.name
        birthdayLabel.text = formatter.string(for: friend.birthdate)
        
        let calendar = NSCalendar.current
        let lastSeen = calendar.startOfDay(for: friend.lastSeen!)
        let today = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: lastSeen, to: today)
        lastTimeSeen = components.day!
        let wishToSee = Int(friend.wishToSee!)
        
        switch lastTimeSeen {
        case 0:
             lastSeenLabel.text = "Today"
        case 1:
             lastSeenLabel.text = "Yesterday"
        default:
             lastSeenLabel.text = String(lastTimeSeen) + " days ago"
        }
        
        switch wishToSee {
        case 7:
            keepInTouchLabel.text = "Weekly"
        case 14:
           keepInTouchLabel.text = "Monthly"
        case 31:
            keepInTouchLabel.text = "Every two months"
        case 32:
            keepInTouchLabel.text = "Annualy"
        default:
           keepInTouchLabel.text = "Weekly"
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
        } else {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedSegment == 1){
            let alert = UIAlertController(title: notesArray[indexPath.row].title, message: notesArray[indexPath.row].text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: giftsArray[indexPath.row].title, message: giftsArray[indexPath.row].note, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = CoreDataStack.instance.managedObjectContext
        
        if editingStyle == .delete{
            if selectedSegment == 1{
                let note = notesArray[indexPath.row]
                context.delete(note)
            }else {
                let gift = giftsArray[indexPath.row]
                context.delete(gift)
            }
            
            CoreDataStack.instance.saveContext()
            reload()
        }
        
    }
    func reload() {
        getItems()
        giftNoteTableView.reloadData()
    }
    
    func getItems() {
        let context = CoreDataStack.instance.managedObjectContext
        do {
            notesArray = try context.fetch(Note.fetchRequest())
            giftsArray = try context.fetch(Gift.fetchRequest())
        }
        catch {
            print("I can't fetch any friends from the database, hah loser!")
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
