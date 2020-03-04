//
//  reservation+convenience.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

extension Reservation {
   


    convenience init(reserved: Bool = false,
                     desc: String,
                     reservation_name: String,
                     reserved_from: String,
                     reserved_to: String,
                     state: String,
                     title: String,
                     listing_id: Int16,
                     reservation_id: Int16,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.reserved = reserved
        self.desc = desc
        self.reservation_name = reservation_name
        self.reserved_from = reserved_from
        self.reserved_to = reserved_to
        self.state = state
        self.title = title
        self.listing_id = listing_id
        self.reservation_id = reservation_id
    }
    
    @discardableResult convenience init?(reservationRepresentation: ReservationRepresentation,
                                                context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        var reserved = reservationRepresentation.reserved
        var desc = reservationRepresentation.desc
        var reservation_name = reservationRepresentation.reservationName
        var reserved_from = reservationRepresentation.reservedFrom
        var reserved_to = reservationRepresentation.reservedTo
        var state = reservationRepresentation.state
        var title = reservationRepresentation.title
        var listing_id = reservationRepresentation.listingID
        var reservation_id = reservationRepresentation.reservationID
                   
        self.init(reserved: reserved,
                  desc: desc,
                  reservation_name: reservation_name,
                  reserved_from: reserved_from,
                  reserved_to: reserved_to,
                  state: state,
                  title: title,
                  listing_id: listing_id,
                  reservation_id: reservation_id,
                  context: context)
               
                   
                   
               
           }
    
    
}

    
