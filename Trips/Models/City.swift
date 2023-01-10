//
//  City.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.01.23.
//

import Foundation

// MARK: - City
struct City: Codable {
    let candidates: [Candidate]
    let status: String
}

// MARK: - Candidate
struct Candidate: Codable {
    let address: String

    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
    }
}
