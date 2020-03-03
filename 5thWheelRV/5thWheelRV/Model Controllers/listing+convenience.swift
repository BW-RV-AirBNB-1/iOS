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
    
    var listingRepresentation: ListingRepresentation? {
        guard var id: UUID = id,
            var state_id: String = state_id,
            var price: Float = price,
            var description_String: String = description_String,
            var lat: String = lat,
            var long: String = long,
            var photo: String = photo,
            var title: String = title,
            var landowner_id: Bool = landowner_id,
            var created: Date = created,
            var updated: Date = updated
        
            else { return nil}
        return ListingRepresentation(id: id, state_id: state_id, title: title, description: description_String, price_per_day: price, photo_url: photo, landowner_ID: landowner_id, created: created, updated: updated)
}
     // MARK: - Initializers
        convenience init(id: UUID = UUID(),
                         state_id: String = "",
                         price: Float = 0.00,
                         description_String: String = "",
                         lat: String = "",
                         long: String = "",
                         photo: String = "",
                         title: String = "",
                         landowner_id: Bool = false,
                         created: Date = Date(),
                         updated: Date = Date(),
                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.id = id
            self.state_id = state_id
            self.price = price
            self.description_String = description_String
            self.lat = lat
            self.long = long
            self.title = title
            self.landowner_id = landowner_id
            self.created = created
            self.updated = updated
            
        }
        
        @discardableResult convenience init?(listingRepresentation: ListingRepresentation,
                                             context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            guard var id = listingRepresentation.id,
                var state_id = listingRepresentation.state_id,
                var price = listingRepresentation.price_per_day,
                var description_String = listingRepresentation.description,
                var lat = listingRepresentation.lat,
                var long = listingRepresentation.long,
                var photo = listingRepresentation.photo_url,
                var title = listingRepresentation.title,
                var landowner_ID = listingRepresentation.landowner_ID,
                var created = listingRepresentation.created,
                var updated = listingRepresentation.updated
                else {return nil}
            self.init(id: id,
                      state_id: state_id,
                      price: price,
                      description_String: description_String,
                      lat: lat,
                      long: long,
                      photo: photo,
                      title: title,
                      landowner_id: landowner_ID,
                      created: created,
                      updated: updated,
                      context: context)
            
                
                
            
        }
        
    }


