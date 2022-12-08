//
//  TripModel.swift
//  Trips
//
//  Created by Egor Syrtcov on 29.11.22.
//

import UIKit

class TripModel: Codable {
    let title: String
    var image: Data
    let date: String
    
    init(title: String,
         image: Data,
         date: String
    ) {
        self.title = title
        self.image = image
        self.date = date
    }
}
