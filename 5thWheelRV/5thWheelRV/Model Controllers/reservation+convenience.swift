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
   


  convenience init(dateFrom: String = "",
                     dateTo: String = "",
                     created: Date = Date(),
                     updated: Date = Date(),
                     id: UUID = UUID(),
                     listingID: UUID = UUID(),
                     rvownerID: UUID =  UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    self.init(context: context)
    self.date_from = dateFrom
    self.date_to = dateTo
    self.created = created
    self.id = id
    self.listing_id = listingID
    self.rvowner_id = rvownerID
    }
    
    @discardableResult convenience init?(reservationRepresentation: ReservationRepresentation,
                                                context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
                    var dateFrom = reservationRepresentation.dateFrom
                    var dateTo = reservationRepresentation.dateTo
                    var created = reservationRepresentation.created
                    var updated = reservationRepresentation.updated
                    var listingID = reservationRepresentation.listingID
                    var rvownerID = reservationRepresentation.rvownerID
                   
        self.init(dateFrom: dateFrom,
                  dateTo: dateTo,
                  created: created,
                  updated: updated,
                  listingID: listingID,
                  rvownerID: rvownerID,
                  context: context)
               
                   
                   
               
           }
    
    
}

    
