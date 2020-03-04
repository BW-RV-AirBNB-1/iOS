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
        return ListingRepresentation(id: id, state_id: state_id, title: title, description: description_String, price_per_day: price, photo_url: photo, landowner_ID: landowner_id, created: created, updated: updated)
}
     // MARK: - Initializers
    convenience init(land_owner: Bool? = nil,
                     desc: String? = nil,
                     latitude: String? = nil,
                     longitude: String? = nil,
                     owner: String? = nil,
                     photo_url: String? = nil,
                     state: String? = nil,
                     state_abbrv: String? = nil,
                     title: String? = nil,
                     price_per_day: Float? = nil,
                     id: Int16,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.land_owner = land_owner ?? false
            self.desc = desc
            self.lattitude = lattitude
            self.longitude = longitude
            self.owner = owner
            self.photo_url = photo_url
            self.state = state
            self.state_abbrv = state_abbrv
            self.title = title
            self.price_per_day = price_per_day ?? 0.00
            self.id = id
            
        }
        
        @discardableResult convenience init?(listingRepresentation: ListingRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
                var land_owner = listingRepresentation.landOwner
                var desc = listingRepresentation.desc
                var lattitude = listingRepresentation.lattitde
                var longitude = listingRepresentation.longitude
                var photo_url = listingRepresentation.photo_url
                var state = listingRepresentation.state
                var state_abbrv = listingRepresentation.state_abbrv
                var title = listingRepresentation.title
                var price_per_day = listingRepresentation.price_per_day
            self.init(land_owner: land_owner,
                      desc: desc,
                      latitude: lattitude,
                      longitude: longitude,
                      owner: owner,
                      photo_url: photo_url,
                      state: state,
                      state_abbrv: state_abbrv,
                      title: title,
                      price_per_day: price_per_day,
                      id: id,
                      context: context)
            
                
                
            
        }
        
    }


