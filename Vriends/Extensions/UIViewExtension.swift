//
//  UIViewExtension.swift
//  Vriends
//
//  Created by Geart Otten on 09/06/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func fullWidth(parent: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame.size.width = parent.frame.width
    }
    func rightSide(parent: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -20).isActive = true
    }
}
