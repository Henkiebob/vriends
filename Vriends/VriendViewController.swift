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

    var giftsArray: [Gift] = []
    var notesArray: [Note] = []

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var giftTableView: UITableView!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let userDefaults = UserDefaults(suiteName: "group.nl.vriends")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        
        let savedArray = userDefaults?.object(forKey: "SavedFriends") as? [String] ?? [String]()

        for object in savedArray{
            print(object)
        }
        
        DataManager.shared.vriendViewController = self
        
        nameLabel.text = friend.name
        giftTableView.dataSource = self
        giftTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.delegate = self
        
        if let giftForFriend = friend.gift {
            giftsArray = giftForFriend.map({$0}) as! [Gift]
        }

        if let noteForFriend = friend.note {
            notesArray = noteForFriend.map({$0}) as! [Note]
        }
        
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func deleteVriend(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print(action)
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            context.delete(self.friend)

                // save
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.navigationController?.popViewController(animated: true)

        }
        
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true) {
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        
        if tableView == self.giftTableView{
            count = giftsArray.count
        }else{
            count = notesArray.count
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: giftCells!
        var notecell: noteCells!
        
        if tableView == self.giftTableView{//This makes it so there are multiple labels in the cell to fill in the information
         cell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath) as! giftCells
        cell.giftTitle.text = giftsArray[indexPath.row].title
        cell.giftNote.text = giftsArray[indexPath.row].note
        return cell
        }else if tableView == self.noteTableView {
            notecell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! noteCells
            notecell.noteTitle.text = notesArray[indexPath.row].title
            notecell.noteText.text = notesArray[indexPath.row].text
        return notecell

        }
        return cell
        
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
