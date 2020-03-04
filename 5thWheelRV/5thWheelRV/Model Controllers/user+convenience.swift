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
        guard email != ""
        else {return nil}
        return UserRepresentation(
            email: email!,
            password: password!,
            username: username!,
            isLandOwner: is_land_owner,
            created: created!,
            id: id!)
    }
    
    
    convenience init(email: String = "",
                     password: String = "",
                     username: String = "",
                     isLandOwner: Bool = false,
                     created: Date = Date(),
                     id: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.email = email
            self.password = password
            self.username = username
            self.is_land_owner = isLandOwner
            self.created = created
            self.id = id
    }

        
        @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            var email = userRepresentation.email
            var password = userRepresentation.password
            var username = userRepresentation.username
            var isLandOwner = userRepresentation.isLandOwner
            var created = userRepresentation.created
            var id = userRepresentation.id
           
            self.init(email: email,
                      password: password,
                      username: username,
                      isLandOwner: isLandOwner,
                      created: created,
                      id: id,
                      context: context)
            
                
                
            
        }
        
    }

    


