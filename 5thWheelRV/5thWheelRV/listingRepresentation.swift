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
    var title: String
    var desc: String
    var pricePerDay: Float
    var photoURL: String
    var latitude, longitude: String?
    var owner: String
    var landOwner: Bool
    var state, stateAbbrv: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case desc = "description"
        case pricePerDay = "price_per_day"
        case photoURL = "photo_url"
        case latitude, longitude, owner
        case landOwner = "land_owner"
        case state
        case stateAbbrv = "state_abbrv"
    }
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}

struct UserRepresentation: Codable, Equatable {
    var id: Int16
    var username: String
    var isLandOwner: Bool
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
    var stateAbbreviation: String
    var stateName: String
    var id: Int16
}
struct ValidLogon: Equatable {
       var user: [User]
       var token: String
   }
