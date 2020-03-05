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
    
    // MARK: -
    convenience init(reserved: Bool = false,
                     desc: String,
                     reservationName: String,
                     reservedFrom: String,
                     reservedTo: String,
                     state: String,
                     title: String,
                     listingID: Int16,
                     reservationID: Int16,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.reserved = reserved
        self.desc = desc
        self.reservation_name = reservationName
        self.reserved_from = reservedFrom
        self.reserved_to = reservedTo
        self.state = state
        self.title = title
        self.listing_id = listingID
        self.reservation_id = reservationID
    }
    @discardableResult convenience init?(reservationRepresentation: ReservationRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let reserved = reservationRepresentation.reserved
        let desc = reservationRepresentation.desc
        let reservationName = reservationRepresentation.reservationName
        let reservedFrom = reservationRepresentation.reservedFrom
        let reservedTo = reservationRepresentation.reservedTo
        let state = reservationRepresentation.state
        let title = reservationRepresentation.title
        let listingID = reservationRepresentation.listingID
        let reservationID = reservationRepresentation.reservationID
        self.init(reserved: reserved,
                  desc: desc,
                  reservationName: reservationName,
                  reservedFrom: reservedFrom,
                  reservedTo: reservedTo,
                  state: state,
                  title: title,
                  listingID: listingID,
                  reservationID: reservationID,
                  context: context)
    }
    
    var reservationRepresentation: ReservationRepresentation? {
        return ReservationRepresentation(reserved: self.reserved,
                                         desc: self.desc!,
                                         reservationName: self.reservation_name!,
                                         reservedFrom: self.reserved_from!,
                                         reservedTo: self.reserved_to!,
                                         state: self.state!,
                                         title: self.title!,
                                         listingID: self.listing_id,
                                         reservationID: self.reservation_id)
        
    }
    
    
}
