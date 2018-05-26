//
//  RoundedView.swift
//  Vriends
//
//  Created by Geart Otten on 26/05/2018.
//  Copyright © 2018 Tjerk Dijkstra. All rights reserved.
//

import UIKit

class RoundedView: UIView{
    override public func layoutSubviews() {
        super.layoutSubviews()
        let roundCorners = CAShapeLayer()
        roundCorners.frame = self.bounds
        roundCorners.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.topLeft], cornerRadii: CGSize(width: 25, height: 25)).cgPath
        self.layer.mask = roundCorners
        
    }
}
