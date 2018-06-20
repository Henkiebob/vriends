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
    fileprivate var selectedDeck: Deck?
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        
        let friend = vriends[getFriendIndex()]
        let context = CoreDataStack.instance.managedObjectContext
        let gift = Gift(context: context)

         print(friend.name)
         print(selectedDeck?.url)
         print(selectedDeck?.title)
//        gift.title = selectedDeck?.url
//        gift.note = selectedDeck?.url
        

//        friend.addToGift(gift)
//        CoreDataStack.instance.saveContext()
        
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
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
        
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let _ = NSURL(string: urlString) {
                        self.selectedDeck?.url = urlString
                    }
                }
            })
        }
    }

}

extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(deck: Deck) {
        selectedDeck = deck
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}

