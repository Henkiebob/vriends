//
//  AddFriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 27/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//
import UIKit

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var nameAndTrackingView: UIView!
    @IBOutlet weak var friendNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var wishSlider: UISlider!
    @IBOutlet weak var wishToSeeLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var viewController = ViewController?.self
    var selectedColor: String = ""
    
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
        friendNameTextField.delegate = self
        wishToSeeLabel.text = "It's been more then a month"
        birthDatePicker.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.allowsMultipleSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func otherSliderChanged(_ sender: Any) {
        switch Int(wishSlider.value) {
        case 0:
            wishToSeeLabel.text = "Weekly"
        case 1:
            wishToSeeLabel.text = "Monthly"
        case 2:
            wishToSeeLabel.text = "Every two months"
        default:
            wishToSeeLabel.text = "Annualy"
        }
    }
    
    @IBAction func AddFriend(_ sender: Any) {
        let context = CoreDataStack.instance.managedObjectContext
        let friend = Friend(context: context)
        
        
        if(friendNameTextField.text != nil) {
            friend.name = friendNameTextField.text
            friend.birthdate = birthDatePicker.date
            friend.lastSeen = Date()
            friend.triggerdate = Calendar.current.date(byAdding: .day, value: -7, to: friend.birthdate!)
            
            // debug
            //let coupleOfDaysBack = Calendar.current.date(byAdding: .day, value: -80, to: Date())
            //friend.lastSeen = coupleOfDaysBack
            
            if(selectedColor == ""){
                friend.favoriteColor = String(colorArray[Int.random(range: 0...12)])
            } else {
                friend.favoriteColor = selectedColor
            }
            friend.wishToSee = String(wishDateArray[Int(wishSlider.value)])
        }
        
        CoreDataStack.instance.saveContext()
        
        // alert that we have saved so the viewcontroller knows waddup
        NotificationCenter.default.post(name: NSNotification.Name("save"), object: self)
        
        // setup notifications, these repeat yearly
        notificationHelper.setBirthDaySoonNotification(friend: friend)
        notificationHelper.setupBirthDayNotification(friend: friend)
        ADataManager.shared.viewController.friendNames.append(friend.name!)
        navigationController!.popViewController(animated: true)
    }
    
    
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension AddFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath)
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.backgroundColor = uiColorFromHex(rgbValue: Int(colorArray[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parent = collectionView
        return CGSize(width: (parent.frame.width / 6) - 20, height: (parent.frame.width / 6) - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! colorCollectionCell
        selectedColor = String(colorArray[indexPath.row])
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
