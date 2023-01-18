//
//  DetailCity.swift
//  Trips
//
//  Created by Egor Syrtcov on 16.01.23.
//

import Foundation

// MARK: - DetailCity
struct DetailCity: Codable {
    let result: Result
    let status: String
    
    var country: String? {
        result.addressComponents.last?.longName
    }
    
    var shortName: String? {
        result.addressComponents.last?.shortName
    }

    enum CodingKeys: String, CodingKey {
        case result, status
    }
}

// MARK: - Result
struct Result: Codable {
    let addressComponents: [AddressComponent]
    let adrAddress, formattedAddress: String
    let geometry: Geometry
    let icon: String
    let iconBackgroundColor: String
    let iconMaskBaseURI: String
    let name: String
    let photos: [Photo]
    let placeID, reference: String
    let types: [String]
    let url: String
    let utcOffset: Int
    let vicinity: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case adrAddress = "adr_address"
        case formattedAddress = "formatted_address"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name, photos
        case placeID = "place_id"
        case reference, types, url
        case utcOffset = "utc_offset"
        case vicinity, website
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location
}

// MARK: - Photo
struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}
