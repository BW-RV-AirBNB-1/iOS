//
//  listingRepresentation.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

struct ListingRepresentation: Codable, Equatable {
    var id: Int16
    var title, desc: String
    var price_per_day: Float
    var photo_url: String
    var latitude, longitude: String?
    var owner: String
    var land_owner: Bool
    var state, state_abbrv: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case desc = "description"
        case price_per_day = "price_per_day"
        case photo_url = "photo_url"
        case latitude, longitude, owner
        case land_owner = "land_owner"
        case state
        case state_abbrv = "state_abbrv"
    }
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}

struct UserRepresentation: Equatable, Codable {
    
    var id: Int16
    var is_land_owner: Bool
    var username: String
    var password: String
    
}


struct ReservationRepresentation: Equatable, Codable {
    var reserved: Bool
    var desc: String
    var reservationName: String
    var reservedFrom: String
    var reservedTo: String
    var state: String
    var title: String
    var listingID: Int16
    var reservationID: Int16
}

struct StateRepresentation: Equatable, Codable {
    var stateAbbrv: String
    var stateName: String
    var id: Int16
}
