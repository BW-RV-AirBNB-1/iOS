//
//  listingRepresentation.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

struct ListingRepresentation: Equatable, Codable {
    
    var landOwner: Bool
    var desc: String
    var lattitde: String? = nil
    var longitude: String? = nil
    var owner: String
    var photo_url: String?
    var state: String
    var state_abbrv: String
    var title: String
    var price_per_day: Float
    var id: Int16
    
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
    var id: UUID
}
