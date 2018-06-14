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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var darkStatusBar = true
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height)
        //    return UIScreen.main.bounds.height - (left.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
        noteInfo.text = "Your note here"
        noteInfo.textColor = .lightGray
        
        noteInfo.delegate = self
        setAnchorToViews()

        roundViews()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func setAnchorToViews() {
        let parent = self.view
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        saveButton.rightAnchor.constraint(equalTo: (parent?.rightAnchor)!, constant: -20).isActive = true
        saveButton.topAnchor.constraint(equalTo: (parent?.topAnchor)!, constant: 28).isActive = true
       
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: (parent?.centerXAnchor)!, constant: -(titleLabel.frame.width / 2)).isActive = true
        titleLabel.topAnchor.constraint(equalTo: (parent?.topAnchor)!, constant: 29).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 12).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.leftAnchor.constraint(equalTo: (parent?.leftAnchor)!, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: (parent?.topAnchor)!, constant: 29).isActive = true
        
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addNote(_ sender: Any) {
        let context = CoreDataStack.instance.managedObjectContext
        
        let note = Note(context: context)
        
        note.title = noteTitle.text
        note.text = noteInfo.text
        
        friend.addToNote(note)
        CoreDataStack.instance.saveContext()
        DataManager.shared.vriendViewController.notesArray.append(note)
    
    DataManager.shared.vriendViewController.giftNoteTableView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        toggleStatusBar()
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate methods

extension NoteViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return CardPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return CardAnimationController(isPresenting: true)
        } else {
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            
            return CardAnimationController(isPresenting: false)
        } else {
            return nil
        }
    }
    
    func toggleStatusBar() {
        if darkStatusBar {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
