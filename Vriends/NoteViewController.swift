//
//  GiftViewController.swift
//  Vriends
//
//  Created by Geart Otten on 26/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    var friend: Friend!
    var vriendViewController: VriendViewController!
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteInfo: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        noteInfo.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func addNote(_ sender: Any) {
        let notificationHelper = NotificationHelper.instance
        let context = CoreDataStack.instance.managedObjectContext
        let note = Note(context: context)
        
        note.title = noteTitle.text
        note.date = datePicker.date
        
        notificationHelper.setupNoteNotification(note: note)
        
        friend.addToNote(note)
        CoreDataStack.instance.saveContext()
        DataManager.shared.vriendViewController.notesArray.append(note)
    
        DataManager.shared.vriendViewController.giftNoteTableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
}
