//
//  View.swift
//  Trips
//
//  Created by Egor Syrtcov on 30.11.22.
//

import UIKit

extension UIView {
    
    func setShadow() {
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.43
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
