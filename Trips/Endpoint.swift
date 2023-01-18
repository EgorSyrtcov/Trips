//
//  Endpoint.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.01.23.
//

import Foundation

enum Endpoint: String {
    case findPlace = "maps.googleapis.com/maps/api/place/autocomplete/json"
    case detailPlace = "maps.googleapis.com/maps/api/place/details/json"
}
