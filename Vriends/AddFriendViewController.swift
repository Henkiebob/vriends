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
    
    var viewController = ViewController?.self

    var selectedColor: String = ""
    @IBOutlet weak var wishSlider: UISlider!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    // RRGGBB hex colors in the same order as the image
    let colorArray = [ 0xFF5E5E, 0xFFB84C, 0x38D96F, 0x7CD0EA, 0x44A9F2, 0xAC7ADE, 0xD95050, 0xD99341, 0x30B85E, 0x69B1C7, 0x3A90CE, 0x9268BD]
    let wishDateArray = [7,14,31,32]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test.text = "Één keer per maand"
        birthDatePicker.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1)
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.allowsMultipleSelection = false
        
        self.nameAndTrackingView.layer.borderWidth = 1
        self.nameAndTrackingView.layer.borderColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1).cgColor
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func otherSliderChanged(_ sender: Any) {
        switch Int(wishSlider.value) {
        case 0:
            test.text = "Elke week"
        case 1:
            test.text = "Twee keer per maand"
        case 2:
            test.text = "Één keer per maand"
        default:
            test.text = "Minder dan één keer per maand"
        }
        //test.text = String(wishDateArray[Int(wishSlider.value)])
    }
    
    @IBAction func AddFriend(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let friend = Friend(context: context)
        
        if(friendNameTextField.text != nil) {
            friend.name = friendNameTextField.text
            friend.birthdate = birthDatePicker.date
            let coupleOfDaysBack = Calendar.current.date(byAdding: .day, value: -23, to: Date())
            friend.lastSeen = coupleOfDaysBack
            friend.favoriteColor = selectedColor
            friend.wishToSee = String(wishDateArray[Int(wishSlider.value)])
            
            if(uiSwitch.isOn){
                friend.track = true
            }
            else {
                friend.track = false
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        ADataManager.shared.viewController.friendNames.append(friend.name!)
        ADataManager.shared.viewController.collectionView.reloadData()
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddFriendViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCollectionCell", for: indexPath)
        cell.layer.cornerRadius = 22.5

        cell.backgroundColor = uiColorFromHex(rgbValue: Int(colorArray[indexPath.row]))
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! colorCollectionCell
        selectedColor = String(colorArray[indexPath.row])
        cell.selectedImage.image = UIImage(named: "selected-color")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! colorCollectionCell
        
        cell.selectedImage.image = nil
    }
}
