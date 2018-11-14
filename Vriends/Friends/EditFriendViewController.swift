//
//  EditFriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 03/08/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class EditFriendViewController: UIViewController {

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var ColorPicker: UICollectionView!
    @IBOutlet weak var BirthDatePicker: UIDatePicker!
    @IBOutlet weak var TimeSelector: UISegmentedControl!
    
    var friend: Friend!
    var selectedColor: String = ""
    var sliderchanged = false
    
    // RRGGBB hex colors in the same order as the image
    let colorArray =
        [
            0xFF5E5E,
            0xFFB84C,
            0x38D96F,
            0x7CD0EA,
            0x44A9F2,
            0xAC7ADE,
            0xD95050,
            0xD99341,
            0x30B85E,
            0x69B1C7,
            0x3A90CE,
            0x9268BD
    ]
    let wishDateArray = [7, 14, 31, 32]
    let notificationHelper = NotificationHelper.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorPicker.allowsMultipleSelection = false
        ColorPicker.delegate = self
        ColorPicker.dataSource = self
        
        // setup fields for edit
        NameTextField.text = friend.name!
        selectedColor = friend.favoriteColor!
        BirthDatePicker.date = friend.birthdate!
        
        // change segemented control accordingly
        switch Int(friend.wishToSee!) {
        case 7:
            TimeSelector.selectedSegmentIndex = 0
        case 14:
            TimeSelector.selectedSegmentIndex = 1
        case 31:
            TimeSelector.selectedSegmentIndex = 2
        default:
            TimeSelector.selectedSegmentIndex = 3
        }
    }
    
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToProfile", let destination = segue.destination as? VriendViewController {
            destination.friend = friend
        }
    }

    @IBAction func SaveFriend(_ sender: Any) {
        
        if(NameTextField.text != nil) {
            friend.name = NameTextField.text
            if(selectedColor == "") {
                friend.favoriteColor = String(colorArray[Int.random(range: 0...12)])
            } else {
                friend.favoriteColor = selectedColor
            }
        }
        
        friend.wishToSee = String(wishDateArray[TimeSelector.selectedSegmentIndex])
        
        // birthday changed so we need to do notifications
        if(friend.birthdate != BirthDatePicker.date) {
            friend.birthdate = BirthDatePicker.date
            friend.triggerdate = Calendar.current.date(byAdding: .day, value: -7, to: friend.birthdate!)
            
            // setup notifications, these repeat yearly
            notificationHelper.setBirthDaySoonNotification(friend: friend)
            notificationHelper.setupBirthDayNotification(friend: friend)
        }
        
        CoreDataStack.instance.saveContext()
        
        performSegue(withIdentifier: "BackToProfile", sender: self)
    }
    
    @IBAction func DeleteFriend(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to delete " + friend.name! + " ?", message: "This will permanently delete this friend from Vriends.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let context = CoreDataStack.instance.managedObjectContext
            context.delete(self.friend)
            CoreDataStack.instance.saveContext()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(destroyAction)
        self.present(alertController, animated: true) {}
    }

}

extension EditFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath) as! colorCollectionCell
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.backgroundColor = uiColorFromHex(rgbValue: Int(colorArray[indexPath.row]))
        
        
        if colorArray[indexPath.row] == Int(selectedColor) {
            cell.selectedImage.image = UIImage(named: "selected-color")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parent = collectionView
        return CGSize(width: (parent.frame.width / 6) - 20, height: (parent.frame.width / 6) - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! colorCollectionCell
        selectedColor = String(colorArray[indexPath.row])
        
        // away with you, stupid selected image, bit overkill but its friday 23:21 SO SUE ME
        for cell in collectionView.visibleCells as! [colorCollectionCell] {
            cell.selectedImage.image = nil
        }
        
        cell.selectedImage.image = UIImage(named: "selected-color")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! colorCollectionCell
        self.view.endEditing(true)
    
        cell.selectedImage.image = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
