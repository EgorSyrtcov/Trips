//
//  City.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.01.23.
//

import Foundation

// MARK: - CityResponse
struct CityResponse: Codable {
    let сities: [City]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case сities = "predictions"
        case status
    }}

// MARK: - City
struct City: Codable {
    let description: String
    let placeID: String

    enum CodingKeys: String, CodingKey {
        case description
        case placeID = "place_id"
    }
}
