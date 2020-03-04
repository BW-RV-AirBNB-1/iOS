//
//  listingRepresentation.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

struct ListingRepresentation: Equatable, Codable {
    
    var id: UUID?
    var state_id: String?
    var title: String?
    var description: String?
    var price_per_day: Float?
    var photo_url: String?
    var landowner_ID: Bool?
    var lat: String?
    var long: String?
    var created: Date?
    var updated: Date?
    
}

struct ListingRepresentations: Codable {
    let results: [ListingRepresentation]
}

struct UserRepresentation: Equatable, Codable {
    
    var email: String
    var password: String
    var username: String
    var isLandOwner: Bool
    var created: Date
    var id: UUID
    
    
}


struct ReservationRepresentation: Equatable, Codable {
    var dateFrom: String
    var dateTo: String
    var created: Date
    var updated: Date
    var listingID: UUID
    var rvownerID: UUID
}

struct StateRepresentation: Equatable, Codable {
    var stateAbbrv: String
    var stateName: String
    var id: UUID
}
