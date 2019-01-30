//
//  ViewController.swift
//  VriendsContactPage
//
//  Created by Geart Otten on 24/01/2019.
//  Copyright © 2019 Geart Otten. All rights reserved.
//

import UIKit

class FeedbackController: UIViewController {
    
    var vriendsLogoImageView: UIImageView!
    var madeWithView: UIView!
    var madeWithLabel: UILabel!
    var nameLabel: UILabel!
    var line: UIView!
    var feedbackTitleLabel: UILabel!
    var feedbackChannelLabel: UILabel!
    var supportLabel: UILabel!
    var coffeeLabel: UILabel!
    
    var myMutableString = NSMutableAttributedString()
    
    
    var names: [String] = ["Jeroen Schaper", "Geart Otten", "Tjerk Dijkstra"]
    var feedbackChannels: [String] = ["@VriendsApp", "info@vriends.frl", "www.vriends.frl"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vriendsLogoImageView = UIImageView().add(in: view)
        madeWithView = UIView().add(in: view)
        madeWithLabel = UILabel().add(in: view)
        feedbackTitleLabel = UILabel().add(in: view)
        feedbackChannelLabel = UILabel().add(in: view)
        supportLabel = UILabel().add(in: view)
        coffeeLabel = UILabel().add(in: view)
        
        vriendsLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        vriendsLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vriendsLogoImageView.image = UIImage(named: "onboarding-1")
        vriendsLogoImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        vriendsLogoImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        vriendsLogoImageView.layer.cornerRadius = 85
        vriendsLogoImageView.layer.masksToBounds = true
        
        madeWithLabel.topAnchor.constraint(equalTo: vriendsLogoImageView.bottomAnchor, constant: 30).isActive = true
        madeWithLabel.centerXAnchor.constraint(equalTo: vriendsLogoImageView.centerXAnchor).isActive = true
        
        let text = "Made with ♥︎ by:"
        
        myMutableString = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font:UIFont(
                name: "Georgia",
                size: 25.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: standardBlue, range: NSRange(location:0, length:15))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:10, length:1))
        madeWithLabel.attributedText = myMutableString
        madeWithLabel.textAlignment = .center
        madeWithLabel.font = UIFont.systemFont(ofSize: 25.0)
        
        var topAnchorOfNamesTo = madeWithLabel.bottomAnchor
        for i in 0...2{
            nameLabel = UILabel().add(in: view)
            nameLabel.topAnchor.constraint(equalTo: topAnchorOfNamesTo, constant: 10).isActive = true
            nameLabel.centerXAnchor.constraint(equalTo: madeWithLabel.centerXAnchor).isActive = true
            nameLabel.textAlignment = .center
            nameLabel.text = names[i]
            nameLabel.textColor = grayTextColor
            topAnchorOfNamesTo = nameLabel.bottomAnchor
        }
        
        feedbackTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        feedbackTitleLabel.centerXAnchor.constraint(equalTo: madeWithLabel.centerXAnchor).isActive = true
        
        feedbackTitleLabel.text = "Want to give feedback?"
        feedbackTitleLabel.textAlignment = .center
        feedbackTitleLabel.font = UIFont.systemFont(ofSize: 25.0)
        feedbackTitleLabel.textColor = standardBlue
        
        var topAnchorOfFeedbackChannels = feedbackTitleLabel.bottomAnchor
        for i in 0...2{
            feedbackChannelLabel = UILabel().add(in: view)
            feedbackChannelLabel.topAnchor.constraint(equalTo: topAnchorOfFeedbackChannels, constant: 10).isActive = true
            feedbackChannelLabel.centerXAnchor.constraint(equalTo: madeWithLabel.centerXAnchor).isActive = true
            feedbackChannelLabel.textAlignment = .center
            feedbackChannelLabel.text = feedbackChannels[i]
            feedbackChannelLabel.textColor = grayTextColor
            topAnchorOfFeedbackChannels = feedbackChannelLabel.bottomAnchor
        }
        
        
        supportLabel.topAnchor.constraint(equalTo: feedbackChannelLabel.bottomAnchor, constant: 30).isActive = true
        supportLabel.centerXAnchor.constraint(equalTo: madeWithLabel.centerXAnchor).isActive = true
        
        supportLabel.text = "Want to support us?"
        supportLabel.textAlignment = .center
        supportLabel.font = UIFont.systemFont(ofSize: 25.0)
        
        coffeeLabel.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 20).isActive = true
        coffeeLabel.centerXAnchor.constraint(equalTo: madeWithLabel.centerXAnchor).isActive = true
        
        coffeeLabel.text = "Buy us a beer :)"
        coffeeLabel.textAlignment = .center
        coffeeLabel.font = UIFont.systemFont(ofSize: 13.0)
        
    }
    
    
}
