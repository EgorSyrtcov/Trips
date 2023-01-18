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
    let placeId: String
    var note: String = "Note"
    
    init(title: String,
         image: Data,
         date: String,
         placeId: String,
         note: String
    ) {
        self.title = title
        self.image = image
        self.date = date
        self.placeId = placeId
        self.note = note
    }
}
