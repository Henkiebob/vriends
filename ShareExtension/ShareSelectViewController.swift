//
//  ShareSelectViewController.swift
//  ShareExtension
//
//  Created by Tjerk Dijkstra on 30/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

protocol ShareSelectViewControllerDelegate: class {
    func selected(deck: Deck)
}

class ShareSelectViewController : UIViewController {
    
    weak var delegate: ShareSelectViewControllerDelegate?
    var userDecks = [Deck]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self as! UITableViewDataSource
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.DeckCell)
        tableView.delegate = self as! UITableViewDelegate
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        title = "Select Deck"
        view.addSubview(tableView)
    }
    
}

private extension ShareSelectViewController {
    struct Identifiers {
        static let DeckCell = "deckCell"
    }
}

extension ShareSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDecks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.DeckCell, for: indexPath)
        cell.textLabel?.text = userDecks[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
}

extension ShareSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(deck: userDecks[indexPath.row])
    }
}


