//
//  TripModel.swift
//  Trips
//
//  Created by Egor Syrtcov on 29.11.22.
//

import UIKit

class TripModel {
    let title: String
    var image: UIImage?
    
    init(title: String, image: UIImage = UIImage(named: "defaultImageTrip")!) {
        self.title = title
        self.image = image
    }
}
