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
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
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
        
        // Loading friends and adding them to the sharetable as options
        // MARK get friends and add them to userdecks
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
                        print("URL retrieved: \(urlString)")
                    }
                }
            })
        } else {
            print("error")
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

