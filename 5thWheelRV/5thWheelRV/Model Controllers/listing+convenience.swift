//
//  listing+convenience.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

extension Listing {
     // MARK: - Initializers
    convenience init(landOwner: Bool = false,
                     desc: String = "",
                     latitude: String? = "",
                     longitude: String? = "",
                     owner: String = "",
                     photoURL: String? = "",
                     state: String = "",
                     stateAbbrv: String = "",
                     title: String = "",
                     pricePerDay: Float = 0.00,
                     id: Int16 = Int16(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.land_owner = landOwner
            self.desc = desc
            self.latitude = latitude
            self.longitude = longitude
            self.owner = owner
            self.photo_url = photoURL
            self.state = state
            self.state_abbrv = stateAbbrv
            self.title = title
            self.price_per_day = pricePerDay
            self.id = id
    }
    @discardableResult convenience init?(listingRepresentation: ListingRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(
            landOwner: listingRepresentation.landOwner,
            desc: listingRepresentation.desc,
            latitude: listingRepresentation.latitude,
            longitude: listingRepresentation.longitude,
            owner: listingRepresentation.owner,
            photoURL: listingRepresentation.photoURL,
            state: listingRepresentation.state,
            stateAbbrv: listingRepresentation.stateAbbrv,
            title: listingRepresentation.title,
            pricePerDay: listingRepresentation.pricePerDay,
            id: listingRepresentation.id ?? 0,
            context: context)
    }
    var listingRepresentation: ListingRepresentation? {
        return ListingRepresentation(
            id: id,
            title: title!,
            desc: desc!,
            pricePerDay: self.price_per_day,
            photoURL: self.photo_url!,
            latitude: self.latitude,
            longitude: self.longitude,
            owner: self.owner!,
            landOwner: self.land_owner,
            state: self.state!,
            stateAbbrv: self.state_abbrv!)
    }
}
