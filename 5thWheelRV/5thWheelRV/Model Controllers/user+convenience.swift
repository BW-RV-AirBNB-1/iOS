//
//  user+convenience.swift
//  5thWheelRV
//
//  Created by Lambda_School_Loaner_268 on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

extension User {
    var userRepresentation: UserRepresentation? {
        
        guard var password = password,
        username = username
    }
    
    
    convenience init(id: Int16,
                     is_land_owner: Bool? = nil,
                     password: String? = nil,
                     username: String? = nil,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.id = id
            self.password = password
            self.username = username
            self.is_land_owner = is_land_owner ?? false
    }

        
        @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            var id = userRepresentation.id
            var is_land_owner = userRepresentation.is_land_owner
            var username = userRepresentation.username
            var password = userRepresentation.password
           
            self.init(id: id,
                      is_land_owner: is_land_owner,
                      password: password,
                      username: username,
                      context: context)
            
                
                
            
        }
        
    }

    


