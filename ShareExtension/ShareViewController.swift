//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Tjerk Dijkstra on 30/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import CoreMedia

class ShareViewController: SLComposeServiceViewController {
    var vriends: [Friend] = []
    
    var userDecks = [Deck]()
    var store = CoreDataStack.instance
    
    private var textString: String?
    
    fileprivate var selectedDeck: Deck?
    
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        let friend = vriends[getFriendIndex()]
        guard let giftText = textView.text else {return}
        
        store.storeGifts(withTitle: "from safari", withText: giftText, withFriend: friend)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func getFriendIndex() -> Int{
        // find the selected friend
        for (index, selectedFriend) in vriends.enumerated() {
            if(selectedFriend.name == selectedDeck?.title) {
                return index
            }
        }
        return 0
    }

    override func configurationItems() -> [Any]! {
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "Geselecteerde vriend"
            deck.value = selectedDeck?.title
            deck.tapHandler = {
                let vc = ShareSelectViewController()
                vc.userDecks = self.userDecks
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            
            return [deck]
        }
        return nil
    }
    
    override func viewDidLoad() {
    
        let context = CoreDataStack.instance.managedObjectContext
        do {
            vriends = try context.fetch(Friend.fetchRequest())
        }
        catch {
            print("I can't fetch any friends from the database, hah loser!")
        }
        for friend in vriends {
            let deck = Deck()
            deck.title = friend.name
            userDecks.append(deck)
        }
        
        selectedDeck = userDecks.first
    }

}

extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(deck: Deck) {
        selectedDeck = deck
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}

