//
//  AddFriendViewController.swift
//  Vriends
//
//  Created by Tjerk Dijkstra on 27/02/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {

    @IBOutlet weak var friendNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var viewController = ViewController?

    @IBOutlet weak var selectedColor: UIView!
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var wishSlider: UISlider!
    @IBOutlet weak var test: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    // RRGGBB hex colors in the same order as the image
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    let wishDateArray = [7,14,31,32]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        selectedColor.backgroundColor = uiColorFromHex(rgbValue: colorArray[Int(colorSlider.value)])
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
        let gift = Gift(context: context)
//
//        gift.note = "Taart 2"
        
        if(friendNameTextField.text != nil) {
            friend.name = friendNameTextField.text
            friend.birthdate = birthDatePicker.date
            let coupleOfDaysBack = Calendar.current.date(byAdding: .day, value: -23, to: Date())
            friend.lastSeen = coupleOfDaysBack
            friend.favoriteColor = String(colorArray[Int(colorSlider.value)])
            friend.wishToSee = String(wishDateArray[Int(wishSlider.value)])
            
            if(uiSwitch.isOn){
                friend.track = true
            }
            else {
                friend.track = false
            }
//            friend.addToGift(gift)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
